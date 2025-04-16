
# DataPioneers Inventory Management System

This project demonstrates a normalized SQL-based inventory system with support for order placement, stock tracking, and automatic fulfillment of backorders. It is implemented using Oracle SQL and follows best practices in schema design, constraints, business rules, performance indexing, and modular script execution.

## Execution Flow

All SQL scripts are stored in the `DataPioneers_Scripts/` directory.

**Always connect and run scripts as `data_pioneers_admin` (admin)**

### Step 1: Run User Setup
```sql
Run: DataPioneers_SetUp.sql
```
This script creates the two users:
- `data_pioneers_admin`: Admin user with full privileges.
- `data_pioneers`: Read-only user for safe querying.

---

### Step 2: Run Validated Schema Script (as `data_pioneers_admin`)
```sql
Run: DataPioneers_Validated_Schema.sql
```
Creates all tables, constraints, views, and **performance indexes**.

---

### Step 3: Insert Sample Data (as `data_pioneers_admin`)
```sql
Run: DataPioneers_SampleData.sql
```
Populates tables with customers, suppliers, products, orders (including backorders).  
This script is **re-runnable** and clears old data automatically.

---

### Step 4: Create Packages and Grant Execute
```sql
Run: inventory_function_and_package.sql
```
- Creates function `get_inventory_value(p_product_id)`
- Creates procedure `fulfill_backorders(p_product_id)`
- Bundles both into `inventory_pkg`
- Grants EXECUTE to read-only user

---

### Step 5: Test from Read-Only User
Login as:
```
Username: data_pioneers
Password: User@123456789
```

Run:
```sql
-- Function to get inventory value
SELECT data_pioneers_admin.inventory_pkg.get_inventory_value(1001) FROM dual;

-- Procedure to fulfill backorders
EXEC data_pioneers_admin.inventory_pkg.fulfill_backorders(1001);
```

---

### Step 6: Optional - Run Test Script to Simulate & Fulfill Backorders
```sql
Run: DataPioneers_Test_Backorder.sql
```
Simulates a backordered order and demonstrates automatic fulfillment after stock replenishment.

---

## Features Demonstrated

- Fully normalized schema (1NF, 2NF, 3NF)
- Secure user setup with limited access and privileges
- Auto-fulfillment logic using stored procedures
- Business rule constraints:
  - Quantity > 0
  - Price validations
  - Unique emails and phone number checks
- Views:
  - `Current_Inventory_Status`
  - `Product_Wise_Price_Changes`
  - `Total_Sales_By_Customer`
  - `Week_Wise_Sales`
- Performance optimization using indexes
- All scripts are re-runnable and exception-safe

---

## Performance Indexes (Phase 3)

The following indexes were added to optimize join and filter operations:
```sql
CREATE INDEX idx_orders_customerid ON Orders(CustomerID);
CREATE INDEX idx_orderdetails_orderid ON OrderDetails(OrderID);
CREATE INDEX idx_orderdetails_productid ON OrderDetails(ProductID);
CREATE INDEX idx_orders_status ON Orders(OrderStatus);
```

---

## Normalization Justification

- **1NF – First Normal Form**: Atomic fields and clear primary keys
- **2NF – Second Normal Form**: No partial dependencies
- **3NF – Third Normal Form**: No transitive dependencies

✅ All entities conform to 1NF, 2NF, and 3NF.



