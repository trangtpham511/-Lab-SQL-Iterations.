-- Write a query to find what is the total business done by each store.
SELECT i.store_id, SUM(p.amount) AS total_business FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY store_id;

-- Convert the previous query into a stored procedure.

DROP PROCEDURE IF EXISTS total_business;
DELIMITER //
CREATE PROCEDURE total_business()
BEGIN
SELECT i.store_id, SUM(p.amount) AS total_business FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY store_id;
END;
//
DELIMITER;
CALL total_business();

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
DROP PROCEDURE IF EXISTS total_business_input;
DELIMITER //
CREATE PROCEDURE total_business_input(IN param1 INTEGER)
BEGIN
SELECT i.store_id , SUM(p.amount) AS total_business FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE store_id = param1
GROUP BY store_id;
END;
//
DELIMITER;
CALL total_business_input("1");

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store).
-- Call the stored procedure and print the results.
DROP PROCEDURE IF EXISTS total_sales_value;
DELIMITER //
CREATE PROCEDURE total_sales_value(IN param1 INTEGER, OUT param2 FLOAT)
BEGIN
DECLARE total_sales FLOAT;
SELECT ROUND(SUM(p.amount),2) INTO param2 FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.store_id = param1
GROUP BY i.store_id;
END;
//
DELIMITER;
CALL total_sales_value("2",@x);
SELECT @x AS total_sales;
 
-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.
DROP PROCEDURE IF EXISTS total_sales_flag;
DELIMITER //

CREATE PROCEDURE total_sales_flag (
  IN param1 INTEGER,
  OUT param2 FLOAT,
  OUT param3 CHAR(15)
) -- param 2 = total_sales
-- param 3 = region

BEGIN
  DECLARE param2 FLOAT DEFAULT 0.0;
  DECLARE param3 CHAR(15) DEFAULT "";
  
  SELECT
    ROUND(SUM(amount), 2) INTO total_sales
  FROM
    
    (SELECT
      p.amount
    FROM
      sakila.payment p
      JOIN sakila.rental r
        ON p.rental_id = r.rental_id
      JOIN sakila.inventory i
        ON r.inventory_id = i.inventory_id
    WHERE i.store_id = param1) AS sub1;
  
  SELECT
    total_sales;
  
 IF total_sales > 30000
    THEN SET flag_value = "green_flag";
    
    ELSE SET flag_value = "red_flag";
    
  END IF;
    
  SELECT
    total_sales INTO param2;
  
  SELECT
    flag_value INTO param3;
  
END;
//


DELIMITER;

CALL total_sales_flag("2",@x, @y);

