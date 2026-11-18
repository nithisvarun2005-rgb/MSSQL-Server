# Set 1 – Retail Inventory and Product Reviews.
# Retail Inventory and Product Reviews

## Project Overview
This project focuses on designing a normalized retail inventory database using SQL Server and managing flexible customer review data using MongoDB.

The main objective is to eliminate data redundancy, maintain data integrity, and understand the differences between relational and NoSQL databases.

## Technologies Used
- Microsoft SQL Server 2025
- MongoDB 8.0
- MongoDB Compass
- SQL (T-SQL)
- MongoDB Query Language

## SQL Server Tasks

### 1. Database Normalisation
- Normalize the original inventory spreadsheet into Third Normal Form (3NF).
- Identify insertion, update, and deletion anomalies.
- Identify primary keys and foreign keys.
- Design an Entity Relationship (ER) diagram.

### 2. Database and Table Creation
- Create the database and required tables.
- Define PRIMARY KEY and FOREIGN KEY constraints.
- Apply UNIQUE, CHECK, and DEFAULT constraints.
- Configure appropriate referential actions.

### 3. Data Manipulation
- Insert at least 10 records per table.
- Demonstrate four deliberately failing INSERT operations:
  - Duplicate key.
  - Missing parent record.
  - Negative quantity.
  - NULL in a mandatory column.

### 4. UPDATE and DELETE
- Correct a supplier phone number using UPDATE.
- Remove discontinued SKUs using DELETE.
- Display records before and after modifications.

## MongoDB Tasks
- Identify suitable data for MongoDB, such as product reviews and search activity.
- Create a reviews collection with a `$jsonSchema` validator.
- Perform the following operations:
  - `insertMany()`
  - `find()`
  - `updateOne()`
  - `deleteOne()`

## Project Files
- `Day 5 Set 1.sql` – Database and table creation scripts.
- `Day 5 Set 1.js` – MongoDB collection creation, validation, and CRUD operations.

## Expected Outcome
A normalized retail inventory database with appropriate constraints and a MongoDB collection for flexible product review data.

# Set 2 – Bank Branch Accounts and Customer Activity
# Bank Branch Accounts and Customer Activity

## Project Overview
This project focuses on designing a normalized banking database using SQL Server and storing customer activity logs using MongoDB.

The objective is to maintain accurate account information, understand database operations, and explore the advantages of document-oriented storage for activity logs.

## Technologies Used
- Microsoft SQL Server 2025
- MongoDB 8.0
- MongoDB Compass
- SQL (T-SQL)
- MongoDB Query Language

## SQL Server Tasks

### 1. Database Normalisation
- Normalize the de-normalized banking spreadsheet into 3NF/BCNF.
- Identify candidate keys and composite keys.
- Identify primary and foreign keys.
- Design an Entity Relationship (ER) diagram.

### 2. Database and Table Creation
- Create database tables using IDENTITY columns.
- Apply CHECK constraints to ensure savings account balances are non-negative.
- Enforce UNIQUE constraints on account numbers.
- Configure suitable cascading rules and justify the choices.

### 3. DROP, TRUNCATE and DELETE
Demonstrate the differences between:
- `DROP`
- `TRUNCATE`
- `DELETE`

Record their effects on table structure, records, identity values, and transaction rollback.

### 4. Data Manipulation and Retrieval
- Insert sample records.
- Update and delete records.
- Retrieve accounts using:
  - `AND`
  - `OR`
  - `IN`
  - `BETWEEN`
- Find accounts opened in the last quarter with a balance above a specified threshold.

## MongoDB Tasks
- Store customer activity logs as documents.
- Create a capped collection.
- Insert 20 activity documents.
- Retrieve the last five login events for a particular customer.
- Understand why MongoDB is suitable for storing flexible activity logs.

## Project Files
- `Day 5 Set 2.sql` – Database and table creation scripts.
- `Day 5 Set 2.js` – MongoDB capped collection and query operations.


## Expected Outcome
A normalized banking database with reliable account management and a MongoDB capped collection for customer activity tracking.

# Set 3 – Hospital Patient Records and Clinical Notes

# Hospital Patient Records and Clinical Notes

## Project Overview
This project focuses on designing a normalized hospital database using SQL Server and storing flexible clinical notes using MongoDB.

The objective is to organize patient, doctor, department, visit, and billing information while maintaining data consistency and integrity.

## Technologies Used
- Microsoft SQL Server 2025
- MongoDB 8.0
- MongoDB Compass
- SQL (T-SQL)
- MongoDB Query Language

## SQL Server Tasks

### 1. Database Normalisation
- Normalize the original hospital records into Third Normal Form (3NF).
- Separate the data into the following tables:
  - Patient
  - Doctor
  - Department
  - Visit
  - Billing
- Explain the decomposition process.
- Identify primary and foreign keys.
- Design an Entity Relationship (ER) diagram.

### 2. Database and Table Creation
- Create the database and required tables.
- Add constraints for valid visit dates.
- Ensure bill amounts are non-negative.
- Set the default visit status to `'Open'`.

### 3. ALTER TABLE Operations
Demonstrate the following operations:
- Add an `insurance_id` column using ALTER TABLE.
- Rename a table.
- Drop an existing constraint.
- Document the effect of each operation.

### 4. Data Manipulation and Retrieval
- Insert sample records.
- Update existing records.
- Delete records using WHERE conditions.
- Retrieve patients visited in a particular month.
- Retrieve doctors belonging to a specific department.
- Use WHERE and LIKE conditions.

## MongoDB Tasks
- Model clinical notes as flexible documents.
- Create a collection with schema validation.
- Insert documents with two different structures.
- Retrieve clinical notes based on diagnosis.
- Understand how MongoDB supports variable document structures.

## Project Files
- `schema.sql` – Database and table creation scripts.
- `seed_data.sql` – Sample data insertion and SQL operations.
- `collections.js` – MongoDB collection creation, validation, insertion, and retrieval.
- `ER_Diagram.png` – Entity Relationship diagram.
- `assumptions.md` – Three assumptions made during database design.

## Expected Outcome
A normalized hospital database that maintains structured patient and billing information, along with a flexible MongoDB collection for clinical notes.
