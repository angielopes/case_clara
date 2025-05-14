-- CLIENT'S FUNNEL
WITH funnel_data AS (
    SELECT h.user_id AS home_visits,
        s.user_id AS searches,
        p.user_id AS payments,
        pc.user_id AS confirmations
    FROM home_page_table h
        LEFT JOIN search_page_table s ON h.user_id = s.user_id
        LEFT JOIN payment_page_table p ON h.user_id = p.user_id
        LEFT JOIN payment_confirmation_table pc ON h.user_id = pc.user_id
),

-- FUNNEL COUNTING AT EACH STAGE
conversions_counts AS (
    SELECT COUNT(DISTINCT home_visits) AS total_home,
        COUNT(DISTINCT searches) AS total_searches,
        COUNT(DISTINCT payments) AS total_payments,
        COUNT(DISTINCT confirmations) AS total_confirmations
    FROM funnel_data
),

-- FUNNEL RATING AT EACH STAGE
conversions_rates AS (
	SELECT
		100.00 AS home_rate,
		total_searches / NULLIF(total_home, 0) * 100 AS search_rate,
		total_payments / NULLIF(total_searches, 0) * 100 AS payments_rate,
		total_confirmations / NULLIF(total_payments, 0) * 100 AS confirmations_rate
	FROM
		conversions_counts
)

SELECT * FROM conversions_rates