
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

## Project File
- `Day 5 Set 1.js` – MongoDB collection creation, validation, and CRUD operations.
  

## Expected Outcome
A normalized retail inventory database with appropriate constraints and a MongoDB collection for flexible product review data.
