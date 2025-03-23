-- Drop tables if they exist
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE OrderDetails CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Orders CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Products CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Customers CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Suppliers CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Warehouse CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ProductWarehouse CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- Drop views if they exist
BEGIN 
    EXECUTE IMMEDIATE 'DROP VIEW Current_Inventory_Status'; 
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END;
/

BEGIN 
    EXECUTE IMMEDIATE 'DROP VIEW Product_Wise_Price_Changes'; 
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END;
/

BEGIN 
    EXECUTE IMMEDIATE 'DROP VIEW Total_Sales_Region_Wise'; 
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END;
/

BEGIN 
    EXECUTE IMMEDIATE 'DROP VIEW Week_Wise_Sales'; 
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END;
/


-- Create Tables
CREATE TABLE Customers (
    Customers_ID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(100) NOT NULL,
    LastName VARCHAR2(100) NOT NULL,
    Email VARCHAR2(255) NOT NULL,
    Phone VARCHAR2(20),
    CreatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Suppliers (
    SupplierID NUMBER PRIMARY KEY,
    CompanyName VARCHAR2(255) NOT NULL,
    ContactPerson VARCHAR2(200),
    Phone VARCHAR2(20)
);

CREATE TABLE Products (
    ProductID NUMBER PRIMARY KEY,
    Name VARCHAR2(255) NOT NULL,
    Category VARCHAR2(200),
    Price NUMBER(10,2) NOT NULL CHECK (Price > 0),
    StockQuantity NUMBER NOT NULL CHECK (StockQuantity >= 0),
    SupplierID NUMBER,
    CreatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP WITH LOCAL TIME ZONE,
    CONSTRAINT Products_Suppliers_FK FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Orders (
    OrderID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount NUMBER(10,2) NOT NULL,
    CONSTRAINT Orders_Customers_FK FOREIGN KEY (CustomerID) REFERENCES Customers(Customers_ID)
);

CREATE TABLE OrderDetails (
    OrderDetailID NUMBER PRIMARY KEY,
    OrderID NUMBER,
    ProductID NUMBER,
    Quantity NUMBER NOT NULL CHECK (Quantity > 0),
    SubTotal NUMBER(10,2) NOT NULL,
    CONSTRAINT OrderDetails_Orders_FK FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT OrderDetails_Products_FK FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Warehouse (
    WarehouseID NUMBER PRIMARY KEY,
    Location VARCHAR2(255) NOT NULL
);

CREATE TABLE ProductWarehouse (
    ProductID NUMBER,
    WarehouseID NUMBER,
    StockLevel NUMBER NOT NULL CHECK (StockLevel >= 0),
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SupplierID NUMBER,
    PRIMARY KEY (ProductID, WarehouseID),
    CONSTRAINT ProductWarehouse_Product_FK FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT ProductWarehouse_Warehouse_FK FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    CONSTRAINT ProductWarehouse_Suppliers_FK FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Insert Sample Data

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


INSERT INTO Suppliers VALUES (101, 'Fresh Farms', 'David Jones', '1122334455');
INSERT INTO Suppliers VALUES (102, 'Tech Goods Inc.', 'Sarah Wilson', '5566778899');
INSERT INTO Suppliers VALUES (103, 'Organic Roots', 'Priya Mehra', '1231231234');
INSERT INTO Suppliers VALUES (104, 'Daily Essentials Ltd.', 'Ravi Khanna', '2342342345');
INSERT INTO Suppliers VALUES (105, 'City Grocers', 'Neha Sharma', '3453453456');
INSERT INTO Suppliers VALUES (106, 'ElectroMart', 'Amit Trivedi', '4564564567');
INSERT INTO Suppliers VALUES (107, 'Nature Harvest', 'Deepika Rane', '5675675678');


INSERT INTO Products VALUES (1001, 'Milk', 'Perishable', 2.99, 50, 101, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Products VALUES (1002, 'Laptop', 'Electronics', 999.99, 20, 102, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Products VALUES (1003, 'Bread', 'Perishable', 1.99, 100, 103, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Products VALUES (1004, 'Smartphone', 'Electronics', 699.99, 30, 106, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Products VALUES (1005, 'Rice', 'Grocery', 15.00, 80, 104, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Products VALUES (1006, 'Washing Machine', 'Appliances', 449.50, 10, 107, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO Orders VALUES (201, 3, CURRENT_TIMESTAMP, 5.98);
INSERT INTO Orders VALUES (202, 5, CURRENT_TIMESTAMP, 999.99);
INSERT INTO Orders VALUES (203, 6, CURRENT_TIMESTAMP, 31.98);
INSERT INTO Orders VALUES (204, 8, CURRENT_TIMESTAMP, 1349.49);


INSERT INTO OrderDetails VALUES (301, 201, 1001, 2, 5.98);
INSERT INTO OrderDetails VALUES (302, 202, 1002, 1, 999.99);
INSERT INTO OrderDetails VALUES (303, 203, 1003, 2, 3.98);
INSERT INTO OrderDetails VALUES (304, 203, 1005, 1, 15.00);
INSERT INTO OrderDetails VALUES (305, 204, 1004, 1, 699.99);
INSERT INTO OrderDetails VALUES (306, 204, 1006, 1, 449.50);


INSERT INTO Warehouse VALUES (401, 'New York Central');
INSERT INTO Warehouse VALUES (402, 'San Francisco Bay');
INSERT INTO Warehouse VALUES (403, 'Chicago South');


INSERT INTO ProductWarehouse VALUES (1001, 401, 25, CURRENT_TIMESTAMP, 101);
INSERT INTO ProductWarehouse VALUES (1002, 402, 15, CURRENT_TIMESTAMP, 102);
INSERT INTO ProductWarehouse VALUES (1003, 401, 60, CURRENT_TIMESTAMP, 103);
INSERT INTO ProductWarehouse VALUES (1004, 403, 20, CURRENT_TIMESTAMP, 106);
INSERT INTO ProductWarehouse VALUES (1005, 402, 40, CURRENT_TIMESTAMP, 104);
INSERT INTO ProductWarehouse VALUES (1006, 403, 10, CURRENT_TIMESTAMP, 107);


-- Create Views
CREATE VIEW Current_Inventory_Status AS
SELECT ProductID, Name, StockQuantity FROM Products;

CREATE VIEW Product_Wise_Price_Changes AS
SELECT ProductID, Name, Price, CreatedAt, UpdatedAt FROM Products;

CREATE VIEW Total_Sales_Region_Wise AS
SELECT O.OrderID, C.FirstName, C.LastName, O.TotalAmount
FROM Orders O
JOIN Customers C ON O.CustomerID = C.Customers_ID;

CREATE VIEW Week_Wise_Sales AS
SELECT TRUNC(OrderDate, 'IW') AS Week_Start, SUM(TotalAmount) AS Weekly_Sales
FROM Orders
GROUP BY TRUNC(OrderDate, 'IW')
ORDER BY Week_Start DESC;

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
SELECT * FROM Total_Sales_Region_Wise;
SELECT * FROM Week_Wise_Sales;
