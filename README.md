# Calculating-Each-Query-Job-Storage-Cost-in-BigQuery
BigQuery Cost Monitoring Scripts

# 📉 BigQuery Cost Monitoring Scripts

A collection of **SQL scripts** to help you **monitor and manage BigQuery costs** directly in the BigQuery SQL Editor. These scripts use `INFORMATION_SCHEMA` views to provide insights into **query processing** and **storage usage**.

---

## ✨ Features

- **📊 Monthly Cost Summary**  
  Overview of your **monthly query and storage costs**, with optional **currency conversion**.

- **🎯 Individual Query Analysis**  
  Identify the most expensive queries by **user**, **timestamp**, and **referenced tables**.

- **⚙️ Easy Configuration**  
  All scripts include **declared variables** at the top for pricing, currency, and project setup.

- **🧰 No External Tools Required**  
  Everything runs directly inside the **BigQuery SQL Editor**.

---

## ✅ Prerequisites

Before using these scripts, ensure the following:

- A **Google Cloud project** with the **BigQuery API enabled**
- Permissions to access `INFORMATION_SCHEMA` views (e.g., `roles/bigquery.user`)

---

## 📁 Scripts Included

### 1. [**Monthly Cost Summary**](https://github.com/AGhayeAli/Calculating-Each-Query-Job-Storage-Cost-in-BigQuery/blob/main/monthly_cost_summary.sql)

**Purpose:**  
Estimate **monthly query and storage costs** over the past 180 days.

#### How to Use:

1. Open the script using the link above or copy it into the BigQuery SQL Editor.
2. Modify these variables at the top of the script:
   - `USD_PER_GIB_STORAGE` – default: `0.020`
   - `USD_PER_TIB_QUERY` – default: `6.25`
   - `NZD_PER_USD_RATE` – your local conversion rate (e.g., `1.64`)
3. Replace placeholders:
   - `your-project-id`
   - `region-us-central1`
   - `your_dataset_name`
4. Run the query to view monthly breakdown + total row.

---

### 2. [**Individual Query Cost**](https://github.com/AGhayeAli/Calculating-Each-Query-Job-Storage-Cost-in-BigQuery/blob/main/individual_query_cost.sql)

**Purpose:**  
Analyze **each unique query** over the past 180 days — includes total cost, users, run times, and referenced tables.

#### How to Use:

1. Open the script using the link above or copy it into the BigQuery SQL Editor.
2. Edit the following variable:
   - `USD_PER_TIB_QUERY` – default: `6.25`
3. Replace placeholders:
   - `your-project-id`
   - `region-us-central1`
4. Run the query to get a sorted list of the most expensive queries.

