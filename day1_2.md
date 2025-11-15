

-----

# Day 1, Part 2: SQL JOIN Assignment (PERSON & DEPT)

This assignment focuses on joining tables (`PERSON` and `DEPT`) to retrieve combined data. You will also practice `GROUP BY`, `HAVING`, and using `NULL` values.

## SQL Setup Script

Run the following SQL script in your database to create the tables and insert the data for this assignment.

```sql
-- Create the DEPT table first, as PERSON depends on it
CREATE TABLE DEPT (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    DepartmentCode VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(50) NOT NULL
);

-- Create the PERSON table with a Foreign Key
CREATE TABLE PERSON (
    PersonID INT PRIMARY KEY,
    PersonName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(8, 2) NOT NULL,
    JoiningDate DATE NOT NULL,
    City VARCHAR(100) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES DEPT(DepartmentID)
);

-- Insert data into the DEPT table
INSERT INTO DEPT (DepartmentID, DepartmentName, DepartmentCode, Location)
VALUES
(1, 'Admin', 'Adm', 'A-Block'),
(2, 'Computer', 'CE', 'C-Block'),
(3, 'Civil', 'CI', 'G-Block'),
(4, 'Electrical', 'EE', 'E-Block'),
(5, 'Mechanical', 'ME', 'B-Block'),
(6, 'Marketing', 'Mkt', 'F-Block'),
(7, 'Accounts', 'Acc', 'A-Block');

-- Insert data into the PERSON table
INSERT INTO PERSON (PersonID, PersonName, DepartmentID, Salary, JoiningDate, City)
VALUES
(101, 'Rahul Tripathi', 2, 56000.00, '2000-01-01', 'Rajkot'),
(102, 'Hardik Pandya', 3, 18000.00, '2001-09-25', 'Ahmedabad'),
(103, 'Bhavin Kanani', 4, 25000.00, '2000-05-14', 'Baroda'),
(104, 'Bhoomi Vaishnav', 1, 39000.00, '2005-02-08', 'Rajkot'),
(105, 'Rohit Topiya', 2, 17000.00, '2001-07-23', 'Jamnagar'),
(106, 'Priya Menpara', NULL, 9000.00, '2000-10-18', 'Ahmedabad'),
(107, 'Neha Sharma', 2, 34000.00, '2002-12-25', 'Rajkot'),
(108, 'Nayan Goswami', 3, 25000.00, '2001-07-01', 'Rajkot'),
(109, 'Mehul Bhundiya', 4, 13500.00, '2005-01-09', 'Baroda'),
(110, 'Mohit Maru', 5, 14000.00, '2000-05-25', 'Jamnagar'),
(111, 'Alok Nath', 2, 36000.00, '2003-03-15', 'Ahmedabad'),
(112, 'Seema Jain', 3, 28000.00, '2002-06-18', 'Baroda'),
(113, 'Karan Singh', 1, 41000.00, '2004-11-30', 'Rajkot'),
(114, 'Riya Gupta', 5, 16000.00, '2001-02-12', 'Ahmedabad'),
(115, 'Suresh Patel', 7, 32000.00, '2003-08-20', 'Jamnagar'),
(116, 'Meena Kumari', 7, 30000.00, '2004-01-01', 'Rajkot'),
(117, 'Vikram Batra', NULL, 11000.00, '2005-04-05', 'Baroda');
```

-----

## 🗂️ Queries: Part – A

**1. Combine information from Person and Department table using cross join or Cartesian product.**
*Expected Output (Partial):*

```
+-----------------+----------------+
| PersonName      | DepartmentName |
+-----------------+----------------+
| Rahul Tripathi  | Admin          |
| Rahul Tripathi  | Computer       |
| Rahul Tripathi  | Civil          |
| Rahul Tripathi  | Electrical     |
| Rahul Tripathi  | Mechanical     |
| Rahul Tripathi  | Marketing      |
| Rahul Tripathi  | Accounts       |
| Hardik Pandya   | Admin          |
| Hardik Pandya   | Computer       |
... (119 rows total) ...
```

**2. Find all persons with their department name.**
*Expected Output:*

```
+-----------------+----------------+
| PersonName      | DepartmentName |
+-----------------+----------------+
| Rahul Tripathi  | Computer       |
| Hardik Pandya   | Civil          |
| Bhavin Kanani   | Electrical     |
| Bhoomi Vaishnav | Admin          |
| Rohit Topiya    | Computer       |
| Neha Sharma     | Computer       |
| Nayan Goswami   | Civil          |
| Mehul Bhundiya  | Electrical     |
| Mohit Maru      | Mechanical     |
| Alok Nath       | Computer       |
| Seema Jain      | Civil          |
| Karan Singh     | Admin          |
| Riya Gupta      | Mechanical     |
| Suresh Patel    | Accounts       |
| Meena Kumari    | Accounts       |
+-----------------+----------------+
```

**3. Find all persons with their department name & code.**
*Expected Output (Partial):*

```
+-----------------+----------------+----------------+
| PersonName      | DepartmentName | DepartmentCode |
+-----------------+----------------+----------------+
| Bhoomi Vaishnav | Admin          | Adm            |
| Karan Singh     | Admin          | Adm            |
| Rahul Tripathi  | Computer       | CE             |
| Rohit Topiya    | Computer       | CE             |
... (15 rows total) ...
```

**4. Find all persons with their department code and location.**
*Expected Output (Partial):*

```
+-----------------+----------------+----------+
| PersonName      | DepartmentCode | Location |
+-----------------+----------------+----------+
| Bhoomi Vaishnav | Adm            | A-Block  |
| Karan Singh     | Adm            | A-Block  |
| Rahul Tripathi  | CE             | C-Block  |
... (15 rows total) ...
```

**5. Find the detail of the person who belongs to Mechanical department.**
*Expected Output:*

```
+----------+------------+--------------+---------+-------------+----------+
| PersonID | PersonName | DepartmentID | Salary  | JoiningDate | City     |
+----------+------------+--------------+---------+-------------+----------+
| 110      | Mohit Maru | 5            | 14000.00| 2000-05-25  | Jamnagar |
| 114      | Riya Gupta | 5            | 16000.00| 2001-02-12  | Ahmedabad|
+----------+------------+--------------+---------+-------------+----------+
```

**6. Final person’s name, department code and salary who lives in Ahmedabad city.**
*Expected Output:*

```
+---------------+----------------+---------+
| PersonName    | DepartmentCode | Salary  |
+---------------+----------------+---------+
| Hardik Pandya | CI             | 18000.00|
| Alok Nath     | CE             | 36000.00|
| Riya Gupta    | ME             | 16000.00|
+---------------+----------------+---------+
```

**7. Find the person's name whose department is in C-Block.**
*Expected Output:*

```
+----------------+
| PersonName     |
+----------------+
| Rahul Tripathi |
| Rohit Topiya   |
| Neha Sharma    |
| Alok Nath      |
+----------------+
```

**8. Retrieve person name, salary & department name who belongs to Jamnagar city.**
*Expected Output:*

```
+--------------+---------+----------------+
| PersonName   | Salary  | DepartmentName |
+--------------+---------+----------------+
| Rohit Topiya | 17000.00| Computer       |
| Mohit Maru   | 14000.00| Mechanical     |
| Suresh Patel | 32000.00| Accounts       |
+--------------+---------+----------------+
```

**9. Retrieve person’s detail who joined the Civil department after 1-Aug-2001.**
*Expected Output:*

```
+----------+---------------+--------------+---------+-------------+-----------+
| PersonID | PersonName    | DepartmentID | Salary  | JoiningDate | City      |
+----------+---------------+--------------+---------+-------------+-----------+
| 102      | Hardik Pandya | 3            | 18000.00| 2001-09-25  | Ahmedabad |
| 112      | Seema Jain    | 3            | 28000.00| 2002-06-18  | Baroda    |
+----------+---------------+--------------+---------+-------------+-----------+
```

**10. Display all the person's name with the department whose joining date difference with the current date is more than 365 days.**
*Expected Output (Assuming current date is in 2025):*

```
+-----------------+----------------+
| PersonName      | DepartmentName |
+-----------------+----------------+
| Rahul Tripathi  | Computer       |
| Hardik Pandya   | Civil          |
... (all 15 rows) ...
| Meena Kumari    | Accounts       |
+-----------------+----------------+
```

**11. Find department wise person counts.**
*Expected Output:*

```
+----------------+-------------+
| DepartmentName | PersonCount |
+----------------+-------------+
| Admin          |           2 |
| Computer       |           4 |
| Civil          |           3 |
| Electrical     |           2 |
| Mechanical     |           2 |
| Accounts       |           2 |
+----------------+-------------+
```

**12. Give department wise maximum & minimum salary with department name.**
*Expected Output:*

```
+----------------+-----------+-----------+
| DepartmentName | MaxSalary | MinSalary |
+----------------+-----------+-----------+
| Admin          |  41000.00 |  39000.00 |
| Computer       |  56000.00 |  17000.00 |
| Civil          |  28000.00 |  18000.00 |
| Electrical     |  25000.00 |  13500.00 |
| Mechanical     |  16000.00 |  14000.00 |
| Accounts       |  32000.00 |  30000.00 |
+----------------+-----------+-----------+
```

**13. Find city wise total, average, maximum and minimum salary.**
*Expected Output:*

```
+-----------+-------------+------------+-----------+-----------+
| City      | TotalSalary | AvgSalary  | MaxSalary | MinSalary |
+-----------+-------------+------------+-----------+-----------+
| Rajkot    |   190000.00 | 38000.0000 |  56000.00 |  25000.00 |
| Ahmedabad |    80000.00 | 20000.0000 |  36000.00 |   9000.00 |
| Baroda    |    87500.00 | 21875.0000 |  28000.00 |  11000.00 |
| Jamnagar  |    63000.00 | 21000.0000 |  32000.00 |  14000.00 |
+-----------+-------------+------------+-----------+-----------+
```

**14. Find the average salary of a person who belongs to Ahmedabad city.**
*Expected Output:*

```
+---------------------+
| AvgSalary_Ahmedabad |
+---------------------+
|          20000.0000 |
+---------------------+
```

**15. Produce Output Like: `<PersonName> lives in <City> and works in <DepartmentName> Department.` (In single column).**
*Expected Output:*

```
+-----------------------------------------------------------------+
| PersonDetails                                                   |
+-----------------------------------------------------------------+
| Rahul Tripathi lives in Rajkot and works in Computer Department.  |
| Hardik Pandya lives in Ahmedabad and works in Civil Department. |
... (15 rows total) ...
+-----------------------------------------------------------------+
```

-----

## 🗂️ Queries: Part – B

**1. Produce Output Like: `<PersonName> earns <Salary> from <DepartmentName> department monthly.` (In single column).**
*Expected Output:*

```
+-------------------------------------------------------------------+
| SalaryDetails                                                     |
+-------------------------------------------------------------------+
| Rahul Tripathi earns 56000.00 from Computer department monthly.     |
| Hardik Pandya earns 18000.00 from Civil department monthly.       |
... (15 rows total) ...
+-------------------------------------------------------------------+
```

**2. Find city & department wise total, average & maximum salaries.**
*Expected Output:*

```
+-----------+----------------+-------------+------------+-----------+
| City      | DepartmentName | TotalSalary | AvgSalary  | MaxSalary |
+-----------+----------------+-------------+------------+-----------+
| Ahmedabad | Civil          |    18000.00 | 18000.0000 |  18000.00 |
| Ahmedabad | Computer       |    36000.00 | 36000.0000 |  36000.00 |
| Ahmedabad | Mechanical     |    16000.00 | 16000.0000 |  16000.00 |
| Baroda    | Civil          |    28000.00 | 28000.0000 |  28000.00 |
| Baroda    | Electrical     |    38500.00 | 19250.0000 |  25000.00 |
| Jamnagar  | Accounts       |    32000.00 | 32000.0000 |  32000.00 |
| Jamnagar  | Computer       |    17000.00 | 17000.0000 |  17000.00 |
| Jamnagar  | Mechanical     |    14000.00 | 14000.0000 |  14000.00 |
| Rajkot    | Admin          |    80000.00 | 40000.0000 |  41000.00 |
| Rajkot    | Accounts       |    30000.00 | 30000.0000 |  30000.00 |
| Rajkot    | Civil          |    25000.00 | 25000.0000 |  25000.00 |
| Rajkot    | Computer       |    90000.00 | 45000.0000 |  56000.00 |
+-----------+----------------+-------------+------------+-----------+
```

**3. Find all persons who do not belong to any department.**
*Expected Output:*

```
+----------+---------------+--------------+---------+-------------+-----------+
| PersonID | PersonName    | DepartmentID | Salary  | JoiningDate | City      |
+----------+---------------+--------------+---------+-------------+-----------+
| 106      | Priya Menpara | NULL         | 9000.00 | 2000-10-18  | Ahmedabad |
| 117      | Vikram Batra  | NULL         | 11000.00| 2005-04-05  | Baroda    |
+----------+---------------+--------------+---------+-------------+-----------+
```

**4. Find all departments whose total salary is exceeding 100000.**
*Expected Output:*

```
+----------------+-------------+
| DepartmentName | TotalSalary |
+----------------+-------------+
| Computer       |   143000.00 |
+----------------+-------------+
```

-----

## 🗂️ Queries: Part – C

**1. List all departments who have no person.**

*Expected Output:*

```
+----------------+
| DepartmentName |
+----------------+
| Marketing      |
+----------------+
```

**2. List out department names in which more than two persons are working.**
*Expected Output:*

```
+----------------+-------------+
| DepartmentName | PersonCount |
+----------------+-------------+
| Computer       |           4 |
| Civil          |           3 |
+----------------+-------------+
```

**3. Give a 10% increment in the computer department employee’s salary. (Use Update).**
*This is an `UPDATE` query. To verify your work, run a `SELECT` query on the `PERSON` table for the 'Computer' department **before** and **after** your `UPDATE`.*

*Expected Output (Before Update):*

```
+----------------+---------+
| PersonName     | Salary  |
+----------------+---------+
| Rahul Tripathi | 56000.00|
| Rohit Topiya   | 17000.00|
| Neha Sharma    | 34000.00|
| Alok Nath      | 36000.00|
+----------------+---------+
```

*Expected Output (After Update):*

```
+----------------+---------+
| PersonName     | Salary  |
+----------------+---------+
| Rahul Tripathi | 61600.00|
| Rohit Topiya   | 18700.00|
| Neha Sharma    | 37400.00|
| Alok Nath      | 39600.00|
+----------------+---------+
```
---

Here is the student assignment for Lab 13.

-----

# Advanced SQL Joins

This assignment will test your ability to use `LEFT JOIN`, join multiple tables, write queries with `GROUP BY` and `HAVING`, and design a normalized database schema.

## 📚 Part 1: Book & Author Schema

### SQL Setup Script

Run the following script to create and populate the tables for Parts A and B.

```sql
-- Create Author table
CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL,
    Country VARCHAR(50) NULL
);

-- Create Publisher table
CREATE TABLE Publisher (
    PublisherID INT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL UNIQUE,
    City VARCHAR(50) NOT NULL
);

-- Create Book table with Foreign Keys
CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    AuthorID INT NOT NULL,
    PublisherID INT NOT NULL,
    Price DECIMAL(8, 2) NOT NULL,
    PublicationYear INT NOT NULL,
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID)
);

-- Insert into Author
INSERT INTO Author (AuthorID, AuthorName, Country)
VALUES
(1, 'Chetan Bhagat', 'India'),
(2, 'Arundhati Roy', 'India'),
(3, 'Amish Tripathi', 'India'),
(4, 'Ruskin Bond', 'India'),
(5, 'Jhumpa Lahiri', 'India'),
(6, 'Paulo Coelho', 'Brazil'),
(7, 'Sudha Murty', 'India'),
(8, 'Vikram Seth', 'India'),
(9, 'Kiran Desai', 'India'); -- Author with no books

-- Insert into Publisher
INSERT INTO Publisher (PublisherID, PublisherName, City)
VALUES
(1, 'Rupa Publications', 'New Delhi'),
(2, 'Penguin India', 'Gurugram'),
(3, 'HarperCollins India', 'Noida'),
(4, 'Aleph Book Company', 'New Delhi'),
(5, 'Westland', 'Chennai');

-- Insert into Book
INSERT INTO Book (BookID, Title, AuthorID, PublisherID, Price, PublicationYear)
VALUES
(101, 'Five Point Someone', 1, 1, 250.00, 2004),
(102, 'The God of Small Things', 2, 2, 350.00, 1997),
(103, 'Immortals of Meluha', 3, 3, 300.00, 2010),
(104, 'The Blue Umbrella', 4, 1, 180.00, 1980),
(105, 'The Lowland', 5, 2, 400.00, 2013),
(106, 'Revolution 2020', 1, 1, 275.00, 2011),
(107, 'Sita: Warrior of Mithila', 3, 3, 320.00, 2017),
(108, 'The Room on the Roof', 4, 4, 200.00, 1956),
(109, 'A Suitable Boy', 8, 2, 600.00, 1993),
(110, 'Scion of Ikshvaku', 3, 5, 350.00, 2015),
(111, 'Wise and Otherwise', 7, 2, 210.00, 2002),
(112, '2 States', 1, 1, 260.00, 2009);
```

-----

### 📖 Part – A: Book Queries

**1. List all books with their authors.**
*Expected Output (Partial):*

```
+-------------------------+---------------+
| Title                   | AuthorName    |
+-------------------------+---------------+
| Five Point Someone      | Chetan Bhagat |
| The God of Small Things | Arundhati Roy |
... (12 rows total) ...
```

**2. List all books with their publishers.**
*Expected Output (Partial):*

```
+-------------------------+---------------------+
| Title                   | PublisherName       |
+-------------------------+---------------------+
| Five Point Someone      | Rupa Publications   |
| The God of Small Things | Penguin India       |
... (12 rows total) ...
```

**3. List all books with their authors and publishers.**
*Expected Output (Partial):*

```
+-------------------------+---------------+---------------------+
| Title                   | AuthorName    | PublisherName       |
+-------------------------+---------------+---------------------+
| Five Point Someone      | Chetan Bhagat | Rupa Publications   |
| The God of Small Things | Arundhati Roy | Penguin India       |
... (12 rows total) ...
```

**4. List all books published after 2010 with their authors and publisher and price.**
*Expected Output:*

```
+-------------------------+---------------+---------------------+--------+
| Title                   | AuthorName    | PublisherName       | Price  |
+-------------------------+---------------+---------------------+--------+
| The Lowland             | Jhumpa Lahiri | Penguin India       | 400.00 |
| Revolution 2020         | Chetan Bhagat | Rupa Publications   | 275.00 |
| Sita: Warrior of Mithila| Amish Tripathi| HarperCollins India | 320.00 |
| Scion of Ikshvaku       | Amish Tripathi| Westland            | 350.00 |
+-------------------------+---------------+---------------------+--------+
```

**5. List all authors and the number of books they have written.**
*Expected Output:*

```
+---------------+---------------+
| AuthorName    | NumberOfBooks |
+---------------+---------------+
| Chetan Bhagat |             3 |
| Arundhati Roy |             1 |
| Amish Tripathi|             3 |
| Ruskin Bond   |             2 |
| Jhumpa Lahiri |             1 |
| Paulo Coelho  |             0 |
| Sudha Murty   |             1 |
| Vikram Seth   |             1 |
| Kiran Desai   |             0 |
+---------------+---------------+
```

**6. List all publishers and the total price of books they have published.**
*Expected Output:*

```
+---------------------+------------+
| PublisherName       | TotalPrice |
+---------------------+------------+
| Rupa Publications   |     705.00 |
| Penguin India       |    1560.00 |
| HarperCollins India |     620.00 |
| Aleph Book Company  |     200.00 |
| Westland            |     350.00 |
+---------------------+------------+
```

**7. List authors who have not written any books.**
*Expected Output:*

```
+---------------+
| AuthorName    |
+---------------+
| Paulo Coelho  |
| Kiran Desai   |
+---------------+
```

**8. Display total number of Books and Average Price of every Author.**
*Expected Output:*

```
+---------------+---------------+--------------+
| AuthorName    | NumberOfBooks | AveragePrice |
+---------------+---------------+--------------+
| Chetan Bhagat |             3 |   261.666667 |
| Arundhati Roy |             1 |   350.000000 |
| Amish Tripathi|             3 |   323.333333 |
| Ruskin Bond   |             2 |   190.000000 |
| Jhumpa Lahiri |             1 |   400.000000 |
| Paulo Coelho  |             0 |         NULL |
| Sudha Murty   |             1 |   210.000000 |
| Vikram Seth   |             1 |   600.000000 |
| Kiran Desai   |             0 |         NULL |
+---------------+---------------+--------------+
```

**9. lists each publisher along with the total number of books they have published, sorted from highest to lowest.**
*Expected Output:*

```
+---------------------+-----------+
| PublisherName       | BookCount |
+---------------------+-----------+
| Penguin India       |         4 |
| Rupa Publications   |         4 |
| HarperCollins India |         2 |
| Aleph Book Company  |         1 |
| Westland            |         1 |
+---------------------+-----------+
```

**10. Display number of books published each year.**
*Expected Output:*

```
+-----------------+---------------+
| PublicationYear | NumberOfBooks |
+-----------------+---------------+
| 1956            |             1 |
| 1980            |             1 |
| 1993            |             1 |
| 1997            |             1 |
| 2002            |             1 |
| 2004            |             1 |
| 2009            |             1 |
| 2010            |             1 |
| 2011            |             1 |
| 2013            |             1 |
| 2015            |             1 |
| 2017            |             1 |
+-----------------+---------------+
```

-----

### 📖 Part – B: Book Queries

**1. List the publishers whose total book prices exceed 500, ordered by the total price.**
*Expected Output:*

```
+---------------------+------------+
| PublisherName       | TotalPrice |
+---------------------+------------+
| HarperCollins India |     620.00 |
| Rupa Publications   |     705.00 |
| Penguin India       |    1560.00 |
+---------------------+------------+
```

**2. List most expensive book for each author, sort it with the highest price.**
*Expected Output:*

```
+---------------+-------------------------+--------+
| AuthorName    | Title                   | Price  |
+---------------+-------------------------+--------+
| Vikram Seth   | A Suitable Boy          | 600.00 |
| Jhumpa Lahiri | The Lowland             | 400.00 |
| Arundhati Roy | The God of Small Things | 350.00 |
| Amish Tripathi| Scion of Ikshvaku       | 350.00 |
| Chetan Bhagat | Revolution 2020         | 275.00 |
| Sudha Murty   | Wise and Otherwise      | 210.00 |
| Ruskin Bond   | The Room on the Roof    | 200.00 |
+---------------+-------------------------+--------+
```

-----

### 👨‍💼 Part – C: Employee & Location Schema

This final part is a design and query challenge.

**1. Create Table Schema**
Your first task is to create the database structure. Implement the following 6-table schema. You must define all **Primary Key**, **Foreign Key**, and other constraints necessary to make the database functional and maintain data integrity.

  * `Emp_info(Eid, Ename, Did, Cid, Salary, Experience)`
  * `Dept_info(Did, Dname)`
  * `City_info(Cid, Cname, Did)`
  * `District(Did, Dname, Sid)`
  * `State(Sid, Sname, Cid)`
  * `Country(Cid, Cname)`

**2. Insert Data & Test Validation**
Once your tables are created, perform the following:

  * Insert 5 valid records into each of the 6 tables.
  * After inserting valid data, write and execute at least one `INSERT` statement that **violates** a foreign key constraint you set up. Observe and understand the error message produced by the database.

**3. Display Full Employee Report**
Write a single SQL query that joins all necessary tables to produce a report showing the following details for every employee:

  * Employee Name (`Ename`)
  * Department Name (`Dname`)
  * Salary
  * Experience
  * City Name (`Cname`)
  * District Name (`Dname`)
  * State Name (`Sname`)
  * Country Name (`Cname`)

**Expected Output**
Your query should produce a result set that looks like this (data will vary based on your inserts, but the structure should match):

```
+-------------+----------+---------+------------+--------------+--------------+-------------+-------------+
| EmpName     | DeptName | Salary  | Experience | CityName     | DistrictName | StateName   | CountryName |
+-------------+----------+---------+------------+--------------+--------------+-------------+-------------+
| Anil Sharma | IT       | 80000.00|          5 | Rajkot       | Rajkot       | Gujarat     | India       |
| Priya Singh | HR       | 65000.00|          3 | Bandra       | Mumbai       | Maharashtra | India       |
| Rajesh Kumar| Sales    | 70000.00|          4 | Sanand       | Ahmedabad    | Gujarat     | India       |
| Meena Patel | IT       | 82000.00|          6 | Rajkot       | Rajkot       | Gujarat     | India       |
| Suresh Desai| Finance  | 95000.00|          8 | Santa Monica | Los Angeles  | California  | USA         |
+-------------+----------+---------+------------+--------------+--------------+-------------+-------------+
```