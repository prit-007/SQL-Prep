-----

# Day 1: SQL Assignment (EMP & SALES\_DATA)

This assignment will help you practice writing SQL queries, including aggregations (`GROUP BY`) and filtering (`WHERE`, `HAVING`).

## 📈 SQL Setup Script

Run the following SQL script in your database to create the `EMP` and `SALES_DATA` tables and populate them with the data you'll need for the exercises.

```sql
-- Create the EMP table
CREATE TABLE EMP (
    EID INT PRIMARY KEY,
    EName VARCHAR(50),
    Department VARCHAR(50),
    Salary INT,
    JoiningDate DATE,
    City VARCHAR(50),
    Gender VARCHAR(10)
);

-- Insert data into the EMP table
INSERT INTO EMP (EID, EName, Department, Salary, JoiningDate, City, Gender)
VALUES
(101, 'Rahul', 'Admin', 56000, '1990-01-01', 'Rajkot', 'Male'),
(102, 'Hardik', 'IT', 18000, '1990-09-25', 'Ahmedabad', 'Male'),
(103, 'Bhavin', 'HR', 25000, '1991-05-14', 'Baroda', 'Male'),
(104, 'Bhoomi', 'Admin', 39000, '1991-02-08', 'Rajkot', 'Female'),
(105, 'Rohit', 'IT', 17000, '1990-07-23', 'Jamnagar', 'Male'),
(106, 'Priya', 'IT', 9000, '1990-10-18', 'Ahmedabad', 'Female'),
(107, 'Bhoomi', 'HR', 34000, '1991-12-25', 'Rajkot', 'Female'),
(108, 'Manish', 'IT', 22000, '1990-04-20', 'Baroda', 'Male'),
(109, 'Kavita', 'Admin', 35000, '1992-03-12', 'Ahmedabad', 'Female'),
(110, 'Suresh', 'HR', 28000, '1991-11-05', 'Jamnagar', 'Male'),
(111, 'Pooja', 'IT', 19000, '1991-01-30', 'Rajkot', 'Female'),
(112, 'Amit', 'Admin', 42000, '1990-08-19', 'Baroda', 'Male'),
(113, 'Rekha', 'HR', 31000, '1992-07-02', 'Ahmedabad', 'Female'),
(114, 'Vijay', 'IT', 20000, '1990-06-11', 'Rajkot', 'Male'),
(115, 'Meera', 'Admin', 38000, '1991-10-09', 'Jamnagar', 'Female');

-- Create the SALES_DATA table
CREATE TABLE SALES_DATA (
    Region VARCHAR(50),
    Product VARCHAR(50),
    Sales_Amount INT,
    Year INT
);

-- Insert data into the SALES_DATA table
INSERT INTO SALES_DATA (Region, Product, Sales_Amount, Year)
VALUES
('North America', 'Watch', 1500, 2023),
('Europe', 'Mobile', 1200, 2023),
('Asia', 'Watch', 1800, 2023),
('North America', 'TV', 900, 2024),
('Europe', 'Watch', 2000, 2024),
('Asia', 'Mobile', 1000, 2024),
('North America', 'Mobile', 1600, 2023),
('Europe', 'TV', 1500, 2023),
('Asia', 'TV', 1100, 2024),
('North America', 'Watch', 1700, 2024),
('Asia', 'Watch', 2200, 2024),
('Europe', 'Mobile', 1400, 2024),
('North America', 'TV', 1300, 2023),
('Asia', 'TV', 1000, 2023),
('Europe', 'Watch', 1800, 2023),
('North America', 'Mobile', 1100, 2024),
('Asia', 'Laptop', 3000, 2023),
('Europe', 'Laptop', 3500, 2024),
('North America', 'Laptop', 2800, 2024),
('Asia', 'Mobile', 1300, 2023);
```
-----

## 👨‍💼 Queries on `EMP` Table

Write the SQL queries for the following requests. Check your results against the `Expected Output`.

### Part – A

**1. Display the Highest, Lowest, Label the columns Maximum, Minimum respectively.**
*Expected Output:*

```
+---------+---------+
| Maximum | Minimum |
+---------+---------+
|   56000 |    9000 |
+---------+---------+
```

**2. Display Total, and Average salary of all employees. Label the columns Total\_Sal and Average\_Sal, respectively.**
*Expected Output:*

```
+-----------+-------------+
| Total_Sal | Average_Sal |
+-----------+-------------+
|    413000 |  27533.3333 |
+-----------+-------------+
```

**3. Find total number of employees of EMPLOYEE table.**
*Expected Output:*

```
+-----------------+
| Total_Employees |
+-----------------+
|              15 |
+-----------------+
```

**4. Find highest salary from Rajkot city.**
*Expected Output:*

```
+-------------------+
| Max_Salary_Rajkot |
+-------------------+
|             56000 |
+-------------------+
```

**5. Give maximum salary from IT department.**
*Expected Output:*

```
+---------------+
| Max_Salary_IT |
+---------------+
|         22000 |
+---------------+
```

**6. Count employee whose joining date is after 8-Feb-91.**
*Expected Output:*

```
+----------------+
| Employee_Count |
+----------------+
|              7 |
+----------------+
```

**7. Display average salary of Admin department.**
*Expected Output:*

```
+------------------+
| Avg_Salary_Admin |
+------------------+
|       42000.0000 |
+------------------+
```

**8. Display total salary of HR department.**
*Expected Output:*

```
+-----------------+
| Total_Salary_HR |
+-----------------+
|          118000 |
+-----------------+
```

**9. Count total number of cities of employee without duplication.**
*Expected Output:*

```
+---------------+
| Unique_Cities |
+---------------+
|             4 |
+---------------+
```

**10. Count unique departments.**
*Expected Output:*

```
+--------------------+
| Unique_Departments |
+--------------------+
|                  3 |
+--------------------+
```

**11. Give minimum salary of employee who belongs to Ahmedabad.**
*Expected Output:*

```
+----------------------+
| Min_Salary_Ahmedabad |
+----------------------+
|                 9000 |
+----------------------+
```

**12. Find city wise highest salary.**
*Expected Output:*

```
+-----------+------------+
| City      | Max_Salary |
+-----------+------------+
| Rajkot    |      56000 |
| Ahmedabad |      35000 |
| Baroda    |      42000 |
| Jamnagar  |      38000 |
+-----------+------------+
```

**13. Find department wise lowest salary.**
*Expected Output:*

```
+------------+------------+
| Department | Min_Salary |
+------------+------------+
| Admin      |      35000 |
| IT         |       9000 |
| HR         |      25000 |
+------------+------------+
```

**14. Display city with the total number of employees belonging to each city.**
*Expected Output:*

```
+-----------+----------------+
| City      | Employee_Count |
+-----------+----------------+
| Rajkot    |              5 |
| Ahmedabad |              4 |
| Baroda    |              3 |
| Jamnagar  |              3 |
+-----------+----------------+
```

**15. Give total salary of each department of EMP table.**
*Expected Output:*

```
+------------+--------------+
| Department | Total_Salary |
+------------+--------------+
| Admin      |       210000 |
| IT         |        85000 |
| HR         |       118000 |
+------------+--------------+
```

**16. Give average salary of each department of EMP table without displaying the respective department name.**
*Expected Output:*

```
+----------------+
| Average_Salary |
+----------------+
|     42000.0000 |
|     17000.0000 |
|     29500.0000 |
+----------------+
```

**17. Count the number of employees for each department in every city.**
*Expected Output:*

```
+------------+-----------+----------------+
| Department | City      | Employee_Count |
+------------+-----------+----------------+
| Admin      | Rajkot    |              2 |
| IT         | Ahmedabad |              2 |
| HR         | Baroda    |              1 |
| Admin      | Rajkot    |              1 |
| IT         | Jamnagar  |              1 |
| HR         | Rajkot    |              1 |
| IT         | Baroda    |              1 |
| Admin      | Ahmedabad |              1 |
| HR         | Jamnagar  |              1 |
| IT         | Rajkot    |              2 |
| Admin      | Baroda    |              1 |
| HR         | Ahmedabad |              1 |
| Admin      | Jamnagar  |              1 |
+------------+-----------+----------------+
```

**18. Calculate the total salary distributed to male and female employees.**
*Expected Output:*

```
+--------+--------------+
| Gender | Total_Salary |
+--------+--------------+
| Male   |       207000 |
| Female |       206000 |
+--------+--------------+
```

**19. Give city wise maximum and minimum salary of female employees.**
*Expected Output:*

```
+-----------+------------+------------+
| City      | Max_Salary | Min_Salary |
+-----------+------------+------------+
| Rajkot    |      39000 |      19000 |
| Ahmedabad |      35000 |       9000 |
| Jamnagar  |      38000 |      38000 |
+-----------+------------+------------+
```

**20. Calculate department, city, and gender wise average salary.**
*Expected Output:*

```
+------------+-----------+--------+----------------+
| Department | City      | Gender | Average_Salary |
+------------+-----------+--------+----------------+
| Admin      | Rajkot    | Male   |     56000.0000 |
| IT         | Ahmedabad | Male   |     18000.0000 |
| HR         | Baroda    | Male   |     25000.0000 |
| Admin      | Rajkot    | Female |     39000.0000 |
| IT         | Jamnagar  | Male   |     17000.0000 |
| IT         | Ahmedabad | Female |      9000.0000 |
| HR         | Rajkot    | Female |     34000.0000 |
| IT         | Baroda    | Male   |     22000.0000 |
| Admin      | Ahmedabad | Female |     35000.0000 |
| HR         | Jamnagar  | Male   |     28000.0000 |
| IT         | Rajkot    | Female |     19000.0000 |
| Admin      | Baroda    | Male   |     42000.0000 |
| HR         | Ahmedabad | Female |     31000.0000 |
| IT         | Rajkot    | Male   |     20000.0000 |
| Admin      | Jamnagar  | Female |     38000.0000 |
+------------+-----------+--------+----------------+
```

### Part – B

**1. Count the number of employees living in Rajkot.**
*Expected Output:*

```
+------------------+
| Rajkot_Employees |
+------------------+
|                5 |
+------------------+
```

**2. Display the difference between the highest and lowest salaries. Label the column DIFFERENCE.**
*Expected Output:*

```
+------------+
| DIFFERENCE |
+------------+
|      47000 |
+------------+
```

**3. Display the total number of employees hired before 1st January, 1991.**
*Expected Output:*

```
+-------------------+
| Hired_Before_1991 |
+-------------------+
|                 8 |
+-------------------+
```

### Part – C

**1. Count the number of employees living in Rajkot or Baroda.**
*Expected Output:*

```
+----------------+
| Employee_Count |
+----------------+
|              8 |
+----------------+
```

**2. Display the total number of employees hired before 1st January, 1991 in IT department.**
*Expected Output:*

```
+----------------+
| Employee_Count |
+----------------+
|              4 |
+----------------+
```

**3. Find the Joining Date wise Total Salaries.**
*Expected Output:* (Will show 15 distinct rows since no two employees share a joining date in this data)

```
+-------------+--------------+
| JoiningDate | Total_Salary |
+-------------+--------------+
| 1990-01-01  |        56000 |
| 1990-09-25  |        18000 |
| 1991-05-14  |        25000 |
| 1991-02-08  |        39000 |
| 1990-07-23  |        17000 |
| 1990-10-18  |         9000 |
| 1991-12-25  |        34000 |
| 1990-04-20  |        22000 |
| 1992-03-12  |        35000 |
| 1991-11-05  |        28000 |
| 1991-01-30  |        19000 |
| 1990-08-19  |        42000 |
| 1992-07-02  |        31000 |
| 1990-06-11  |        20000 |
| 1991-10-09  |        38000 |
+-------------+--------------+
```

**4. Find the Maximum salary department & city wise in which city name starts with ‘R’.**
*Expected Output:*

```
+------------+--------+------------+
| Department | City   | Max_Salary |
+------------+--------+------------+
| Admin      | Rajkot |      56000 |
| HR         | Rajkot |      34000 |
| IT         | Rajkot |      20000 |
+------------+--------+------------+
```
-----

## 🛒 Queries on `SALES_DATA` Table

Write the SQL queries for the following requests. Check your results against the `Expected Output`.

### Part – A

**1. Display Total Sales Amount by Region.**
*Expected Output:*

```
+---------------+-------------+
| Region        | Total_Sales |
+---------------+-------------+
| North America |       10900 |
| Europe        |       11400 |
| Asia          |       11400 |
+---------------+-------------+
```

**2. Display Average Sales Amount by Product.**
*Expected Output:*

```
+---------+---------------+
| Product | Average_Sales |
+---------+---------------+
| Watch   |     1833.3333 |
| Mobile  |     1266.6667 |
| TV      |     1160.0000 |
| Laptop  |     3100.0000 |
+---------+---------------+
```

**3. Display Maximum Sales Amount by Year.**
*Expected Output:*

```
+------+-----------+
| Year | Max_Sales |
+------+-----------+
| 2023 |      3000 |
| 2024 |      3500 |
+------+-----------+
```

**4. Display Minimum Sales Amount by Region and Year.**
*Expected Output:*

```
+---------------+------+-----------+
| Region        | Year | Min_Sales |
+---------------+------+-----------+
| North America | 2023 |      1300 |
| Europe        | 2023 |      1200 |
| Asia          | 2023 |      1000 |
| North America | 2024 |       900 |
| Europe        | 2024 |      1400 |
| Asia          | 2024 |      1000 |
+---------------+------+-----------+
```

**5. Count of Products Sold by Region.**
*Expected Output:*

```
+---------------+---------------+
| Region        | Product_Count |
+---------------+---------------+
| North America |             7 |
| Europe        |             6 |
| Asia          |             7 |
+---------------+---------------+
```

**6. Display Sales Amount by Year and Product.**
*Expected Output:*

```
+------+---------+-------------+
| Year | Product | Total_Sales |
+------+---------+-------------+
| 2023 | Watch   |        5100 |
| 2023 | Mobile  |        4100 |
| 2023 | TV      |        3800 |
| 2024 | TV      |        2000 |
| 2024 | Watch   |        5900 |
| 2024 | Mobile  |        3500 |
| 2023 | Laptop  |        3000 |
| 2024 | Laptop  |        6300 |
+------+---------+-------------+
```

**7. Display Regions with Total Sales Greater Than 5000.**
*Expected Output:*

```
+---------------+-------------+
| Region        | Total_Sales |
+---------------+-------------+
| North America |       10900 |
| Europe        |       11400 |
| Asia          |       11400 |
+---------------+-------------+
```

**8. Display Products with Average Sales Less Than 10000.**
*Expected Output:*

```
+---------+---------------+
| Product | Average_Sales |
+---------+---------------+
| Watch   |     1833.3333 |
| Mobile  |     1266.6667 |
| TV      |     1160.0000 |
| Laptop  |     3100.0000 |
+---------+---------------+
```

**9. Display Years with Maximum Sales Exceeding 500.**
*Expected Output:*

```
+------+-----------+
| Year | Max_Sales |
+------+-----------+
| 2023 |      3000 |
| 2024 |      3500 |
+------+-----------+
```

**10. Display Regions with at Least 3 Distinct Products Sold.**
*Expected Output:*

```
+---------------+-------------------+
| Region        | Distinct_Products |
+---------------+-------------------+
| North America |                 4 |
| Europe        |                 4 |
| Asia          |                 4 |
+---------------+-------------------+
```

**11. Display Years with Minimum Sales Less Than 1000.**
*Expected Output:*

```
+------+-----------+
| Year | Min_Sales |
+------+-----------+
| 2024 |       900 |
+------+-----------+
```

**12. Display Total Sales Amount by Region for Year 2023, Sorted by Total Amount.**
*Expected Output:*

```
+---------------+------------------+
| Region        | Total_Sales_2023 |
+---------------+------------------+
| Asia          |             7100 |
| Europe        |             4500 |
| North America |             4400 |
+---------------+------------------+
```

**13. Find the Region Where 'Mobile' Had the Lowest Total Sales Across All Years.**
*Expected Output:*

```
+--------+--------------------+
| Region | Total_Mobile_Sales |
+--------+--------------------+
| Asia   |               2300 |
+--------+--------------------+
```

**14. Find the Product with the Highest Sales Across All Regions in 2023.**
*Expected Output:*

```
+---------+------------------+
| Product | Total_Sales_2023 |
+---------+------------------+
| Watch   |             5100 |
+---------+------------------+
```

**15. Find Regions Where 'TV' Sales in 2023 Were Greater Than 1000.**
*Expected Output:*

```
+---------------+---------------+
| Region        | TV_Sales_2023 |
+---------------+---------------+
| North America |          1300 |
| Europe        |          1500 |
+---------------+---------------+
```

### Part – B

**1. Display Count of Orders by Year and Region, Sorted by Year and Region.**
*Expected Output:*

```
+------+---------------+-------------+
| Year | Region        | Order_Count |
+------+---------------+-------------+
| 2023 | Asia          |           5 |
| 2023 | Europe        |           3 |
| 2023 | North America |           3 |
| 2024 | Asia          |           3 |
| 2024 | Europe        |           3 |
| 2024 | North America |           4 |
+------+---------------+-------------+
```

**2. Display Regions with Maximum Sales Amount Exceeding 1000 in Any Year, Sorted by Region.**
*Expected Output:*

```
+---------------+----------+
| Region        | Max_Sale |
+---------------+----------+
| Asia          |     3000 |
| Europe        |     3500 |
| North America |     2800 |
+---------------+----------+
```

**3. Display Years with Total Sales Amount Less Than 10000, Sorted by Year Descending.**
*Expected Output:*

```
(Empty Set)
```

**4. Display Top 3 Regions by Total Sales Amount in Year 2024.**
*Expected Output:*

```
+---------------+------------------+
| Region        | Total_Sales_2024 |
+---------------+------------------+
| Europe        |             6900 |
| North America |             6500 |
| Asia          |             4300 |
+---------------+------------------+
```

**5. Find the Year with the Lowest Total Sales Across All Regions.**
*Expected Output:*

```
+------+-------------+
| Year | Total_Sales |
+------+-------------+
| 2023 |       16000 |
+------+-------------+
```

### Part – C

**1. Display Products with Average Sales Amount Between 1000 and 2000, Ordered by Product Name.**
*Expected Output:*

```
+---------+---------------+
| Product | Average_Sales |
+---------+---------------+
| Mobile  |     1266.6667 |
| TV      |     1160.0000 |
| Watch   |     1833.3333 |
+---------+---------------+
```

**2. Display Years with More Than 1 Orders from Each Region.**
*Expected Output:*

```
+------+
| Year |
+------+
| 2023 |
| 2024 |
+------+
```

**3. Display Regions with Average Sales Amount Above 1500 in Year 2023 sort by amount in descending.**
*Expected Output:*

```
(Empty Set)
```

**4. Find out region wise duplicate product.**
*Expected Output:*

```
+---------------+---------+-------------+
| Region        | Product | Occurrences |
+---------------+---------+-------------+
| North America | Watch   |           2 |
| Europe        | Watch   |           2 |
| Asia          | Watch   |           2 |
| North America | TV      |           2 |
| Asia          | Mobile  |           2 |
| Asia          | TV      |           2 |
| North America | Mobile  |           2 |
+---------------+---------+-------------+
```

**5. Find out year wise duplicate product.**
*Expected Output:*

```
+------+---------+-------------+
| Year | Product | Occurrences |
+------+---------+-------------+
| 2023 | Watch   |           3 |
| 2024 | Watch   |           2 |
| 2023 | Mobile  |           2 |
| 2023 | TV      |           3 |
+------+---------+-------------+
```

