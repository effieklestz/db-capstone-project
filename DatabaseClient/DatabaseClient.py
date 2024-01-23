import mysql.connector as connector
connection = connector.connect(user="LittleLemonUser1", password="Metadbproject1?")
cursor = connection.cursor()
cursor.execute("USE LittleLemonDB")

SelectQuery =
"""
SELECT customer.FullName, 
customer.contactNumber, 
orders.TotalCost
FROM customers
INNER JOIN orders ON customer.customerID = orders.customerID
WHERE orders.TotalCost > 60;

"""

cursor.execute(SelectQuery)
results =cursor.fetchall()
print(cursor.column_names)
print(results)