-- Define pricing and conversion constants
DECLARE USD_PER_GIB_STORAGE NUMERIC DEFAULT 0.020;
DECLARE USD_PER_TIB_QUERY NUMERIC DEFAULT 6.25;
DECLARE NZD_PER_USD_RATE NUMERIC DEFAULT 1.64;

-- This CTE calculates the total data processed for each month
WITH MonthlyQueryUsage AS (
  SELECT
    FORMAT_DATE('%Y-%m', creation_time) AS month,
    SUM(total_bytes_billed) / POWER(1024, 4) AS total_tb_processed
  FROM
    `your-project-id.region-us-central1.INFORMATION_SCHEMA.JOBS`
  GROUP BY
    month
),
-- This CTE gets your current storage size
CurrentStorage AS (
  SELECT
    SUM(total_logical_bytes) / POWER(1024, 3) AS total_logical_gib
  FROM
    `your-project-id.region-us-central1.INFORMATION_SCHEMA.TABLE_STORAGE`
  WHERE
    -- Replace with your dataset name
    table_schema = "your_dataset_name"
),
-- This CTE calculates the estimated cost for each individual month
MonthlyCosts AS (
  SELECT
    usage.month,
    ROUND(
      (
        -- Storage cost (first 10 GiB/month are free)
        (GREATEST(0, storage.total_logical_gib - 10)) * USD_PER_GIB_STORAGE +
        -- Query cost (first 1 TiB/month is free)
        (GREATEST(0, usage.total_tb_processed - 1.0)) * USD_PER_TIB_QUERY
      ) * NZD_PER_USD_RATE,
    2) AS estimated_cost_nzd
  FROM
    MonthlyQueryUsage AS usage,
    CurrentStorage AS storage
)
-- Final SELECT to display all monthly rows AND the new total row
SELECT month, estimated_cost_nzd
FROM (
  -- The first part of the UNION gets the individual monthly costs
  SELECT month, estimated_cost_nzd, 1 AS sort_order FROM MonthlyCosts
  UNION ALL
  -- The second part of the UNION calculates the final SUM
  SELECT 'Total' AS month, SUM(estimated_cost_nzd), 2 AS sort_order FROM MonthlyCosts
)
-- Order by the new sort column to ensure 'Total' is always last
ORDER BY
  sort_order,
  month;
