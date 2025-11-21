### 📜 Paper 3: Table & Data Generation Scripts

This paper uses an e-commerce schema. Here are the scripts to create the tables and insert sample data designed to test all 10 queries.

#### 1\. Table Generation Script (DDL)

This script creates the `Customers`, `Products`, and `Orders` tables.

```sql
-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50) NOT NULL,
    JoinDate DATE NOT NULL
);

-- Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL
);

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL, -- Price at time of order
    TotalOrderAmount DECIMAL(10,2) NOT NULL,
    OrderStatus VARCHAR(20) CHECK (OrderStatus IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);
```

#### 2\. Sample Data Insertion (DML)

This script populates the tables with logical data.

```sql
-- Insert Sample Customers
INSERT INTO Customers (Name, JoinDate) VALUES
('Arun Kumar', '2023-01-10'),
('Bhavna Gupta', '2023-01-10'), -- Q9: Same JoinDate
('Chetan Shah', '2023-02-15'),
('Divya Iyer', '2023-03-20'),
('Elina Dsouza', '2023-04-05'),
('Farhan Malik', '2023-05-12'),
('Gita Verma', '2024-01-20'),   -- Q3: First order in 2024
('Harish Reddy', '2024-06-01'); -- Q1: No orders

-- Insert Sample Products
INSERT INTO Products (ProductName, Category, Price, StockQuantity) VALUES
('Laptop', 'Electronics', 1200.00, 10), -- 2nd Highest Price
('Smartphone', 'Electronics', 1000.00, 20),
('Wireless Mouse', 'Electronics', 25.00, 50), -- Q2: Ordered by 6 customers
('Coffee Maker', 'Appliances', 80.00, 30),
('Gaming PC', 'Electronics', 1500.00, 5),  -- Highest Price
('Desk Chair', 'Furniture', 150.00, 15),
('Old Model TV', 'Electronics', 300.00, 0),  -- Q6: Out of stock
('Blender', 'Appliances', 45.00, 0); -- Never ordered, out of stock

-- Insert Sample Orders
-- Assume current date is 2025-11-17
INSERT INTO Orders (CustomerID, ProductID, OrderDate, Quantity, Price, TotalOrderAmount, OrderStatus) VALUES
-- Q2: Wireless Mouse (ProductID 3) ordered by 6 customers
(1, 3, '2024-02-10', 1, 25.00, 25.00, 'Delivered'),
(2, 3, '2024-03-15', 2, 25.00, 50.00, 'Delivered'),
(3, 3, '2024-04-01', 1, 25.00, 25.00, 'Delivered'),
(4, 3, '2024-05-10', 1, 25.00, 25.00, 'Shipped'),
(5, 3, '2024-06-15', 1, 25.00, 25.00, 'Pending'),
(6, 3, '2024-07-01', 1, 25.00, 25.00, 'Delivered'),

-- Q3: Gita (Cust 7) first order in 2024
(7, 4, '2024-02-20', 1, 80.00, 80.00, 'Delivered'),
(7, 2, '2024-05-25', 1, 1000.00, 1000.00, 'Shipped'), -- Q7: Multiple categories

-- Q3: Arun (Cust 1) first order in 2024, but also has 2025 order
(1, 1, '2024-01-15', 1, 1200.00, 1200.00, 'Delivered'), -- Q3: First order
(1, 5, '2025-01-20', 1, 1500.00, 1500.00, 'Delivered'), -- Q5: Latest order
(1, 4, '2024-11-30', 1, 80.00, 80.00, 'Delivered'), -- Q7: Multiple categories

-- Q6: Old Model TV (ProductID 7) ordered but stock is 0
(2, 7, '2024-03-18', 1, 300.00, 300.00, 'Delivered'),

-- Q8: No orders in last 6 months (i.e., after 2025-05-17)
(3, 6, '2025-01-10', 1, 150.00, 150.00, 'Delivered'), -- This order is old

-- Q4: Top revenue products (Laptop, Smartphone, Gaming PC)
(4, 2, '2025-02-01', 2, 1000.00, 2000.00, 'Delivered'),
(5, 5, '2025-02-15', 1, 1500.00, 1500.00, 'Shipped'),
(6, 1, '2025-03-01', 1, 1200.00, 1200.00, 'Delivered');
```

---

### 🚀 Paper 3: SQL Queries and Solutions

Here are the 10 queries from the paper, with their solutions and expected output.

#### **Question 1:** List customers who have never placed any order.

**Expected Output:**
'Harish Reddy' was added as a customer but has no associated orders.

| CustomerID | Name         | JoinDate   |
| :--------- | :----------- | :--------- |
| 8          | Harish Reddy | 2024-06-01 |

**Answer Query (Option 1: `LEFT JOIN`):**

```sql
SELECT
    C.CustomerID,
    C.Name,
    C.JoinDate
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;
```

**Answer Query (Option 2: `NOT EXISTS`):**

```sql
SELECT
    CustomerID,
    Name,
    JoinDate
FROM Customers C
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders O
    WHERE O.CustomerID = C.CustomerID
);
```

---

#### **Question 2:** List products ordered by more than 5 different customers.

**Expected Output:**
'Wireless Mouse' (ProductID 3) was ordered by 6 different customers (Arun, Bhavna, Chetan, Divya, Elina, Farhan).

| ProductName    | DifferentCustomerCount |
| :------------- | :--------------------- |
| Wireless Mouse | 6                      |

**Answer Query:**

```sql
SELECT
    P.ProductName,
    COUNT(DISTINCT O.CustomerID) AS DifferentCustomerCount
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID
GROUP BY P.ProductName
HAVING COUNT(DISTINCT O.CustomerID) > 5;
```

---

#### **Question 3:** List customers whose first order was placed in 2024.

**Expected Output:**

- Arun's first order was '2024-01-15'.
- Bhavna's first order was '2024-03-15'.
- Chetan's first order was '2024-04-01'.
- Divya's first order was '2024-05-10'.
- Elina's first order was '2024-06-15'.
- Farhan's first order was '2024-07-01'.
- Gita's first order was '2024-02-20'.

| CustomerName | FirstOrderDate |
| :----------- | :------------- |
| Arun Kumar   | 2024-01-15     |
| Bhavna Gupta | 2024-03-15     |
| Chetan Shah  | 2024-04-01     |
| Divya Iyer   | 2024-05-10     |
| Elina Dsouza | 2024-06-15     |
| Farhan Malik | 2024-07-01     |
| Gita Verma   | 2024-02-20     |

**Answer Query:**

```sql
SELECT
    C.Name AS CustomerName,
    MIN(O.OrderDate) AS FirstOrderDate
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.Name
HAVING YEAR(MIN(O.OrderDate)) = 2024;
```

---

#### **Question 4:** List top 3 products with the highest total revenue.

**Expected Output:**

| ProductName | TotalRevenue |
| :---------- | :----------- |
| Laptop      | 2400.00      |
| Smartphone  | 3000.00      |
| Gaming PC   | 3000.00      |

_Note: In our data, Smartphone and Gaming PC are tied for revenue. SQL Server's `TOP 3` will pick 3 rows, potentially cutting one of them if others are higher. `TOP 3 WITH TIES` would be safer, but `TOP 3` answers the question as written._

**Answer Query:**

```sql
SELECT TOP 3
    P.ProductName,
    SUM(O.TotalOrderAmount) AS TotalRevenue
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID
GROUP BY P.ProductName
ORDER BY TotalRevenue DESC;
```

---

#### **Question 5:** Find the latest order placed for each customer.

**Expected Output:**
A list of each customer who has ordered, and the date of their most recent order.

| CustomerName | LatestOrderDate |
| :----------- | :-------------- |
| Arun Kumar   | 2025-01-20      |
| Bhavna Gupta | 2024-03-18      |
| Chetan Shah  | 2025-01-10      |
| Divya Iyer   | 2025-02-01      |
| Elina Dsouza | 2025-02-15      |
| Farhan Malik | 2025-03-01      |
| Gita Verma   | 2024-05-25      |

**Answer Query (Option 1: `GROUP BY`):**

```sql
SELECT
    C.Name AS CustomerName,
    MAX(O.OrderDate) AS LatestOrderDate
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.Name;
```

**Answer Query (Option 2: Window Function):**

```sql
WITH RankedOrders AS (
    SELECT
        C.Name AS CustomerName,
        O.OrderDate,
        ROW_NUMBER() OVER(PARTITION BY C.CustomerID ORDER BY O.OrderDate DESC) as rn
    FROM Customers C
    JOIN Orders O ON C.CustomerID = O.CustomerID
)
SELECT
    CustomerName,
    OrderDate AS LatestOrderDate
FROM RankedOrders
WHERE rn = 1;
```

---

#### **Question 6:** List products that have been ordered but are currently out of stock.

**Expected Output:**
'Old Model TV' has an order from Bhavna, but its `StockQuantity` is 0.

| ProductName  | StockQuantity |
| :----------- | :------------ |
| Old Model TV | 0             |

**Answer Query:**

```sql
SELECT DISTINCT
    P.ProductName,
    P.StockQuantity
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID
WHERE P.StockQuantity = 0;
```

---

#### **Question 7:** List customers who placed orders in more than one product category.

**Expected Output:**

- Arun ordered 'Laptop' ('Electronics') and 'Coffee Maker' ('Appliances').
- Gita ordered 'Coffee Maker' ('Appliances') and 'Smartphone' ('Electronics').

| CustomerName | UniqueCategoriesCount |
| :----------- | :-------------------- |
| Arun Kumar   | 2                     |
| Gita Verma   | 2                     |

**Answer Query:**

```sql
SELECT
    C.Name AS CustomerName,
    COUNT(DISTINCT P.Category) AS UniqueCategoriesCount
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Products P ON O.ProductID = P.ProductID
GROUP BY C.Name
HAVING COUNT(DISTINCT P.Category) > 1;
```

---

#### **Question 8:** List products with no orders in the last 6 months.

_Note: Assuming the current date is 2025-11-17, "last 6 months" means no orders after 2025-05-17._

**Expected Output:**
'Blender' has no orders at all. All other products have had orders, but none after 2025-05-17, so they all appear.

| ProductName    |
| :------------- |
| Blender        |
| Coffee Maker   |
| Desk Chair     |
| Gaming PC      |
| Laptop         |
| Old Model TV   |
| Smartphone     |
| Wireless Mouse |

**Answer Query:**

```sql
-- Get the date 6 months ago (e.g., in SQL Server)
DECLARE @6MonthsAgo DATE = DATEADD(month, -6, GETDATE());

SELECT P.ProductName
FROM Products P
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders O
    WHERE O.ProductID = P.ProductID
      AND O.OrderDate >= @6MonthsAgo
);
```

---

#### **Question 9:** Find Customers having Same JoinDate.

**Expected Output:**
Arun and Bhavna both joined on '2023-01-10'.

| JoinDate   | CustomerName |
| :--------- | :----------- |
| 2023-01-10 | Arun Kumar   |
| 2023-01-10 | Bhavna Gupta |

**Answer Query (Option 1: `GROUP BY`):**

```sql
SELECT
    C.JoinDate,
    C.Name AS CustomerName
FROM Customers C
JOIN (
    SELECT JoinDate
    FROM Customers
    GROUP BY JoinDate
    HAVING COUNT(*) > 1
) AS DupeDates ON C.JoinDate = DupeDates.JoinDate;
```

**Answer Query (Option 2: Self-Join):**

```sql
SELECT DISTINCT
    C1.JoinDate,
    C1.Name AS CustomerName
FROM Customers C1
JOIN Customers C2 ON C1.JoinDate = C2.JoinDate AND C1.CustomerID != C2.CustomerID;
```

---

#### **Question 10:** Find the product whose price is second highest.

**Expected Output:**
'Gaming PC' is 1500.00 (1st). 'Laptop' is 1200.00 (2nd).

| ProductName | Price   |
| :---------- | :------ |
| Laptop      | 1200.00 |

**Answer Query (Option 1: Window Function - Recommended):**

```sql
WITH RankedProducts AS (
    SELECT
        ProductName,
        Price,
        DENSE_RANK() OVER(ORDER BY Price DESC) AS PriceRank
    FROM Products
)
SELECT
    ProductName,
    Price
FROM RankedProducts
WHERE PriceRank = 2;
```

**Answer Query (Option 2: Subquery):**

```sql
SELECT
    ProductName,
    Price
FROM Products
WHERE Price = (
    SELECT MAX(Price)
    FROM Products
    WHERE Price < (SELECT MAX(Price) FROM Products)
);
```
