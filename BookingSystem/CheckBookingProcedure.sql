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
END