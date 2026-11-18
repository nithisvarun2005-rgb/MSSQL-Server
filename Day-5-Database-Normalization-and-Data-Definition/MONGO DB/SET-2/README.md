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
- `Day 5 Set 2.js` – MongoDB capped collection and query operations.

## Expected Outcome
A normalized banking database with reliable account management and a MongoDB capped collection for customer activity tracking.
