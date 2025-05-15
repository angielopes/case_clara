-- Aggregate counts and conversion rates for overall and by device

WITH funnel_data AS (
    SELECT
        u.date,
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

-- Calculate counts grouped by device
conversions_counts_by_device AS (
    SELECT
        device,
        COUNT(home_visits) AS total_home,
        COUNT(searches) AS total_searches,
        COUNT(payments) AS total_payments,
        COUNT(confirmations) AS total_confirmations
    FROM funnel_data
    GROUP BY device
),

-- Calculate overall counts (all devices combined)
conversions_counts_overall AS (
    SELECT
        'Overall' AS device,
        COUNT(home_visits) AS total_home,
        COUNT(searches) AS total_searches,
        COUNT(payments) AS total_payments,
        COUNT(confirmations) AS total_confirmations
    FROM funnel_data
),

-- Combine overall and device-level counts
all_counts AS (
    SELECT * FROM conversions_counts_overall
    UNION ALL
    SELECT * FROM conversions_counts_by_device
),

-- Calculate conversion rates based on counts
all_rates AS (
    SELECT
        device,
        total_home,
        total_searches,
        total_payments,
        total_confirmations,
        100.0 AS home_rate,
        total_searches / NULLIF(total_home, 0) * 100 AS search_rate,
        total_payments / NULLIF(total_searches, 0) * 100 AS payments_rate,
        total_confirmations / NULLIF(total_payments, 0) * 100 AS confirmations_rate
    FROM all_counts
)

SELECT * FROM all_rates
ORDER BY
    CASE WHEN device = 'Overall' THEN 0 ELSE 1 END,
    device;
