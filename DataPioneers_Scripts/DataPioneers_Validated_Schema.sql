
-- Drop Tables if exist
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

-- Drop Views if exist (optional)
BEGIN EXECUTE IMMEDIATE 'DROP VIEW Current_Inventory_Status'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW Product_Wise_Price_Changes'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW Total_Sales_Region_Wise'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW Week_Wise_Sales'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Create Customers table
CREATE TABLE Customers (
    Customers_ID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(100 CHAR) NOT NULL,
    LastName VARCHAR2(100 CHAR) NOT NULL,
    Email VARCHAR2(255 CHAR) NOT NULL UNIQUE,
    Phone VARCHAR2(20 CHAR) NOT NULL CHECK (LENGTH(Phone) >= 10),
    CreatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create Suppliers table
CREATE TABLE Suppliers (
    SupplierID NUMBER PRIMARY KEY,
    CompanyName VARCHAR2(255 CHAR) NOT NULL,
    ContactPerson VARCHAR2(200 CHAR) NOT NULL,
    Phone VARCHAR2(20 CHAR) NOT NULL CHECK (LENGTH(Phone) >= 10)
);

-- Create Products table
CREATE TABLE Products (
    ProductID NUMBER PRIMARY KEY,
    Name VARCHAR2(255 CHAR) NOT NULL,
    Category VARCHAR2(200 CHAR) NOT NULL,
    Price NUMBER(10,2) NOT NULL CHECK (Price > 0 AND Price <= 10000),
    StockQuantity NUMBER NOT NULL CHECK (StockQuantity >= 0),
    SupplierID NUMBER NOT NULL,
    CreatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP WITH LOCAL TIME ZONE,
    CONSTRAINT Products_Suppliers_FK FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID NUMBER PRIMARY KEY,
    CustomerID NUMBER NOT NULL,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount NUMBER(10,2) NOT NULL CHECK (TotalAmount > 0),
    OrderStatus VARCHAR2(20) DEFAULT 'Pending'
        CHECK (OrderStatus IN ('Pending', 'Fulfilled', 'Backordered')),
    CONSTRAINT Orders_Customers_FK FOREIGN KEY (CustomerID) REFERENCES Customers(Customers_ID)
);

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    OrderDetailID NUMBER PRIMARY KEY,
    OrderID NUMBER NOT NULL,
    ProductID NUMBER NOT NULL,
    Quantity NUMBER NOT NULL CHECK (Quantity > 0),
    SubTotal NUMBER(10,2) NOT NULL CHECK (SubTotal > 0),
    CONSTRAINT OrderDetails_Orders_FK FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT OrderDetails_Products_FK FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Warehouse table
CREATE TABLE Warehouse (
    WarehouseID NUMBER PRIMARY KEY,
    Location VARCHAR2(255 CHAR) NOT NULL
);

-- Create ProductWarehouse table
CREATE TABLE ProductWarehouse (
    ProductID NUMBER NOT NULL,
    WarehouseID NUMBER NOT NULL,
    StockLevel NUMBER NOT NULL CHECK (StockLevel >= 0),
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SupplierID NUMBER NOT NULL,
    PRIMARY KEY (ProductID, WarehouseID),
    CONSTRAINT ProductWarehouse_Product_FK FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT ProductWarehouse_Warehouse_FK FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    CONSTRAINT ProductWarehouse_Suppliers_FK FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);


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


