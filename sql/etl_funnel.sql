-- This script aggregates and analyzes the user journey through the main funnel stages:
-- Home Page Visit -> Search -> Payment -> Payment Confirmation.
-- It produces both wide and long formats for reporting and visualization,
-- and prepares data for device-based comparison.

-- Step 1: Gather funnel data by joining all relevant tables.
WITH funnel_data AS (
    SELECT u.date,
        u.device,
        u.sex,
        h.user_id AS home_visits,
        s.user_id AS searches,
        p.user_id AS payments,
        pc.user_id AS confirmations
    FROM home_page_table h
        LEFT JOIN user_table u ON h.user_id = u.user_id
        LEFT JOIN search_page_table s ON h.user_id = s.user_id
        LEFT JOIN payment_page_table p ON h.user_id = p.user_id
        LEFT JOIN payment_confirmation_table pc ON h.user_id = pc.user_id
),

-- Step 2: Calculate funnel counts grouped by device.
conversions_counts_by_device AS (
    SELECT device,
        COUNT(DISTINCT home_visits) AS total_home,
        COUNT(DISTINCT searches) AS total_searches,
        COUNT(DISTINCT payments) AS total_payments,
        COUNT(DISTINCT confirmations) AS total_confirmations
    FROM funnel_data
    GROUP BY device
),

-- Step 3: Calculate overall funnel counts (all devices combined).
conversions_counts_overall AS (
    SELECT 'Overall' AS device,
        COUNT(home_visits) AS total_home,
        COUNT(searches) AS total_searches,
        COUNT(payments) AS total_payments,
        COUNT(confirmations) AS total_confirmations
    FROM funnel_data
),

-- Step 4: Combine overall and device-level counts for unified reporting.
all_counts AS (
    SELECT *
    FROM conversions_counts_overall
    UNION ALL
    SELECT *
    FROM conversions_counts_by_device
),

-- Step 5: Calculate conversion rates for each funnel stage.
all_rates AS (
    SELECT device,
        total_home,
        total_searches,
        total_payments,
        total_confirmations,
        100.0 AS home_rate,
        -- Home is always 100% as the funnel starts here
        total_searches / NULLIF(total_home, 0) * 100 AS search_rate,
        total_payments / NULLIF(total_searches, 0) * 100 AS payments_rate,
        total_confirmations / NULLIF(total_payments, 0) * 100 AS confirmations_rate
    FROM all_counts
) 

-- Step 6: Wide format output for funnel analysis.
-- Each row shows the counts and conversion rates for each device (and overall).
SELECT *
FROM all_rates
ORDER BY CASE
        WHEN device = 'Overall' THEN 0
        ELSE 1
    END,
    device;

-- Step 7: Long format output for visualization (line chart).
-- Each row represents a funnel step for a device, making it easier to plot the funnel drop-off.
SELECT device,
    'home' AS step,
    total_home AS total
FROM all_counts
UNION ALL
SELECT device,
    'search',
    total_searches
FROM all_counts
UNION ALL
SELECT device,
    'payment',
    total_payments
FROM all_counts
UNION ALL
SELECT device,
    'confirmation',
    total_confirmations
FROM all_counts
ORDER BY CASE
        WHEN device = 'Overall' THEN 0
        ELSE 1
    END,
    device,
    FIELD(
        step,
        'home',
        'search',
        'payment',
        'confirmation'
    );


-- Step 8: Device comparison table for visualization.
-- This aggregates the funnel steps for Desktop and Mobile devices only.

SELECT step,
    SUM(
        CASE
            WHEN device = 'Desktop' THEN total
            ELSE 0
        END
    ) AS desktop,
    SUM(
        CASE
            WHEN device = 'Mobile' THEN total
            ELSE 0
        END
    ) AS mobile
FROM funnel_table
WHERE device IN ('Desktop', 'Mobile') -- Ignore 'Overall' in this comparison
GROUP BY step
ORDER BY CASE
        step
        WHEN 'home' THEN 1
        WHEN 'search' THEN 2
        WHEN 'payment' THEN 3
        WHEN 'confirmation' THEN 4
    END