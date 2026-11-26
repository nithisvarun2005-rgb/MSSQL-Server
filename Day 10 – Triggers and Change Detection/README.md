# Set 1 – Retail Price Audit

# Overview
This assignment demonstrates how SQL Server triggers and MongoDB change streams can help maintain a tamper-evident history of product price changes and prevent prices from being set below cost.

The retailer needs to audit price updates, reject invalid price changes, test multi-row operations, and monitor product price changes in MongoDB.

# Technology
- Microsoft SQL Server (T-SQL)
- MongoDB (mongosh)

# Files
- Day 10 Set 1.sql – contains the SQL Server trigger definitions and test queries.
- Day 10 Set 2.js – watches the MongoDB products collection for price changes.

## Conclusion

This project demonstrates how SQL Server triggers and MongoDB change streams can be used to maintain product price integrity and auditing. The AFTER UPDATE trigger records old and new prices along with user and timestamp details, while the INSTEAD OF trigger prevents prices from being set below cost. Single-row and multi-row updates help verify the reliability of trigger execution. MongoDB change streams provide real-time monitoring of product price changes.

Overall, this project highlights the importance of data integrity, automated auditing, business rule enforcement, and real-time change monitoring in retail management systems.

# Set 2 – Bank Account Balance Guard

# Overview
This assignment demonstrates how SQL Server triggers and MongoDB change streams can be used to audit bank account transaction changes and prevent savings account balances from becoming negative.

The bank needs to maintain an audit trail for transaction changes, enforce balance rules, test batch updates, and monitor fraud alerts.

# Technology
- Microsoft SQL Server (T-SQL)
- MongoDB (mongosh)

# Files
- Day 10 Set 2.sql – contains the SQL Server trigger definitions and test queries.
- Day 10 Set 2.js – watches the MongoDB fraud_alerts collection for new alerts.

## Conclusion

This project demonstrates how SQL Server triggers and MongoDB change streams can be used to maintain reliable banking transaction records and prevent invalid account balances. The AFTER trigger maintains an audit history of insert, update, and delete operations, while the INSTEAD OF trigger prevents savings account balances from becoming negative. Batch updates and nested or recursive trigger scenarios help understand trigger behavior and limitations. MongoDB change streams enable real-time monitoring of newly inserted fraud alerts.

Overall, this project emphasizes transaction auditing, financial data integrity, error handling, and secure balance management in banking systems.

# Set 3 – Hospital Bed Capacity Control

# Overview
This assignment demonstrates how SQL Server triggers and MongoDB change streams can help control hospital ward capacity and maintain an audit history of admission changes.

The hospital needs to prevent admissions when a ward is full, record admission inserts/updates/deletions, test multi-row behavior, and respond to critical ward alerts.

# Technology
- Microsoft SQL Server (T-SQL)
- MongoDB (mongosh)

# Files
- Day 10 Set 3.sql – contains the SQL Server trigger definitions and test queries.
- Day 10 Set 3.js – watches the MongoDB ward_alerts collection for critical alerts.

## Conclusion

This project demonstrates how SQL Server triggers and MongoDB change streams can help manage hospital bed capacity and maintain admission records. The capacity validation trigger prevents admissions beyond the available ward capacity, while the AFTER trigger records admission insert, update, and delete operations in an audit table. Multi-row testing helps verify capacity enforcement, and the comparison of triggers, constraints, and stored procedures provides an understanding of different approaches to business rule implementation. MongoDB change streams support real-time monitoring of critical ward alerts.

Overall, this project highlights the importance of admission validation, audit tracking, data consistency, and real-time alert monitoring in hospital management systems.
