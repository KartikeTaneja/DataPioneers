
-- Function: get_inventory_value
CREATE OR REPLACE FUNCTION get_inventory_value(p_product_id NUMBER)
RETURN NUMBER IS
  v_price NUMBER;
  v_qty   NUMBER;
BEGIN
  SELECT Price, StockQuantity INTO v_price, v_qty
  FROM Products
  WHERE ProductID = p_product_id;

  RETURN v_price * v_qty;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    RETURN -1;
END;
/



-- Package Specification: inventory_pkg
CREATE OR REPLACE PACKAGE inventory_pkg AS
  PROCEDURE fulfill_backorders(p_product_id NUMBER);
  FUNCTION get_inventory_value(p_product_id NUMBER) RETURN NUMBER;
END inventory_pkg;
/



-- Package Body: inventory_pkg
CREATE OR REPLACE PACKAGE BODY inventory_pkg AS

  PROCEDURE fulfill_backorders(p_product_id NUMBER) IS
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
  END fulfill_backorders;

  FUNCTION get_inventory_value(p_product_id NUMBER) RETURN NUMBER IS
    v_price NUMBER;
    v_qty   NUMBER;
  BEGIN
    SELECT Price, StockQuantity INTO v_price, v_qty
    FROM Products
    WHERE ProductID = p_product_id;

    RETURN v_price * v_qty;
  END get_inventory_value;

END inventory_pkg;
/



-- Grant EXECUTE privilege to data_pioneers
GRANT EXECUTE ON inventory_pkg TO data_pioneers;

