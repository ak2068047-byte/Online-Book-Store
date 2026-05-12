-- SQLBook: Code
-- CREATE DATABASE online_book;
USE online_book;

CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);


CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(50),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
    Customer_ID	INT REFERENCES Customers(Cusomer_ID),
    Book_ID	INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10,2)
);

-- ===============================
-- Basic Queries
-- ===============================

--  1) Retrieve all books in the "Fiction" genre
SELECT * FROM Books WHERE Genre = "Fiction";

-- 2) Find books published after the year 1950
SELECT * FROM Books WHERE Published_Year > 1950;

-- 3) List all customers from the Canada
SELECT * FROM Customers WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023
SELECT * FROM Orders 
WHERE Order_Date 
BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available
SELECT SUM(Stock) AS total_stock FROM Books;

-- 6) Find the details of the most expensive book
SELECT * FROM Books
ORDER BY price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
SELECT * FROM Orders
WHERE Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders 
WHERE Total_Amount > 20;

-- 9) List all genres available in the Books table
SELECT DISTINCT Genre FROM Books;

-- 10) Find the book with the lowest stock
SELECT MIN(Stock) AS Lowest_Stock FROM Books;

-- 11) Calculate the total revenue generated from all orders
SELECT SUM(Total_Amount) AS Total_Revenue FROM Orders;	

-- ===============================
-- Advance Queries
-- ===============================

-- 1) Retrieve the total number of books sold for each genre
SELECT b.Genre, COUNT(o.Quantity) AS Books_Sold  FROM
Books b
JOIN Orders o
ON B.Book_ID = o.Book_ID
GROUP BY Genre;

SELECT b.Genre, SUM(o.Quantity) AS Books_Sold  FROM
Orders o
JOIN Books b
ON B.Book_ID = o.Book_ID
GROUP BY Genre
ORDER BY Books_Sold DESC;

-- 2) Find the average price of books in the "Fantasy" genre
SELECT AVG(Price) Average_Price  FROM Books WHERE Genre = "Fantasy";

-- 3) List customers who have placed at least 2 orders
SELECT Customer_ID, COUNT(Order_ID) FROM Orders  
GROUP BY Customer_ID HAVING COUNT(Order_id) >= 2;

SELECT C.Name,O.Customer_ID,COUNT(O.Order_ID) AS Order_count  FROM Customers C
JOIN Orders O
ON O.Customer_ID = C.Customer_ID
GROUP BY C.Name,O.Customer_ID
HAVING COUNT(Order_ID);

-- 4) Find the most frequently ordered book
SELECT Book_ID, COUNT(Order_ID) AS Order_Count
FROM Orders
GROUP BY Book_ID
ORDER BY Order_Count DESC LIMIT 1;

SELECT C.Title,O.Book_ID, COUNT(O.Order_ID) AS Order_Count FROM Orders O
JOIN Books C
ON O.Book_ID = C.Book_ID
GROUP BY C.Title,Book_ID
ORDER BY Order_Count DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre 
SELECT * FROM Books 
WHERE Genre = 'Fantasy'
ORDER BY Price DESC LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author
SELECT b.Author,SUM(o.Quantity) Total_Books_Solds FROM Books b
JOIN Orders o
ON O.Book_ID = b.Book_id
GROUP BY b.Author
ORDER BY Total_Books_Solds DESC;


-- 7) List the cities where customers who spent over $30 are located

SELECT c.City, o.Total_Amount FROM Customers c 
JOIN Orders o
ON o.Customer_ID = c.Customer_ID
WHERE o.Total_Amount > 30;

-- 8) Find the customer who spent the most on orders
SELECT c.Customer_ID, c.Name,
SUM(o.Total_Amount) AS Most_Spent 
FROM Customers c
JOIN Orders o
ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID,c.Name
ORDER BY Most_Spent DESC LIMIT 5;

-- 9) Calculate the stock remaining after fulfilling all order 
SELECT b.Book_ID,b.Title, b.Stock, COALESCE(SUM(o.Quantity),0) AS Order_Quantity,
b.Stock - COALESCE(SUM(o.Quantity),0) AS Remaining_Quantity
FROM Books b
JOIN Orders o
ON o.Book_ID = b.Book_ID
GROUP BY b.Book_ID;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;