SELECT 
  u.date,
  COUNT(DISTINCT h.user_id) AS home_visits,
  COUNT(DISTINCT s.user_id) AS searches,
  COUNT(DISTINCT p.user_id) AS payments,
  COUNT(DISTINCT pc.user_id) AS confirmations
FROM user_table u
LEFT JOIN home_page_table h ON u.user_id = h.user_id
LEFT JOIN search_page_table s ON u.user_id = s.user_id
LEFT JOIN payment_page_table p ON u.user_id = p.user_id
LEFT JOIN payment_confirmation_table pc ON u.user_id = pc.user_id
GROUP BY u.date
ORDER BY u.date;