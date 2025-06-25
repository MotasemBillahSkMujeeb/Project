
WITH customer_ltv AS (	
	SELECT 
		customerkey,
		cleaned_name,
		ROUND(SUM(total_net_revenue::INT)) AS total_ltv
	FROM cohort_analysis 
	GROUP BY 
		customerkey,
		cleaned_name
), customer_segment AS (
	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
	FROM customer_ltv 
), segment_value AS (
	SELECT
		cl.*,
		CASE
			WHEN cl.total_ltv < cs.ltv_25th_percentile THEN '1 - Low-Value'
			WHEN cl.total_ltv <= cs.ltv_75th_percentile THEN '2 - Mid-Value'
			ELSE '3 - High-Value'
		END AS customer_segment
	FROM customer_ltv cl,
		customer_segment cs
)
SELECT 
	customer_segment,
	SUM(total_ltv) AS total_ltv,
	AVG(total_ltv) AS avg_ltv,
	COUNT(customerkey) AS customer_count,
	SUM(total_ltv) / COUNT(customerkey) AS avg_ltv
FROM segment_value 
GROUP BY 	
	customer_segment 
ORDER BY 	
	customer_segment DESC
	
	