
-- STEP 1: Create stored procedure to fulfill backorders
CREATE OR REPLACE PROCEDURE fulfill_backorders(p_product_id NUMBER) AS
BEGIN
    FOR order_rec IN (
        SELECT o.OrderID, od.Quantity
        FROM Orders o
        JOIN OrderDetails od ON o.OrderID = od.OrderID
        WHERE o.OrderStatus = 'Backordered'
          AND od.ProductID = p_product_id
          AND od.Quantity <= (SELECT StockQuantity FROM Products WHERE ProductID = p_product_id)
    ) LOOP
        -- Fulfill the order
        UPDATE Orders
        SET OrderStatus = 'Fulfilled'
        WHERE OrderID = order_rec.OrderID;

        -- Deduct the product quantity
        UPDATE Products
        SET StockQuantity = StockQuantity - order_rec.Quantity
        WHERE ProductID = p_product_id;
    END LOOP;
END;
/

-- STEP 2: Simulate stock replenishment and process backorders

-- Clear test data
DELETE FROM OrderDetails WHERE OrderDetailID = 401;
DELETE FROM Orders WHERE OrderID = 305;

-- Step 1: Make product 1003 out of stock
UPDATE Products SET StockQuantity = 0 WHERE ProductID = 1003;

-- Step 2: Add a new backordered order
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, OrderStatus)
VALUES (305, 1, CURRENT_TIMESTAMP, 3.98, 'Backordered');

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, SubTotal)
VALUES (401, 305, 1003, 2, 3.98);

-- Step 3: Confirm it's backordered
SELECT 'Step 3: Before Fulfillment' AS Step, OrderID, CustomerID, TotalAmount, OrderStatus
FROM Orders WHERE OrderID = 305;

-- Step 4: Replenish stock and call procedure to auto-fulfill
UPDATE Products SET StockQuantity = 10 WHERE ProductID = 1003;
EXEC fulfill_backorders(1003);
COMMIT;

-- Step 5: Confirm the order is now fulfilled
SELECT 'Step 5: After Fulfillment' AS Step, OrderID, CustomerID, TotalAmount, OrderStatus
FROM Orders WHERE OrderID = 305;

-- Step 6: Confirm product stock is reduced
SELECT 'Step 6: Product Stock After Fulfillment' AS Step, ProductID, StockQuantity 
FROM Products WHERE ProductID = 1003;
