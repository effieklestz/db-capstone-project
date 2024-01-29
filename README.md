# Meta Database Engineering Project

Meta Database Engineering Capstone Project.

Technologies & Tools

![Static Badge](https://img.shields.io/badge/code-sql-blue) ![Static Badge](https://img.shields.io/badge/code-python-blue) ![Static Badge](https://img.shields.io/badge/tool-mysql-blue) ![Static Badge](https://img.shields.io/badge/tool-MySQLWorkbench-blue) ![Static Badge](https://img.shields.io/badge/tool-tableau-blue)

Objectives:

\*Set up a database project

\*Add sales reports.

\*Create a table booking system.

\*Work with data analytics and visualization.

\*Create a database client.

## Getting Started Notes:

1. Database Setup :

```sql
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
```

2. Schema LittleLemonDB:

```sql
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

```

3. Table `LittleLemonDB`.`Booking`:

```sql
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Booking` (
  `BookingID` INT NOT NULL,
  `Date` DATETIME NOT NULL,
  `TableNumber` INT NOT NULL,
  PRIMARY KEY (`BookingID`))
ENGINE = InnoDB;
```

4. Table `LittleLemonDB`.`Customer`:

```sql
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customer` (
  `CustomerID` INT NOT NULL,
  `FullName` VARCHAR(255) NOT NULL,
  `ContactNumber` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;
```

5. Table `LittleLemonDB`.`Menu`:

```sql
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `MenuID` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Description` VARCHAR(255) NULL,
  PRIMARY KEY (`MenuID`))
ENGINE = InnoDB;
```

6. Table `LittleLemonDB`.`DeliveryStatus`:

```sql
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`DeliveryStatus` (
  `DeliveryID` INT NOT NULL,
  `DeliveryDate` DATETIME NOT NULL,
  PRIMARY KEY (`DeliveryID`))
ENGINE = InnoDB;
```

7. Table `LittleLemonDB`.`Orders`:

```sql
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `OrderID` INT NOT NULL,
  `Date` DATETIME NOT NULL,
  `Quantity` INT NOT NULL,
  `TotalCost` DECIMAL NULL,
  `Booking_BookingID` INT NOT NULL,
  `Customer_CustomerID` INT NOT NULL,
  `Menu_MenuID` INT NOT NULL,
  `DeliveryStatus_DeliveryID` INT NOT NULL,
  PRIMARY KEY (`OrderID`, `Customer_CustomerID`, `Menu_MenuID`, `DeliveryStatus_DeliveryID`),
  INDEX `fk_Orders_Booking_idx` (`Booking_BookingID` ASC) VISIBLE,
  INDEX `fk_Orders_Customer1_idx` (`Customer_CustomerID` ASC) VISIBLE,
  INDEX `fk_Orders_Menu1_idx` (`Menu_MenuID` ASC) VISIBLE,
  INDEX `fk_Orders_DeliveryStatus1_idx` (`DeliveryStatus_DeliveryID` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Booking`
    FOREIGN KEY (`Booking_BookingID`)
    REFERENCES `LittleLemonDB`.`Booking` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Customer1`
    FOREIGN KEY (`Customer_CustomerID`)
    REFERENCES `LittleLemonDB`.`Customer` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Menu1`
    FOREIGN KEY (`Menu_MenuID`)
    REFERENCES `LittleLemonDB`.`Menu` (`MenuID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_DeliveryStatus1`
    FOREIGN KEY (`DeliveryStatus_DeliveryID`)
    REFERENCES `LittleLemonDB`.`DeliveryStatus` (`DeliveryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
```

8. Table `LittleLemonDB`.`Staff`:

```sql
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `StaffID` INT NOT NULL,
  `FullName` VARCHAR(255) NOT NULL,
  `ContactNumber` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  `Role` VARCHAR(45) NOT NULL,
  `Salary` DECIMAL NOT NULL,
  `Customer_CustomerID` INT NOT NULL,
  PRIMARY KEY (`StaffID`),
  INDEX `fk_Staff_Customer1_idx` (`Customer_CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_Staff_Customer1`
    FOREIGN KEY (`Customer_CustomerID`)
    REFERENCES `LittleLemonDB`.`Customer` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
```

## Sales Reports:

1. Create MenuDetailsView to view Course names with Orders > 2:

```sql
CREATE VIEW MenuDetailsView AS
SELECT m.CourseName
FROM Menu m
WHERE Menus.MenuID = ANY (
    SELECT Orders.MenuID
    FROM Orders
    GROUP BY Orders.MenuID
    HAVING COUNT(*) > 2
);
```

2. Create OrderDetailsView to view Orders with Costs > $150 :

```sql
CREATE VIEW OrderDetailsView AS
SELECT c.CustomerID, c.FullName, o.OrderID, o.TotalCost, m.CourseName, m.StarterName
FROM orders o
INNER JOIN customer c ON o.customerid = c.costumerid
INNER JOIN menu m ON o.meduID = m.meduID
WHERE o.TotalCost > 150
ORDER BY o.TotalCost DESC;
```

3. Create OrdersView to view orders with Quantity > 2 :

```sql
CREATE VIEW OrdersView AS
SELECT orders.OrderID, orders.Quantity, orders.TotalCost
FROM orders
WHERE orders.Quantity > 2;
```

## Booking System:

1. Create CheckBooking Procedure to check whether a table in the restaurant is already booked:

```sql
CREATE PROCEDURE 'CheckBooking'(booking_date DATE, table_number INT)
BEGIN
DECLARE bookingTable INT DEFAULT 0;
 SELECT COUNT(bookingTable)
    INTO bookingTable
    FROM Bookings WHERE BookingDate = booking_date and TableNumber = table_number;
    IF bookingTable > 0 THEN
      SELECT CONCAT( "Table", table_number, "is already booked") AS "Booking status";
      ELSE
      SELECT CONCAT( "Table", table_number, "is not booked") AS "Booking status";
    END IF;
END;
```

1. Create CheckBooking Procedure to verify a booking, and decline any reservations for tables that are already booked under another name:

```sql
DELIMITER //
CREATE PROCEDURE AddValidBooking(
    IN bookingDate DATE,
    IN tableNumber INT,
    IN customerName VARCHAR(255)
)
BEGIN
    DECLARE @existingBookingCount INT;
    -- Check if the table is already booked
    SELECT COUNT(*) INTO @existingBookingCount
    FROM Bookings
    WHERE BookingDate = bookingDate AND TableNumber = tableNumber;
      -- Start a transaction
    START TRANSACTION;
    IF @existingBookingCount > 0 THEN
        -- Rollback transaction
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Table is already booked for this date.';
    ELSE
        -- Insert new booking
        INSERT INTO Bookings (BookingDate, TableNumber, CustomerName)
        VALUES (bookingDate, tableNumber, customerName);
        -- Commit the transaction
        COMMIT;
    END IF;
END //
DELIMITER ;
```

## Tableau Analytics:

1. Dashboard in Tableau with Little Lemon's Sales and Profits:
   ![Alt text](<Tableau Analytics/Little Lemon Dashboard.png>)
