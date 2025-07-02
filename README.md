## 🎯 Objective / Problem Statement

To assess employee productivity using daily work logs and employee metadata, identify underperformers, top contributors, analyze workload trends, and recommend actions for optimized workforce performance.

---

## 📊 Dataset Description

- **Employee Table**: Contains 50+ employee records with details like ID, Name, Department, Role, Join Date, and Location.
- **DailyLogs Table**: Captures daily working hours, task counts, and summaries for each employee over a time period.
- Dataset imported using SQL import wizard and structured into normalized tables.

---

## 🛠️ Tools & Technologies Used

- **SQL (MySQL)**
- **SQL Joins, Window Functions, Aggregations**
- **Subqueries, CTEs, Date Functions**
- **GitHub (Project Hosting)**

---

## 🔍 Key Tasks Performed

- Database schema creation and data import
- KPI calculations (tasks/hour, hours/day, productivity score)
- Productivity segmentation (quartiles, percent ranks)
- Role/Department-level comparisons
- Trend analysis (daily, weekly)
- Outlier & performance drop identification
- Employee categorization (top performers, underperformers)

---

## 📈 Key Insights / Findings

- 📌 **Top Performers** identified using 90th percentile in tasks/hour.
- 💤 **Underperformers** showed <7 hrs/day and <1 task/hour.
- 🚀 **Interns were more productive** than Leads in task/hour ratio.
- 🗓️ **Weekdays like Wednesday** showed peak productivity.
- 🛠️ **Departments with low output** flagged for managerial review.
- 🧠 **Productivity drop** detection across days for individuals.
- 🆕 **Ramp-up time** calculated from joining to first activity.

## 👨‍💻 My Role / Contribution

- End-to-end design and execution of this SQL project
- Crafted 50+ queries covering metrics, insights, and business logic
- Implemented advanced window functions (RANK, NTILE, CUME_DIST)
- Wrote and optimized productivity analysis using joins and aggregations

---

## 💡 Business Recommendations

- Encourage knowledge sharing from top performers to peers
- Address underperformance with support or reskilling
- Rebalance workloads in overworked departments
- Monitor interns for future leadership potential
- Automate regular productivity trend reporting for managers


> 📬 Feel free to reach out or check my GitHub for more data and SQL-based projects.
