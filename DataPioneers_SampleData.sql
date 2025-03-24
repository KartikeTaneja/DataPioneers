
-- Clear existing data to make the script re-runnable
DELETE FROM OrderDetails;
DELETE FROM Orders;
DELETE FROM ProductWarehouse;
DELETE FROM Products;
DELETE FROM Warehouse;
DELETE FROM Suppliers;
DELETE FROM Customers;

-- Insert Sample Customers
INSERT INTO Customers VALUES (1, 'Shushruth', 'Konapur', 'shushruth.konapur@example.com', '1234500001', CURRENT_TIMESTAMP);
INSERT INTO Customers VALUES (2, 'Mayank', 'Agarwal', 'mayank.agarwal@example.com', '1234500002', CURRENT_TIMESTAMP);
INSERT INTO Customers VALUES (3, 'Sachin', 'Tendulkar', 'sachin.tendulkar@example.com', '1234500003', CURRENT_TIMESTAMP);
INSERT INTO Customers VALUES (4, 'Sharan', 'Parilk', 'sharan.parilk@example.com', '1234500004', CURRENT_TIMESTAMP);
INSERT INTO Customers VALUES (5, 'Shubham', 'Patel', 'shubham.patel@example.com', '1234500005', CURRENT_TIMESTAMP);
INSERT INTO Customers VALUES (6, 'Agrima', 'Jain', 'agrima.jain@example.com', '1234500006', CURRENT_TIMESTAMP);
INSERT INTO Customers VALUES (7, 'Sohan', 'Shinde', 'sohan.shinde@example.com', '1234500007', CURRENT_TIMESTAMP);
INSERT INTO Customers VALUES (8, 'Anand', 'Pandey', 'anand.pandey@example.com', '1234500008', CURRENT_TIMESTAMP);
INSERT INTO Customers VALUES (9, 'Amruta', 'Naik', 'amruta.naik@example.com', '1234500009', CURRENT_TIMESTAMP);
INSERT INTO Customers VALUES (10, 'Kartik', 'Taneja', 'kartik.taneja@example.com', '1234500010', CURRENT_TIMESTAMP);

-- Insert Suppliers
INSERT INTO Suppliers VALUES (101, 'Fresh Farms', 'David Jones', '1122334455');
INSERT INTO Suppliers VALUES (102, 'Tech Goods Inc.', 'Sarah Wilson', '5566778899');
INSERT INTO Suppliers VALUES (103, 'Organic Roots', 'Priya Mehra', '1231231234');
INSERT INTO Suppliers VALUES (104, 'Daily Essentials Ltd.', 'Ravi Khanna', '2342342345');
INSERT INTO Suppliers VALUES (105, 'City Grocers', 'Neha Sharma', '3453453456');
INSERT INTO Suppliers VALUES (106, 'ElectroMart', 'Amit Trivedi', '4564564567');
INSERT INTO Suppliers VALUES (107, 'Nature Harvest', 'Deepika Rane', '5675675678');

-- Insert Products
INSERT INTO Products VALUES (1001, 'Milk', 'Perishable', 2.99, 50, 101, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Products VALUES (1002, 'Laptop', 'Electronics', 999.99, 20, 102, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Products VALUES (1003, 'Bread', 'Perishable', 1.99, 100, 103, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Products VALUES (1004, 'Smartphone', 'Electronics', 699.99, 30, 106, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Products VALUES (1005, 'Rice', 'Grocery', 15.00, 80, 104, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Products VALUES (1006, 'Washing Machine', 'Appliances', 449.50, 10, 107, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert Orders
INSERT INTO Orders VALUES (201, 3, CURRENT_TIMESTAMP, 5.98, 'Fulfilled');
INSERT INTO Orders VALUES (202, 5, CURRENT_TIMESTAMP, 999.99, 'Fulfilled');
INSERT INTO Orders VALUES (203, 6, CURRENT_TIMESTAMP, 31.98, 'Fulfilled');
INSERT INTO Orders VALUES (204, 8, CURRENT_TIMESTAMP, 1349.49, 'Fulfilled');

-- Insert OrderDetails
INSERT INTO OrderDetails VALUES (301, 201, 1001, 2, 5.98);
INSERT INTO OrderDetails VALUES (302, 202, 1002, 1, 999.99);
INSERT INTO OrderDetails VALUES (303, 203, 1003, 2, 3.98);
INSERT INTO OrderDetails VALUES (304, 203, 1005, 1, 15.00);
INSERT INTO OrderDetails VALUES (305, 204, 1004, 1, 699.99);
INSERT INTO OrderDetails VALUES (306, 204, 1006, 1, 449.50);

-- Insert Warehouses
INSERT INTO Warehouse VALUES (401, 'New York Central');
INSERT INTO Warehouse VALUES (402, 'San Francisco Bay');
INSERT INTO Warehouse VALUES (403, 'Chicago South');

-- Insert ProductWarehouse mappings
INSERT INTO ProductWarehouse VALUES (1001, 401, 25, CURRENT_TIMESTAMP, 101);
INSERT INTO ProductWarehouse VALUES (1002, 402, 15, CURRENT_TIMESTAMP, 102);
INSERT INTO ProductWarehouse VALUES (1003, 401, 60, CURRENT_TIMESTAMP, 103);
INSERT INTO ProductWarehouse VALUES (1004, 403, 20, CURRENT_TIMESTAMP, 106);
INSERT INTO ProductWarehouse VALUES (1005, 402, 40, CURRENT_TIMESTAMP, 104);
INSERT INTO ProductWarehouse VALUES (1006, 403, 10, CURRENT_TIMESTAMP, 107);



-- Verify

SELECT * FROM Customers;
SELECT * FROM Suppliers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT * FROM Warehouse;
SELECT * FROM ProductWarehouse;

SELECT * FROM Current_Inventory_Status;
SELECT * FROM Product_Wise_Price_Changes;
SELECT * FROM Total_Sales_By_Customer;
SELECT * FROM Week_Wise_Sales;


-- It grants SELECT on all schema objects to data_pioneers

BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || t.table_name || ' TO data_pioneers';
  END LOOP;

  FOR v IN (SELECT view_name FROM user_views) LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v.view_name || ' TO data_pioneers';
  END LOOP;
END;
/
