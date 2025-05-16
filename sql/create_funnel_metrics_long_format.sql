-- This script creates the 'funnel_metrics_long_format' table and populates it with funnel step metrics in a long format.
-- Each row represents a step in the funnel (Home, Search, Payment, Confirmation) for a given date and device.
-- The script calculates the number of users at each step and the conversion rate from the previous step.
-- It also includes the minimum and maximum dates found in the user data for reference.
CREATE TABLE funnel_metrics_long_format (
    date DATE,
    device VARCHAR(7),
    funnel_step VARCHAR(12),
    -- Name of the funnel step (Home, Search, Payment, Confirmation)
    step_order TINYINT,
    -- Order of the step in the funnel
    user_count SMALLINT,
    -- Number of users at this step
    conversion_rate_from_previous DECIMAL(5, 2),
    -- Conversion rate from the previous step (%)
    min_date DATE,
    -- Earliest date in user_table
    max_date DATE -- Latest date in user_table
);

-- Insert funnel step metrics into the funnel_metrics_long_format table.
INSERT INTO funnel_metrics_long_format

-- 1. date_range: finds the min and max dates in user_table.
WITH date_range AS (
        SELECT MIN(date) AS min_date,
            MAX(date) AS max_date
        FROM user_table
    ),

-- 2. funnel_base: aggregates user counts at each funnel stage by date and device.
    funnel_base AS (
        SELECT u.date,
            u.device,
            COUNT(DISTINCT h.user_id) AS home_visits,
            COUNT(DISTINCT s.user_id) AS searches,
            COUNT(DISTINCT p.user_id) AS payments,
            COUNT(DISTINCT pc.user_id) AS confirmations
        FROM user_table u
            LEFT JOIN home_page_table h ON u.user_id = h.user_id
            LEFT JOIN search_page_table s ON u.user_id = s.user_id
            AND s.page = 'search_page'
            LEFT JOIN payment_page_table p ON u.user_id = p.user_id
            AND p.page = 'payment_page'
            LEFT JOIN payment_confirmation_table pc ON u.user_id = pc.user_id
            AND pc.page = 'payment_confirmation_page'
        GROUP BY 1,
            2
    ),

-- 3. funnel_long_format: transforms the data into long format, one row per funnel step.
    funnel_long_format AS (
        SELECT date,
            device,
            'Home' AS funnel_step,
            1 AS step_order,
            home_visits AS user_count,
            100.0 AS conversion_rate_from_previous
        FROM funnel_base
        UNION ALL
        SELECT date,
            device,
            'Search' AS funnel_step,
            2 AS step_order,
            searches AS user_count,
            ROUND(searches / NULLIF(home_visits, 0) * 100, 2) AS conversion_rate_from_previous
        FROM funnel_base
        UNION ALL
        SELECT date,
            device,
            'Payment' AS funnel_step,
            3 AS step_order,
            payments AS user_count,
            ROUND(payments / NULLIF(searches, 0) * 100, 2) AS conversion_rate_from_previous
        FROM funnel_base
        UNION ALL
        SELECT date,
            device,
            'Confirmation' AS funnel_step,
            4 AS step_order,
            confirmations AS user_count,
            ROUND(confirmations / NULLIF(payments, 0) * 100, 2) AS conversion_rate_from_previous
        FROM funnel_base
    )
SELECT f.*,
    d.min_date,
    d.max_date
FROM funnel_long_format f
    CROSS JOIN date_range d
ORDER BY date,
    device,
    step_order;