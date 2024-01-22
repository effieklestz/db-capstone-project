CREATE VIEW MenuDetailsView AS
SELECT m.CourseName
FROM Menu m
WHERE Menus.MenuID = ANY (
    SELECT Orders.MenuID
    FROM Orders
    GROUP BY Orders.MenuID
    HAVING COUNT(*) > 2
);