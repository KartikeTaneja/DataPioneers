# DataPioneers Inventory Management System

This project demonstrates a normalized SQL-based inventory system with support for order placement, stock tracking, and automatic fulfillment of backorders. It is implemented using Oracle SQL and follows best practices in schema design, constraints, business rules, and modular script execution.

## Execution Flow

All SQL scripts are stored in the Automation_Scripts/ directory.


**Always connect and run scripts as data_pioneers_admin (admin)**

- **Step 1:Run User Setup**

        Run: DataPioneers_SetUp.sql

This script creates the two user `data_pioneers_admin` and `data_pioneers`:
- `data_pioneers_admin` is the admin user with full privileges.
- `data_pioneers` is the regular user with limited privileges(read-only access).



- **Step 2: Run Validated Schema Script Login as data_pioneers_admin**

        Run: DataPioneers_Validated_Schema.sql

This script creates all tables, constraints, foreign keys, and views as per the final ER diagram.


- **Step 3:Run Insert Sample Data Login as data_pioneers_admin**

       Run: DataPioneers_SampleData.sql

Populates all tables with realistic data and can be re-run multiple times (it clears old data first).

- **Step 4:Test as data_pioneers (read-only user):**
- After executing all scripts as admin, log in as:

            Username: data_pioneers
            Password: User@123456789


    Run this script: data_pioneers.sql

**Note:** Any INSERT, UPDATE, or DELETE will fail for this user due to read-only access.


## Features Demonstrated

- Fully normalized schema with ERD and relational mappings

- Business rule constraints:
  - Quantity > 0
  - Valid phone/email
  - Unique customer emails
  - Auto-fulfillment logic


- Views:
  - `Current_Inventory_Status`
  - `Product_Wise_Price_Changes`
  - `Total_Sales_By_Customer`
  - `Week_Wise_Sales`
- All scripts are re-runnable and have exception-safe logic


## Normalization Justification

- **1NF – First Normal Form**  
    - All attributes are atomic (no multi-valued or composite fields).  
    - Each table has a clear PK.  
    - Example: Products.Name and Category are simple and atomic.

- **2NF – Second Normal Form**  
    - No partial dependencies.  
    - Composite PKs (e.g., ProductWarehouse) are used correctly.  
    - Non-key attributes are fully dependent on entire PK.

- **3NF – Third Normal Form**  
    - No transitive dependencies.  
    - All non-key attributes depend only on the primary key.

- **All entities conform to 1NF, 2NF, and 3NF.**
