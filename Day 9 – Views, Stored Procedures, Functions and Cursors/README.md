# Set 1 – Retail Order Fulfilment

# Overview
This assignment demonstrates how to centralize retail order-fulfilment business rules using SQL Server database objects and a MongoDB view.
The fulfilment team needs consistent logic for order visibility, order placement, stock validation, order totals, delayed-order follow-up, and status reporting.

# Technology
- Microsoft SQL Server (T-SQL)
- MongoDB (JavaScript shell / mongosh)

# Files
Day 9 Set 1.sql file- contains all SQL Server tasks for that set:
- Views
- Stored procedures
- Functions
- Cursor-based processing
- Set-based alternative

Day 9 Set 1.js file - contains the MongoDB view creation.

## Conclusion

This project demonstrates how SQL Server and MongoDB can be used to manage retail order fulfilment efficiently. Views provide controlled access to order and stock information, while stored procedures ensure reliable order placement through stock validation and transaction management. Functions simplify order-total calculations and customer order retrieval. Cursor-based and set-based approaches are used to process pending orders and create follow-up records. A MongoDB view provides order-status count information.

Overall, this project highlights the importance of database-level business rules, data consistency, transaction handling, and efficient data processing in a retail order fulfilment system.

# Set 2 – Insurance Premium Processing
# Overview
This assignment demonstrates how to implement policy-renewal rules in SQL Server and create a MongoDB view for unresolved customer complaints.

The insurer needs to identify policies approaching renewal, validate renewals, calculate premiums consistently, audit changes, and update lapsed policies.

# Technology
- Microsoft SQL Server (T-SQL)
- MongoDB (JavaScript shell / mongosh)

# Files
Day 9 Set 2.sql file- contains all SQL Server tasks for this set.
Day 9 Set 2.js file - contains the MongoDB view creation.

## Conclusion

This project demonstrates how SQL Server and MongoDB can support insurance premium processing and policy renewal operations. Views help identify policies due for renewal while protecting sensitive information. Stored procedures validate renewal conditions, recalculate premiums, and maintain audit records within transactions. Functions provide reusable premium calculations and renewal quotes. Cursor-based and set-based approaches are implemented to manage lapsed policies, while a MongoDB view helps identify unresolved customer complaints.

Overall, this project emphasizes consistent premium calculation, secure data access, transaction reliability, auditability, and efficient policy management.

# Set 3 – Telecom Low-Balance Follow-up

# Overview
This assignment manages prepaid subscriber recharges and low-balance notifications using SQL Server, with a MongoDB view for unread notification counts.

The telecom operator needs to maintain subscriber balances, validate recharges, track recharge history, calculate validity, and notify subscribers whose balance is below 50 currency units.

# Technology
- Microsoft SQL Server (T-SQL)
- MongoDB (mongosh)

# Files
- Day 9 Set 3.sql – contains all SQL Server tasks for this set.
- Day 9 Set 3.js – contains the MongoDB view creation.

## Conclusion

This project demonstrates how SQL Server and MongoDB can be used to manage prepaid subscriber recharges and low-balance notifications. Views provide relevant subscriber and recharge information while restricting postpaid records. The recharge stored procedure validates inputs and updates subscriber balances and recharge history within a transaction. Functions calculate remaining validity and retrieve recent recharge details. Cursor-based and set-based methods are used to generate low-balance notifications and compare their execution performance. A MongoDB view provides unread notification counts for each subscriber.

Overall, this project highlights the importance of data validation, transaction management, accurate balance tracking, automated notifications, and performance optimization in a telecom billing system.
