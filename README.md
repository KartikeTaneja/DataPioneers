# DataPioneers Inventory Management System

This project demonstrates a normalized SQL-based inventory system with support for order placement, stock tracking, and automatic fulfillment of backorders. It is implemented using Oracle SQL and follows best practices in schema design, constraints, business rules, and modular script execution.

## Execution Flow

### **Run Initial Setup**

- 1. **Run Initial Setup**

        Run: DataPioneers_SetUp.sql

This script creates the user `data_pioneers`, grants all necessary permissions, and assigns unlimited quota.

- 2. **Run Validated Schema Script**

        Run: DataPioneers_Validated_Schema.sql

This script creates all tables, constraints, foreign keys, and views as per the final ER diagram.


- 3. **Insert Sample Data**

       Run: DataPioneers_SampleData.sql

Populates all tables with realistic data and can be re-run multiple times (it clears old data first).

- 4. **Backorder Logic + Test**

        Run: DataPioneers_Test_Backorder.sql

This script:
- Creates a stored procedure `fulfill_backorders`
- Simulates a backorder
- Updates stock
- Shows how the order gets fulfilled automatically

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
  - `Total_Sales_Region_Wise`
  - `Week_Wise_Sales`
- Auto-order logic via stored procedure when stock is replenished
- All scripts are re-runnable and have exception-safe logic
