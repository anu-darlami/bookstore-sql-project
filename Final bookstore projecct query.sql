
USE bookstore;

-- Task 1: Create Views
-- View 1: Create a view to show the highest-rated book
CREATE VIEW highest_rated_book AS
SELECT 
    b.book_id,
    b.book_title,
    b.author_id,
    a.first_name AS author_first_name,
    a.last_name AS author_last_name,
    AVG(r.rating) AS average_rating
FROM 
    book b
JOIN 
    review r ON b.book_id = r.book_id
JOIN
    author a ON b.author_id = a.author_id
GROUP BY 
    b.book_id
ORDER BY 
    average_rating DESC
LIMIT 1;
-- Explanation: This view calculates the average rating for each book
-- and displays the book with the highest average rating. This can help
-- in identifying which book is the most well-received by readers.

SELECT * FROM highest_rated_book;

-- View 2: Books Published in a Specific Year Range
CREATE VIEW BooksPublishedInRange AS
SELECT book_id, book_title, author_id, published_date
FROM book
WHERE YEAR(published_date) BETWEEN 1930 AND 1990;

SELECT * FROM BooksPublishedInRange;

-- Explanation: This view provides a subset of books published within a certain 
-- timeframe, useful for trend analysis or targeted promotions.


-- Task 2: Create Stored Procedures
-- Procedure 1: Add a New Book
DELIMITER //
CREATE PROCEDURE AddNewBook(
    IN p_book_title VARCHAR(255),
    IN p_author_id INT,
    IN p_genre VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_published_date DATE
)
BEGIN
    INSERT INTO book (book_title, author_id, genre, price, published_date)
    VALUES (p_book_title, p_author_id, p_genre, p_price, p_published_date);
END //
DELIMITER ;

-- Adding new book information
CALL AddNewBook('The Great Gatsby', 7, 'Classic', 10.99, '1925-04-10');

SELECT * FROM book WHERE book_title = 'The Great Gatsby';

-- Explanation: This procedure simplifies the process of adding a new book 
-- to the database, ensuring all required fields are included.
  DROP PROCEDURE IF EXISTS AddNewOrder;  
SHOW PROCEDURE STATUS WHERE Db = 'bookstore';
-- Procedure 2: Adding a New Order and Order Details
DELIMITER //
CREATE PROCEDURE AddNewOrder(
    IN p_customer_id INT, 
    IN p_order_date DATE, 
    IN p_total_amount DECIMAL(10,2),
    IN p_book_id INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE new_order_id INT;

    -- Insert new order
    INSERT INTO orders (customer_id, order_date, total_amount)
    VALUES (p_customer_id, p_order_date, p_total_amount);
    
    -- Get the new order ID
    SET new_order_id = LAST_INSERT_ID();
    
    -- Insert order details
    INSERT INTO order_details (order_id, book_id, quantity, price) 
    VALUES (new_order_id, p_book_id, p_quantity, p_price);
END //
DELIMITER ;

-- Explanation: This procedure adds a new order and its details, ensuring both 
-- the order and the associated items are recorded in their respective tables.

-- Task 3: Outline the Use of Transactions
-- Transaction 1: Deduct stock
START TRANSACTION;

-- Deduct stock from book_branch table
UPDATE book_branch
JOIN order_details ON book_branch.book_id = order_details.book_id
SET book_branch.quantity = book_branch.quantity - order_details.quantity
WHERE order_details.order_id = 5;

-- Insert a record into sales table
INSERT INTO sales (sale_date, book_id, quantity, total_amount)
SELECT Now(), order_details.book_id, order_details.quantity, (order_details.quantity * order_details.price)
FROM order_details
WHERE order_details.order_id = 5;

-- Commit the transaction
COMMIT;

SELECT * FROM book_branch WHERE book_id IN (SELECT book_id FROM order_details WHERE order_id = 5);

-- Explanation: This transaction handles the stock deduction and records the sale for a specific
--  order, ensuring data consistency across the related tables.

-- Task 3: New Order Transaction
START TRANSACTION;

-- Insert a new customer
INSERT INTO customer (first_name, last_name, email, phone)
VALUES ('Lillian', 'Jennier', 'lillian.jennier@example.com', '556-464-3876');

-- Capture the new customer ID
SET @new_customer_id = LAST_INSERT_ID();

-- Insert a new order for the new customer
INSERT INTO orders (customer_id, orderdate, totalamount)
VALUES (@new_customer_id, '2024-08-10', 195.85);

-- Capture the new order ID
SET @new_order_id = LAST_INSERT_ID();

-- Insert order details for the books purchased in this order
INSERT INTO order_details (order_id, book_id, quantity, price)
VALUES 
  (@new_order_id, 1, 2, 19.99),  -- 2 copies of 'Harry Potter and the Philosopher's Stone'
  (@new_order_id, 4, 1, 24.99),  -- 1 copy of 'Foundation'
  (@new_order_id, 9, 3, 20.99);  -- 3 copies of 'Fahrenheit 451'

-- Commit the transaction
COMMIT;
SELECT * FROM customer WHERE email = 'lillian.jennier@example.com';
SELECT * FROM orders WHERE customer_id = @new_customer_id AND orderdate = '2024-08-10';

-- Explanation: This transaction adds a new customer and their order, then inserts details 
-- for the books purchased. It uses the generated IDs for the customer and order to ensure
-- the order details are correctly associated with the new customer and order. 


-- Task 4: Create Triggers
-- Trigger 1: Update Inventory Levels After a Purchase

DELIMITER //
CREATE TRIGGER update_inventory_after_purchase
AFTER INSERT ON order_details
FOR EACH ROW
BEGIN
    -- Update the quantity of the book in the relevant branch
    UPDATE book_branch
    SET quantity = quantity - NEW.quantity
    WHERE book_id = NEW.book_id
    AND EXISTS (
        SELECT 1
        FROM orders
        WHERE order_id = NEW.order_id
    );
END //
DELIMITER ;

-- Inserting a new order detail to trigger the update_inventory_after_purchase trigger
INSERT INTO order_details (order_id, book_id, quantity, price) 
VALUES (1, 1, 2, 27.99);

-- Verifing the update in the book_branch table
SELECT * FROM book_branch
WHERE book_id = 1;

-- This trigger automatically update the inventory levels in the book_branch table
--  whenever a new entry is added to the order_details table which  helps in 
-- maintaining accurate inventory levels by automatically adjusting the stock when 
-- new orders are placed.

-- Trigger 2: Notify When Book Stock Falls Below Threshold
DELIMITER //
CREATE TRIGGER notify_low_stock
AFTER UPDATE ON book_branch
FOR EACH ROW
BEGIN
    -- Check if the quantity is below the threshold
    IF NEW.quantity < 5 THEN
        -- Insert a notification entry into the sales table
        INSERT INTO sales (sale_date, book_id, quantity, total_amount)
        VALUES (NOW(), NEW.book_id, 0, 0.00);
    END IF;
END //
DELIMITER ;

-- Manually updating the quantity to a value below the threshold to verify
UPDATE book_branch
SET quantity = 3  -- Set this below the threshold (e.g., 5)
WHERE book_id = 1
AND branch_id = 2;

-- Verify the entry in the sales table indicating a low-stock alert
SELECT * FROM sales
WHERE book_id = 1;

-- This trigger helps to automatically generate a low-stock notification when a book's
-- inventory falls below a predefined threshold. This can be useful for inventory 
-- management to alert staff about items that need to be reordered.


-- Task 5: User Defined Functions
-- User defined function

DELIMITER //
CREATE FUNCTION calculate_inventory_cost(bookId INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE totalCost DECIMAL(10,2);

    -- Calculating the total cost of the book in inventory
    SELECT SUM(bb.quantity * b.price) INTO totalCost
    FROM book_branch bb
    JOIN book b ON bb.book_id = b.book_id
    WHERE b.book_id = bookId;

    -- Return the total cost
    RETURN IFNULL(totalCost, 0.00);
END //
DELIMITER ;

SELECT calculate_inventory_cost(5) AS total_inventory_cost;

-- This user define function calculates the total inventory cost of a specified book. 
-- across all branches.


-- Task 6: Automating the event
SET GLOBAL event_scheduler = ON;

-- Event 1: Apply Monthly Price Increase
DELIMITER //
CREATE EVENT monthly_price_increase
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-08-15 00:00:00'
DO
BEGIN
    -- Update book prices by 5%
    UPDATE book
    SET price = price * 0.50;
END //
DELIMITER ;
--

SHOW EVENTS;
SHOW CREATE EVENT monthly_price_increase;
-- This query sets up a MySQL event scheduler to automate a monthly price increase for books

-- Tsak 2 :Update Monthly Sales Report
DELIMITER //
CREATE EVENT update_monthly_sales_report
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-08-15 01:00:00'
DO
BEGIN
    -- Update the monthly sales report with aggregated data
    INSERT INTO monthly_sales_report (report_date, total_sales)
    SELECT
        DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') AS report_date,
        COALESCE(SUM(total_amount), 0) AS total_sales
    FROM sales
    WHERE sale_date BETWEEN DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') AND LAST_DAY(NOW() - INTERVAL 1 MONTH)
    ON DUPLICATE KEY UPDATE total_sales = VALUES(total_sales);
END //
DELIMITER ;

SHOW CREATE EVENT update_monthly_sales_report;