-- Define the price per TiB in USD
DECLARE USD_PER_TIB_QUERY NUMERIC DEFAULT 6.25;

-- Select and calculate costs for each unique query
SELECT
  query,
  -- Calculate the cost based on total bytes billed for this query
  ROUND((SUM(total_bytes_billed) / POWER(1024, 4)) * USD_PER_TIB_QUERY, 2) AS total_cost_in_dollar,
  -- Aggregate metadata for all runs of this query
  MIN(start_time) AS first_run_time,
  MAX(start_time) AS last_run_time,
  STRING_AGG(DISTINCT user_email, ', ') AS executed_by_users,
  STRING_AGG(DISTINCT ref_tables.table_id, ', ') AS referenced_tables
FROM
  `your-project-id.region-us-central1.INFORMATION_SCHEMA.JOBS`,
  -- Unnest the referenced_tables array to access table names
  UNNEST(referenced_tables) AS ref_tables
WHERE
  -- Filter for the last 180 days and only for query jobs that billed data
  creation_time BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 180 DAY) AND CURRENT_TIMESTAMP()
  AND job_type = 'QUERY'
  AND total_bytes_billed > 0
GROUP BY
  query
ORDER BY
  total_cost_in_dollar DESC;
