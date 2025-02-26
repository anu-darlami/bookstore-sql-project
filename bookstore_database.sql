-- *************************************************************
-- This script creates bookstore databases
-- *************************************************************

-- ********************************************
-- CREATE THE BOOKSTORE DATABASE
-- ********************************************

-- create the database
drop database if exists bookstore;
create database bookstore;
use bookstore;

-- create the tables
create table author (
    author_id int auto_increment primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null
);

create table book (
    book_id int auto_increment primary key,
    book_title varchar(255) not null,
    author_id int not null,
    genre varchar(50) not null,
    price decimal(10,2) not null,
    published_date date not null,
    foreign key (author_id) references author(author_id)
);

create table customer(
customer_id int auto_increment primary key,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(100) not null,
phone varchar(50) not null
);

create table branch (
    branch_id int auto_increment primary key,
    branch_name varchar(100) not null,
    branch_location varchar(255) not null
);

create table book_branch (
    book_branch_id int auto_increment primary key,
    book_id int not null,
    branch_id int not null,
    quantity int not null,
    foreign key (book_id) references book(book_id),
    foreign key (branch_id) references branch(branch_id)
);

create table orders(
    order_id int auto_increment primary key,
    customer_id int not null,
    orderdate date not null,
    totalamount decimal(10,2) not null,
    foreign key (customer_id) references customer(customer_id)
); 

create table order_details(
order_detail_id int auto_increment primary key,
order_id int not null,
book_id int not null,
quantity int,
price decimal(10,2) not null,
foreign key(order_id) references orders(order_id),
foreign key(book_id) references book(book_id)
); 

-- create the sales table
create table sales (
    sale_id int auto_increment primary key,
    sale_date date not null,
    book_id int not null,
    quantity int not null,
    total_amount decimal(10,2) not null,
    foreign key (book_id) references book(book_id)
);
ALTER TABLE sales MODIFY sale_date DATETIME;

create table review (
    review_id int auto_increment primary key,
    book_id int not null,
    customer_id int not null,
    rating int not null check (rating between 1 and 5),
    review_text text,
    review_date date not null,
    foreign key (book_id) references book(book_id),
    foreign key (customer_id) references customer(customer_id)
);


create table discount (
    discount_id int auto_increment primary key,
    book_id int not null,
    discount_percentage decimal(5,2) not null,
    start_date date not null,
    end_date date not null,
    foreign key (book_id) references book(book_id)
);

CREATE TABLE monthly_sales_report (
    report_date DATE PRIMARY KEY,
    total_sales DECIMAL(10, 2) NOT NULL
);


-- insert rows into the tables
insert into author (first_name, last_name) values
('J.K.', 'Rowling'),
('George', 'Orwell'),
('Isaac', 'Asimov'),
('Ernest', 'Hemingway'),
('Jane', 'Austen'),
('Mark', 'Twain'),
('F. Scott', 'Fitzgerald'),
('Leo', 'Tolstoy'),
('Agatha', 'Christie'),
('Charles', 'Dickens');

insert into book (book_title, author_id, genre, price, published_date) values 
('Harry Potter and the Philosopher\'s Stone', 1, 'Fantasy', 19.99, '1997-06-26'),
('1984', 2, 'Dystopian', 14.99, '1949-06-08'),
('Harry Potter and the Goblet of Fire', 1, 'Fantasy', 29.99, '2000-07-08'),
('Foundation', 3, 'Science Fiction', 24.99, '1965-06-01'),
('Moby Dick', 2, 'Adventure', 17.99, '1851-10-18'),
('Harry Potter and the Chamber of Secrets', 1, 'Fantasy', 22.99, '1998-07-02'),
('Fahrenheit 451', 3, 'Science Fiction', 20.99, '1953-10-19'),
('Gone with the Wind', 2, 'Historical Fiction', 18.99, '1936-06-30'),
('Neuromancer', 3, 'Science Fiction', 21.99, '1984-10-01'),
('Harry Potter and the Prisoner of Azkaban', 1, 'Fantasy', 25.99, '1999-07-08');

insert into customer (first_name, last_name, email, phone) values
('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210'),
('Alice', 'Johnson', 'alice.johnson@example.com', '123-123-1234'),
('Bob', 'Williams', 'bob.williams@example.com', '456-456-4567'),
('Charlie', 'Brown', 'charlie.brown@example.com', '789-789-7890'),
('David', 'Jones', 'david.jones@example.com', '321-321-3210'),
('Eve', 'Davis', 'eve.davis@example.com', '654-654-6543'),
('Frank', 'Miller', 'frank.miller@example.com', '987-987-9870'),
('Grace', 'Wilson', 'grace.wilson@example.com', '111-222-3333'),
('Hank', 'Moore', 'hank.moore@example.com', '444-555-6666'),
('Ivy', 'Taylor', 'ivy.taylor@example.com', '777-888-9999'),
('Jack', 'Anderson', 'jack.anderson@example.com', '101-010-1010'),
('Kathy', 'Thomas', 'kathy.thomas@example.com', '202-020-2020'),
('Leo', 'Jackson', 'leo.jackson@example.com', '303-030-3030'),
('Mona', 'White', 'mona.white@example.com', '404-040-4040');

insert into orders (customer_id, orderdate, totalamount) values
(1, '2023-01-15', 120.50),
(2, '2023-02-17', 89.90),
(3, '2023-03-20', 150.75),
(4, '2023-04-22', 200.00),
(5, '2023-05-25', 75.25),
(6, '2023-06-27', 110.60),
(7, '2023-07-29', 95.30),
(8, '2023-08-31', 130.45),
(9, '2023-09-12', 99.99),
(10, '2023-10-14', 145.80);

insert into order_details (order_id, book_id, quantity, price) values
  (1, 1, 2, 25.99),
  (1, 5, 1, 15.50),
  (2, 3, 3, 35.75),
  (2, 4, 1, 20.00),
  (3, 9, 2, 25.99),
  (3, 6, 1, 18.75),
  (7, 2, 4, 45.25),
  (5, 4, 2, 40.00),
  (9, 8, 1, 15.50),
  (4, 7, 3, 29.99),
  (1, 1, 3, 30.50),
  (2, 2, 2, 22.00),
  (3, 6, 1, 35.75),
  (4, 5, 4, 15.50),
  (2, 1, 2, 25.99),
  (6, 2, 1, 30.50),
  (9, 7, 3, 29.99),
  (8, 3, 2, 35.75),
  (2, 7, 1, 20.00),
  (1, 4, 4, 18.75);
  
insert into sales (sale_date, book_id, quantity, total_amount) values
('2024-07-15', 1, 5, 99.95),  -- Harry Potter and the Philosopher's Stone
('2024-07-16', 3, 3, 89.97),  -- Harry Potter and the Goblet of Fire
('2024-07-17', 2, 7, 104.93),  -- 1984
('2024-07-18', 4, 4, 99.96),  -- Foundation
('2024-07-19', 5, 2, 35.98),  -- Moby Dick
('2024-07-20', 6, 6, 137.94),  -- Harry Potter and the Chamber of Secrets
('2024-07-21', 8, 5, 109.95),  -- Neuromancer
('2024-07-22', 7, 1, 18.99);  -- Gone with the Wind

  
insert into branch (branch_name, branch_location) values
('NewSudbury Branch', '74 mackenzie, Sudbbury'),
('Downtown Branch', '456 Paris, Downtown'),
('Capreol Branch', '24 Meehan st, Capreol');

-- Book Branch Data
insert into book_branch (book_id, branch_id, quantity) values
(1, 2, 10),  -- Harry Potter and the Philosopher's Stone at Downtown Branch
(2, 2, 5),   -- 1984 at Downtown Branch
(3, 2, 15),  -- Harry Potter and the Goblet of Fire at Downtown Branch
(4, 1, 20),  -- Foundation at NewSudbury Branch
(5, 1, 8),   -- Moby Dick at NewSudbury Branch
(6, 3, 12),  -- Harry Potter and the Chamber of Secrets at Capreol Branch
(7, 3, 7),   -- Gone with the Wind at Capreol Branch
(8, 2, 6),   -- Neuromancer at Downtown Branch
(9, 1, 9),   -- Fahrenheit 451 at NewSudbury Branch
(10, 3, 14); -- Harry Potter and the Prisoner of Azkaban at Capreol Branch

-- Sample Review Data
insert into review (book_id, customer_id, rating, review_text, review_date) values
(1, 1, 5, 'An amazing start to the series. Captivating and magical!', '2024-01-10'),
(1, 2, 4, 'A great book but a bit too long in some parts.', '2024-02-15'),
(2, 3, 5, 'A chilling and thought-provoking dystopian novel.', '2024-03-22'),
(3, 4, 5, 'Incredible! The best in the Harry Potter series.', '2024-04-30'),
(4, 5, 4, 'A classic science fiction book that remains relevant today.', '2024-05-25'),
(5, 6, 3, 'Interesting read but a bit slow.', '2024-06-15'),
(6, 7, 5, 'A thrilling continuation of the Harry Potter!', '2024-07-09'),
(7, 8, 4, 'A must-read for science fiction fans.', '2024-08-20'),
(8, 9, 3, 'Good historical fiction, but a bit too dramatic for my taste.', '2024-09-12'),
(9, 10, 5, 'An engaging and complex science fiction novel.', '2024-10-05'),
(10, 1, 4, 'A strong ending to the Harry Potter series with many twists.', '2024-11-01');

insert into discount (book_id, discount_percentage, start_date, end_date) values
(1, 15.00, '2024-08-01', '2024-08-31'),
(2, 10.00, '2024-09-01', '2024-09-30'),
(3, 20.00, '2024-10-01', '2024-10-31'),
(4, 25.00, '2024-11-01', '2024-11-30'),
(5, 5.00, '2024-12-01', '2024-12-31'),
(6, 18.00, '2024-01-01', '2024-01-31'),
(7, 12.00, '2024-02-01', '2024-02-29'),
(8, 8.00, '2024-03-01', '2024-03-31'),
(9, 22.00, '2024-04-01', '2024-04-30'),
(10, 30.00, '2024-05-01', '2024-05-31');

-- Update customer name --
update customer
set last_name = 'Smith'
where customer_id = 1;

-- Search book from alphabet--
select book_id , book_title from book
where book_title like'H%';

-- Change price --
update book
set price = 22.99
where book_id = 3;

-- join query for book name along with author name --
select book.book_id, book.book_title, author.first_name, author.last_name ,book.genre, book.price, book.published_date
from book
join author on book.author_id = author.author_id;

 -- total sum of order by customers --
select
  customer_id, 
  SUM(totalamount) as total_amount
from orders
group by customer_id with rollup;

-- count function to count number of books by each author --
select author.first_name, author.last_name ,COUNT(book.book_id) as book_count
from book
join author on book.author_id = author.author_id
group by author.author_id;


-- Final Project: Advanced Queried
-- *************************************************************

 
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
