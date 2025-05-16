WITH date_range AS (
    SELECT 
        MIN(date) AS min_date,
        MAX(date) AS max_date
    FROM user_table
),

funnel_base AS (
    SELECT 
        u.date,
        u.device,
        u.sex,
        COUNT(DISTINCT h.user_id) AS home_visits,
        COUNT(DISTINCT s.user_id) AS searches,
        COUNT(DISTINCT p.user_id) AS payments,
        COUNT(DISTINCT pc.user_id) AS confirmations
    FROM user_table u
    LEFT JOIN home_page_table h ON u.user_id = h.user_id
    LEFT JOIN search_page_table s ON u.user_id = s.user_id AND s.page = 'search_page'
    LEFT JOIN payment_page_table p ON u.user_id = p.user_id AND p.page = 'payment_page'
    LEFT JOIN payment_confirmation_table pc ON u.user_id = pc.user_id AND pc.page = 'payment_confirmation_page'
    GROUP BY 1, 2, 3
),

funnel_metrics AS (
    SELECT
        date,
        device,
        sex,
        home_visits,
        searches,
        payments,
        confirmations,
        -- Conversion rates
        ROUND(searches / NULLIF(home_visits, 0) * 100, 2) AS search_conversion_rate,
        ROUND(payments / NULLIF(searches, 0) * 100, 2) AS payment_conversion_rate,
        ROUND(confirmations / NULLIF(payments, 0) * 100, 2) AS confirmation_conversion_rate,
        ROUND(confirmations / NULLIF(home_visits, 0) * 100, 2) AS overall_conversion_rate,
        -- Drop-off counts
        home_visits - searches AS home_to_search_dropoff,
        searches - payments AS search_to_payment_dropoff,
        payments - confirmations AS payment_to_confirmation_dropoff
    FROM funnel_base
)

SELECT 
    f.*,
    d.min_date,
    d.max_date
FROM funnel_metrics f
CROSS JOIN date_range d
ORDER BY date, device;