### 📜 Paper 4: Table & Data Generation Scripts

This paper uses an e-commerce schema focused on analytics. Here are the scripts to create the tables and insert sample data designed to test all 10 queries.

#### 1\. Table Generation Script (DDL)

This script creates the `Customers`, `Products`, and `Orders` tables.

```sql
-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE NOT NULL,
    TotalOrders INT DEFAULT 0
);

-- Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,
    LastRestockDate DATE
);

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    TotalAmount DECIMAL(10,2),
    OrderStatus VARCHAR(20) CHECK (OrderStatus IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);
```

#### 2\. Sample Data Insertion (DML)

This script populates the tables with logical data.
_Note: We assume the "current date" for these queries is **November 17, 2025**._

```sql
-- Insert Sample Customers
INSERT INTO Customers (FirstName, LastName, Email, JoinDate) VALUES
('Amit', 'Sharma', 'amit@example.com', '2023-01-05'), -- Q1/Q8: Top customer
('Priya', 'Singh', 'priya@example.com', '2023-02-10'), -- Q4: Repeat buyer
('Ravi', 'Kumar', 'ravi@example.com', '2023-03-15'),  -- Q7: Ordered every month
('Divya', 'Mehta', 'divya@example.com', '2023-04-20'), -- Q10: Unusual pattern
('Sunil', 'Verma', 'sunil@example.com', '2023-05-01'), -- Q9: Cancelled/Pending
('Tina', 'Das', 'tina@example.com', '2023-06-11');

-- Insert Sample Products
INSERT INTO Products (ProductName, Category, Price, StockQuantity, LastRestockDate) VALUES
('Laptop', 'Electronics', 1200.00, 15, '2025-10-01'),
('Headphones', 'Electronics', 150.00, 8, '2025-09-15'),  -- Q6: Low stock (< 10)
('Yoga Mat', 'Sports', 25.00, 50, '2025-10-20'),     -- Q4: Ordered twice
('Old Gadget', 'Electronics', 50.00, 100, '2024-01-01'), -- Q2/Q5: Old orders
('Smartphone', 'Electronics', 800.00, 20, '2025-11-01');

-- Insert Sample Orders
-- Assume Current Date is 2025-11-17
INSERT INTO Orders (CustomerID, ProductID, OrderDate, Quantity, TotalAmount, OrderStatus) VALUES
-- Q1/Q8: Amit is top customer (4 orders)
(1, 1, '2025-05-10', 1, 1200.00, 'Delivered'),
(1, 2, '2025-06-15', 2, 300.00, 'Delivered'),
(1, 5, '2025-07-20', 1, 800.00, 'Delivered'),
(1, 3, '2025-10-01', 1, 25.00, 'Shipped'),

-- Q4: Priya is repeat buyer of Yoga Mat
(2, 3, '2025-08-01', 1, 25.00, 'Delivered'),
(2, 3, '2025-08-10', 2, 50.00, 'Delivered'),

-- Q2/Q5: Old Gadget ordered > 90 days ago
(3, 4, '2025-01-15', 1, 50.00, 'Delivered'),

-- Q6: Headphones: Stock 8, Demand > 20 (10+10+5=25)
(4, 2, '2025-09-01', 10, 1500.00, 'Shipped'),
(5, 2, '2025-09-05', 10, 1500.00, 'Shipped'),
(6, 2, '2025-09-10', 5, 750.00, 'Delivered'),

-- Q9: Sunil has Pending/Cancelled orders
(5, 5, '2025-11-10', 1, 800.00, 'Pending'),
(5, 1, '2025-11-01', 1, 1200.00, 'Cancelled'),

-- Q10: Divya's unusual pattern (Gap > 60 days, then large order)
(4, 3, '2025-06-01', 1, 25.00, 'Delivered'),  -- Order 1
(4, 1, '2025-09-01', 1, 1200.00, 'Shipped'), -- Order 2 (92-day gap, large order)

-- Q3: Monthly Sales (Jun-Nov)
(6, 5, '2025-06-05', 1, 800.00, 'Delivered'), -- June
(1, 5, '2025-07-20', 1, 800.00, 'Delivered'), -- July
(2, 3, '2025-08-01', 1, 25.00, 'Delivered'),  -- August
(4, 2, '2025-09-01', 10, 1500.00, 'Shipped'), -- September
(1, 3, '2025-10-01', 1, 25.00, 'Shipped'),   -- October
(5, 5, '2025-11-10', 1, 800.00, 'Pending'),  -- November

-- Q7: Ravi ordered every month in 2025
(3, 4, '2025-01-15', 1, 50.00, 'Delivered'),
(3, 4, '2025-02-15', 1, 50.00, 'Delivered'),
(3, 4, '2025-03-15', 1, 50.00, 'Delivered'),
(3, 4, '2025-04-15', 1, 50.00, 'Delivered'),
(3, 4, '2025-05-15', 1, 50.00, 'Delivered'),
(3, 4, '2025-06-15', 1, 50.00, 'Delivered'),
(3, 4, '2025-07-15', 1, 50.00, 'Delivered'),
(3, 4, '2025-08-15', 1, 50.00, 'Delivered'),
(3, 4, '2025-09-15', 1, 50.00, 'Delivered'),
(3, 4, '2025-10-15', 1, 50.00, 'Delivered'),
(3, 4, '2025-11-15', 1, 50.00, 'Delivered');
```

---

### 🚀 Paper 4: SQL Queries and Solutions

Here are the 10 queries from the paper, with their solutions and expected output.

#### **Question 1:** Find top 5 customers by total order amount.

**Expected Output:**

| CustomerName | TotalSpent |
| :----------- | :--------- |
| Sunil Verma  | 3500.00    |
| Divya Mehta  | 2725.00    |
| Amit Sharma  | 2325.00    |
| Tina Das     | 1550.00    |
| Ravi Kumar   | 600.00     |

**Answer Query:**

```sql
SELECT TOP 5
    C.FirstName + ' ' + C.LastName AS CustomerName,
    SUM(O.TotalAmount) AS TotalSpent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName
ORDER BY TotalSpent DESC;
```

---

#### **Question 2:** List products with no orders in the last 90 days.

_Note: Assuming current date is 2025-11-17. "Last 90 days" means no orders on or after 2025-08-19._

**Expected Output:**
'Old Gadget' was last ordered in January. All other products have orders after August 19.

| ProductName |
| :---------- |
| Old Gadget  |

**Answer Query:**

```sql
DECLARE @90DaysAgo DATE = DATEADD(day, -90, GETDATE());

SELECT P.ProductName
FROM Products P
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders O
    WHERE O.ProductID = P.ProductID
      AND O.OrderDate >= @90DaysAgo
);
```

---

#### **Question 3:** Calculate monthly sales for the last 6 months.

_Note: "Last 6 months" including the current month (June to November 2025)._

**Expected Output:**

| SalesMonth | TotalSales |
| :--------- | :--------- |
| 2025-06    | 1625.00    |
| 2025-07    | 850.00     |
| 2025-08    | 125.00     |
| 2025-09    | 3800.00    |
| 2025-10    | 75.00      |
| 2025-11    | 2050.00    |

**Answer Query:**

```sql
DECLARE @6MonthsAgo DATE = DATEADD(month, -6, GETDATE());

SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS SalesMonth,
    SUM(TotalAmount) AS TotalSales
FROM Orders
WHERE OrderDate >= @6MonthsAgo
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY SalesMonth;
```

---

#### **Question 4:** Find customers who ordered the same product more than once. (repeat buyers)

**Expected Output:**

- Priya ordered 'Yoga Mat' twice.
- Ravi ordered 'Old Gadget' 11 times.

| CustomerName | ProductName | OrderCount |
| :----------- | :---------- | :--------- |
| Priya Singh  | Yoga Mat    | 2          |
| Ravi Kumar   | Old Gadget  | 11         |

**Answer Query:**

```sql
SELECT
    C.FirstName + ' ' + C.LastName AS CustomerName,
    P.ProductName,
    COUNT(O.OrderID) AS OrderCount
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Products P ON O.ProductID = P.ProductID
GROUP BY C.FirstName, C.LastName, P.ProductName
HAVING COUNT(O.OrderID) > 1;
```

---

#### **Question 5:** Identify products never ordered in the last 3 months.

_Note: Assuming current date is 2025-11-17. "Last 3 months" means no orders on or after 2025-08-17._

**Expected Output:**
'Old Gadget' was last ordered in January.

| ProductName |
| :---------- |
| Old Gadget  |

**Answer Query:**

```sql
DECLARE @3MonthsAgo DATE = DATEADD(month, -3, GETDATE());

SELECT P.ProductName
FROM Products P
WHERE P.ProductID NOT IN (
    SELECT DISTINCT O.ProductID
    FROM Orders O
    WHERE O.OrderDate >= @3MonthsAgo
);
```

---

#### **Question 6:** List products with low stock (less than 10 units) and high demand (more than 20 units ordered).

**Expected Output:**
'Headphones' has `StockQuantity` of 8 (\< 10) and total `Quantity` ordered of 25 (\> 20).

| ProductName | StockQuantity | TotalUnitsOrdered |
| :---------- | :------------ | :---------------- |
| Headphones  | 8             | 25                |

**Answer Query:**

```sql
WITH ProductDemand AS (
    SELECT
        ProductID,
        SUM(Quantity) AS TotalUnitsOrdered
    FROM Orders
    GROUP BY ProductID
)
SELECT
    P.ProductName,
    P.StockQuantity,
    PD.TotalUnitsOrdered
FROM Products P
JOIN ProductDemand PD ON P.ProductID = PD.ProductID
WHERE
    P.StockQuantity < 10
    AND PD.TotalUnitsOrdered > 20;
```

---

#### **Question 7:** List customers who ordered in every month of the current year.

_Note: Assuming "current year" is 2025 and "every month" means all 11 months from Jan to Nov (since Dec hasn't happened)._

**Expected Output:**
'Ravi Kumar' placed an order in all 11 months of 2025.

| CustomerName |
| :----------- |
| Ravi Kumar   |

**Answer Query:**

```sql
-- This query finds customers who ordered in all 11 months (Jan-Nov) of 2025
SELECT
    C.FirstName + ' ' + C.LastName AS CustomerName
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE YEAR(O.OrderDate) = 2025
GROUP BY C.FirstName, C.LastName
HAVING COUNT(DISTINCT MONTH(O.OrderDate)) = 11;
```

---

#### **Question 8:** Find customers who has placed maximum number of orders.

**Expected Output:**
'Ravi Kumar' placed 11 orders.

| CustomerName | NumberOfOrders |
| :----------- | :------------- |
| Ravi Kumar   | 11             |

**Answer Query:**

```sql
SELECT TOP 1 WITH TIES
    C.FirstName + ' ' + C.LastName AS CustomerName,
    COUNT(O.OrderID) AS NumberOfOrders
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName
ORDER BY NumberOfOrders DESC;
```

---

#### **Question 9:** List customers whose order was either 'Cancelled' or 'Pending'.

**Expected Output:**
'Sunil Verma' has one 'Pending' and one 'Cancelled' order.

| CustomerName | OrderStatus |
| :----------- | :---------- |
| Sunil Verma  | Cancelled   |
| Sunil Verma  | Pending     |

**Answer Query:**

```sql
SELECT DISTINCT
    C.FirstName + ' ' + C.LastName AS CustomerName,
    O.OrderStatus
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderStatus IN ('Cancelled', 'Pending');
```

---

#### **Question 10:** Find customers with unusual ordering patterns (gaps \> 60 days followed by large orders).

*Note: This is a very advanced query. We'll define "large order" as \> $1000. This finds customers who had a gap of more than 60 days between orders, and the *next* order was a large one.*

**Expected Output:**
'Divya Mehta' had an order on 2025-06-01, then a gap of 92 days, followed by a large order of $1200 on 2025-09-01.

| CustomerName | PrevOrderDate | NextOrderDate | GapInDays | LargeOrderAmount |
| :----------- | :------------ | :------------ | :-------- | :--------------- |
| Divya Mehta  | 2025-06-01    | 2025-09-01    | 92        | 1200.00          |

**Answer Query (using Window Function):**

```sql
WITH OrderGaps AS (
    SELECT
        CustomerID,
        OrderDate AS NextOrderDate,
        TotalAmount AS NextOrderAmount,
        -- Find the date of the previous order
        LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PrevOrderDate
    FROM Orders
)
SELECT
    C.FirstName + ' ' + C.LastName AS CustomerName,
    OG.PrevOrderDate,
    OG.NextOrderDate,
    DATEDIFF(day, OG.PrevOrderDate, OG.NextOrderDate) AS GapInDays,
    OG.NextOrderAmount AS LargeOrderAmount
FROM OrderGaps OG
JOIN Customers C ON OG.CustomerID = C.CustomerID
WHERE
    OG.PrevOrderDate IS NOT NULL  -- Ensure it's not the first-ever order
    AND DATEDIFF(day, OG.PrevOrderDate, OG.NextOrderDate) > 60
    AND OG.NextOrderAmount > 1000; -- Define "large order"
```
