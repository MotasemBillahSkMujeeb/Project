SELECT 
	cohort_year,
	COUNT(DISTINCT customerkey) AS num_cus,
	SUM(total_net_revenue) AS tot_revenue,
	SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue
FROM cohort_analysis 
WHERE orderdate = first_puchase_date
GROUP BY 
	cohort_year
;