CREATE VIEW OrderDetailsView AS
SELECT c.CustomerID, c.FullName, o.OrderID, o.TotalCost, m.CourseName, m.StarterName
FROM orders o
INNER JOIN customer c ON o.customerid = c.costumerid
INNER JOIN menu m ON o.meduID = m.meduID
WHERE o.TotalCost > 150
ORDER BY o.TotalCost DESC;