-- Correct way to access objects from data_pioneers user:

SELECT * FROM data_pioneers_admin.Customers;
SELECT * FROM data_pioneers_admin.Suppliers;
SELECT * FROM data_pioneers_admin.Products;
SELECT * FROM data_pioneers_admin.Orders;
SELECT * FROM data_pioneers_admin.OrderDetails;
SELECT * FROM data_pioneers_admin.Warehouse;
SELECT * FROM data_pioneers_admin.ProductWarehouse;

-- Views
SELECT * FROM data_pioneers_admin.Current_Inventory_Status;
SELECT * FROM data_pioneers_admin.Product_Wise_Price_Changes;
SELECT * FROM data_pioneers_admin.Total_Sales_By_Customer;
SELECT * FROM data_pioneers_admin.Week_Wise_Sales;


-- Fully qualified call using owner name
SELECT data_pioneers_admin.inventory_pkg.get_inventory_value(1001) FROM dual;

-- Optional: run procedure
EXEC data_pioneers_admin.inventory_pkg.fulfill_backorders(1001);
