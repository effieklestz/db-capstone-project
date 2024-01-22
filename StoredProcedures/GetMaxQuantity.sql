CREATE PROCEDURE 'GetMaxQuantity'()
SELECT max(quantity) AS "Max Quantity in Order" FROM orders