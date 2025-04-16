
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


-- Step 1: Replenish stock for Product 1001 so the backorder can be fulfilled
UPDATE Products SET StockQuantity = 1000 WHERE ProductID = 1001;

-- Step 2: Run the procedure to fulfill backorders
EXEC fulfill_backorders(1001);
COMMIT;

-- Step 3: Verify that Order 206 is now fulfilled
SELECT 'Order Status Check' AS Step, OrderID, OrderStatus 
FROM Orders WHERE OrderID = 206;

-- Step 4: Confirm stock reduced properly
SELECT 'Stock After Fulfillment' AS Step, ProductID, StockQuantity 
FROM Products WHERE ProductID = 1001;
