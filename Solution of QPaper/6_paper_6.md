### 📜 Paper 6: Table & Data Generation Scripts

This paper uses the most comprehensive schema, adding a `Payments` table for financial analysis. Here are the scripts to create the four tables and populate them with sample data designed to test all 10 advanced queries.

#### 1\. Table Generation Script (DDL)

This script creates the `Customers`, `Products`, `Orders`, and `Payments` tables.

```sql
-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    JoinDate DATE NOT NULL
);

-- Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL
);

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,       -- Price at time of order
    Amount DECIMAL(10,2) NOT NULL,     -- Total = Quantity * Price
    ShippedDate DATE NULL,
    OrderStatus VARCHAR(20) CHECK (OrderStatus IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

-- Create Payments Table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    PaymentDate DATE NOT NULL,
    PaymentAmount DECIMAL(10,2) NOT NULL
);
```

#### 2\. Sample Data Insertion (DML)

This script populates the tables with logical data.

```sql
-- Insert Sample Customers
INSERT INTO Customers (CustomerID, Name, JoinDate) VALUES
(1, 'Arun Kumar', '2023-01-10'),
(2, 'Bhavna Gupta', '2023-02-15'),
(3, 'Chetan Shah', '2023-03-20'),
(4, 'Divya Iyer', '2023-04-05'),
(5, 'Esha David', '2023-05-12'); -- Q5: No orders

-- Insert Sample Products
INSERT INTO Products (ProductID, ProductName, Category, Price, StockQuantity) VALUES
(101, 'Laptop', 'Electronics', 1200.00, 10),
(102, 'Wireless Mouse', 'Electronics', 25.00, 50),
(103, 'Keyboard', 'Electronics', 45.00, 30), -- Q4: Basis for price comparison
(104, 'Desk Chair', 'Furniture', 150.00, 20),
(105, 'Coffee Maker', 'Appliances', 80.00, 5),
(106, 'Cookbook', 'Books', 30.00, 100); -- Q7: Category with no orders

-- Insert Sample Orders
INSERT INTO Orders (OrderID, CustomerID, ProductID, OrderDate, Quantity, Price, Amount, ShippedDate, OrderStatus) VALUES
-- Q1: Arun's orders for outstanding amount
(1, 1, 101, '2025-01-15', 1, 1200.00, 1200.00, '2025-01-17', 'Delivered'), -- Fully paid
(2, 1, 102, '2025-02-10', 2, 25.00, 50.00, '2025-02-11', 'Delivered'),   -- Partially paid

-- Q2: Bhavna 2 orders, same product, same day
(3, 2, 101, '2025-03-05', 1, 1200.00, 1200.00, '2025-03-07', 'Delivered'), -- Q3: Delivered, no payment
(4, 2, 101, '2025-03-05', 1, 1200.00, 1200.00, '2025-03-08', 'Shipped'),

-- Q6: Stock < Pending
(5, 3, 105, '2025-04-01', 5, 80.00, 400.00, NULL, 'Pending'), -- Stock 5, Pending 5
(6, 4, 105, '2025-04-02', 2, 80.00, 160.00, NULL, 'Pending'), -- Stock 5, Pending 5+2=7

-- Q8: Re-order within 7 days (Arun, Mouse)
(7, 1, 102, '2025-04-05', 1, 25.00, 25.00, '2025-04-06', 'Delivered'), -- First order
(8, 1, 102, '2025-04-08', 1, 25.00, 25.00, '2025-04-09', 'Delivered'), -- Re-order 3 days later

-- Q10: Date-wise pending
(9, 3, 102, '2025-04-02', 1, 25.00, 25.00, NULL, 'Pending');

-- Insert Sample Payments
INSERT INTO Payments (OrderID, PaymentDate, PaymentAmount) VALUES
(1, '2025-01-18', 1200.00), -- Q1: Fully paid
(2, '2025-02-13', 30.00);    -- Q1: Partially paid (50 - 30 = 20 outstanding)
```

-----

### 🚀 Paper 6: SQL Queries and Solutions

Here are the 10 advanced queries from the paper, with their solutions and expected output.

#### **Question 1:** List Customers with total outstanding amount.

**Expected Output:**

  * Arun: Order 1 (1200) is paid (1200). Order 2 (50) is part-paid (30). Outstanding = 20.
  * Bhavna: Order 3 (1200) is unpaid. Order 4 (1200) is unpaid. Outstanding = 2400.
  * Chetan: Order 5 (400), Order 9 (25) unpaid. Outstanding = 425.
  * Divya: Order 6 (160) unpaid. Outstanding = 160.

| CustomerName | OutstandingAmount |
| :--- | :--- |
| Bhavna Gupta | 2400.00 |
| Chetan Shah | 425.00 |
| Divya Iyer | 160.00 |
| Arun Kumar | 20.00 |

**Answer Query:**

```sql
-- Calculate total paid per order
WITH OrderPayments AS (
    SELECT
        OrderID,
        SUM(PaymentAmount) AS TotalPaid
    FROM Payments
    GROUP BY OrderID
),
-- Calculate total due per customer
CustomerDues AS (
    SELECT
        O.CustomerID,
        SUM(O.Amount) AS TotalBilled
    FROM Orders O
    GROUP BY O.CustomerID
),
-- Calculate total paid per customer
CustomerPayments AS (
    SELECT
        O.CustomerID,
        SUM(ISNULL(OP.TotalPaid, 0)) AS TotalPaid
    FROM Orders O
    LEFT JOIN OrderPayments OP ON O.OrderID = OP.OrderID
    GROUP BY O.CustomerID
)
-- Final calculation
SELECT
    C.Name AS CustomerName,
    (ISNULL(CD.TotalBilled, 0) - ISNULL(CP.TotalPaid, 0)) AS OutstandingAmount
FROM Customers C
LEFT JOIN CustomerDues CD ON C.CustomerID = CD.CustomerID
LEFT JOIN CustomerPayments CP ON C.CustomerID = CP.CustomerID
WHERE (ISNULL(CD.TotalBilled, 0) - ISNULL(CP.TotalPaid, 0)) > 0
ORDER BY OutstandingAmount DESC;
```

-----

#### **Question 2:** List Customers who placed more than 2 orders in a single day of a same product.

**Expected Output:**
Bhavna Gupta placed 2 orders for 'Laptop' on '2025-03-05'. *Note: The question asks for "more than 2" (i.e., \>= 3). Our data has 2. If we change data to 3, she'd appear. If we interpret as "\> 1", she appears. Let's stick to the strict "\> 2" (which means 3 or more).*

*(No output based on sample data and a strict interpretation of "\> 2")*

**Answer Query (for \> 2):**

```sql
SELECT
    C.Name AS CustomerName,
    P.ProductName,
    O.OrderDate,
    COUNT(O.OrderID) AS TotalOrders
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Products P ON O.ProductID = P.ProductID
GROUP BY C.Name, P.ProductName, O.OrderDate
HAVING COUNT(O.OrderID) > 2;
```

*Note: If the question meant "more than 1", you would change `HAVING COUNT(O.OrderID) > 1`.*

-----

#### **Question 3:** List Orders which are delivered but payment not received.

**Expected Output:**
Order 3 (Bhavna, Laptop) is 'Delivered' but has no entry in the `Payments` table.

| CustomerName | ProductName | OrderID | OrderDate | Amount |
| :--- | :--- | :--- | :--- | :--- |
| Bhavna Gupta | Laptop | 3 | 2025-03-05 | 1200.00 |

**Answer Query:**

```sql
SELECT
    C.Name AS CustomerName,
    P.ProductName,
    O.OrderID,
    O.OrderDate,
    O.Amount
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Products P ON O.ProductID = P.ProductID
WHERE O.OrderStatus = 'Delivered'
  AND NOT EXISTS (
    SELECT 1
    FROM Payments PM
    WHERE PM.OrderID = O.OrderID
  );
```

-----

#### **Question 4:** List All Products whose price is more than Product "Keyboard".

**Expected Output:**
'Keyboard' price is 45.00.

| ProductName | Price |
| :--- | :--- |
| Laptop | 1200.00 |
| Desk Chair | 150.00 |
| Coffee Maker | 80.00 |

**Answer Query:**

```sql
SELECT
    ProductName,
    Price
FROM Products
WHERE Price > (
    SELECT Price
    FROM Products
    WHERE ProductName = 'Keyboard'
);
```

-----

#### **Question 5:** List Customers which have not placed a single order.

**Expected Output:**
'Esha David' was added but has no orders.

| CustomerID | CustomerName | JoinDate |
| :--- | :--- | :--- |
| 5 | Esha David | 2023-05-12 |

**Answer Query:**

```sql
SELECT
    C.CustomerID,
    C.Name AS CustomerName,
    C.JoinDate
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;
```

-----

#### **Question 6:** List Products where StockQuantity is less than Pending Order Total Quantity.

**Expected Output:**
'Coffee Maker' has `StockQuantity` of 5. Pending orders are Order 5 (Qty 5) and Order 6 (Qty 2), for a total pending quantity of 7. Since 5 \< 7, it is listed.

| ProductName | StockQuantity | PendingOrderQuantity |
| :--- | :--- | :--- |
| Coffee Maker | 5 | 7 |

**Answer Query:**

```sql
-- Use a CTE to get total pending quantity for each product
WITH PendingQuantities AS (
    SELECT
        ProductID,
        SUM(Quantity) AS TotalPending
    FROM Orders
    WHERE OrderStatus = 'Pending'
    GROUP BY ProductID
)
SELECT
    P.ProductName,
    P.StockQuantity,
    PQ.TotalPending AS PendingOrderQuantity
FROM Products P
JOIN PendingQuantities PQ ON P.ProductID = PQ.ProductID
WHERE P.StockQuantity < PQ.TotalPending;
```

-----

#### **Question 7:** Category Wise Sales Summary (Include all the category even if with zero orders).

**Expected Output:**
Shows all categories, including 'Books' which has 0 orders.

| Category | No. of Customers | No. of Orders | No. of Products | Total Quantity | Total Order Amount |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Appliances | 2 | 2 | 1 | 7 | 560.00 |
| Books | 0 | 0 | 1 | 0 | 0.00 |
| Electronics | 3 | 6 | 3 | 8 | 2725.00 |
| Furniture | 0 | 0 | 1 | 0 | 0.00 |

**Answer Query:**

```sql
SELECT
    P.Category,
    COUNT(DISTINCT O.CustomerID) AS [No. of Customers],
    COUNT(O.OrderID) AS [No. of Orders],
    COUNT(DISTINCT P.ProductID) AS [No. of Products],
    ISNULL(SUM(O.Quantity), 0) AS [Total Quantity],
    ISNULL(SUM(O.Amount), 0) AS [Total Order Amount]
FROM Products P
LEFT JOIN Orders O ON P.ProductID = O.ProductID
GROUP BY P.Category;
```

-----

#### **Question 8:** List Customer with Order detail who has placed order of same product again within 7 days.

**Expected Output:**
Arun ordered a 'Wireless Mouse' (Order 7) on 2025-04-05 and then again (Order 8) on 2025-04-08, which is 3 days later.

| CustomerName | ProductName | PrevOrderDate | CurrentOrderDate | DaysBetween |
| :--- | :--- | :--- | :--- | :--- |
| Arun Kumar | Wireless Mouse | 2025-04-05 | 2025-04-08 | 3 |

**Answer Query (using Window Function):**

```sql
-- Use LAG to find the previous order date for the same customer and product
WITH PreviousOrders AS (
    SELECT
        CustomerID,
        ProductID,
        OrderDate AS CurrentOrderDate,
        LAG(OrderDate) OVER(
            PARTITION BY CustomerID, ProductID
            ORDER BY OrderDate
        ) AS PrevOrderDate
    FROM Orders
)
SELECT
    C.Name AS CustomerName,
    P.ProductName,
    PO.PrevOrderDate,
    PO.CurrentOrderDate,
    DATEDIFF(day, PO.PrevOrderDate, PO.CurrentOrderDate) AS DaysBetween
FROM PreviousOrders PO
JOIN Customers C ON PO.CustomerID = C.CustomerID
JOIN Products P ON PO.ProductID = P.ProductID
WHERE
    PO.PrevOrderDate IS NOT NULL  -- Ensures it's not the first order
    AND DATEDIFF(day, PO.PrevOrderDate, PO.CurrentOrderDate) <= 7;
```

-----

#### **Question 9:** Product Wise Total Orders, Lowest Price, Highest Price & Average Price.

**Expected Output:**
A summary of orders and the prices at which they were sold.

| Category | Product | TotalOrders | LowestPrice | HighestPrice | AveragePrice |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Appliances | Coffee Maker | 2 | 80.00 | 80.00 | 80.00 |
| Electronics | Laptop | 3 | 1200.00 | 1200.00 | 1200.00 |
| Electronics | Wireless Mouse | 4 | 25.00 | 25.00 | 25.00 |

**Answer Query:**

```sql
SELECT
    P.Category,
    P.ProductName AS Product,
    COUNT(O.OrderID) AS TotalOrders,
    MIN(O.Price) AS LowestPrice,
    MAX(O.Price) AS HighestPrice,
    AVG(O.Price) AS AveragePrice
FROM Orders O
JOIN Products P ON O.ProductID = P.ProductID
GROUP BY P.Category, P.ProductName
ORDER BY P.Category, Product;
```

-----

#### **Question 10:** List Date Wise Pending Order and Pending Ordered Quantity Product Wise between fromDate and toDate.

*Note: We will run this for the date range '2025-04-01' to '2025-04-03'.*

**Expected Output:**

| Date | Product | TotalPendingOrders | TotalPendingQuantity |
| :--- | :--- | :--- | :--- |
| 2025-04-01 | Coffee Maker | 1 | 5 |
| 2025-04-02 | Coffee Maker | 1 | 2 |
| 2025-04-02 | Wireless Mouse | 1 | 1 |

**Answer Query:**

```sql
-- Declare date range variables
DECLARE @fromDate DATE = '2025-04-01';
DECLARE @toDate DATE = '2025-04-03';

SELECT
    O.OrderDate AS Date,
    P.ProductName AS Product,
    COUNT(O.OrderID) AS TotalPendingOrders,
    SUM(O.Quantity) AS TotalPendingQuantity
FROM Orders O
JOIN Products P ON O.ProductID = P.ProductID
WHERE
    O.OrderStatus = 'Pending'
    AND O.OrderDate BETWEEN @fromDate AND @toDate
GROUP BY O.OrderDate, P.ProductName
ORDER BY Date, Product;
```