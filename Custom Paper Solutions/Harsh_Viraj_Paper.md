# University Database Schema and Queries

## Database Schema

### Tables

#### Departments
```sql
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    Budget DECIMAL(12,2) NOT NULL DEFAULT 0.00
);
```

#### Courses
```sql
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseCode VARCHAR(10) NOT NULL UNIQUE,
    CourseName VARCHAR(150) NOT NULL,
    DepartmentID INT NOT NULL FOREIGN KEY REFERENCES Departments(DepartmentID),
    Credits INT NOT NULL CHECK (Credits > 0),
    LeadProfessor VARCHAR(100) NULL
);
```

#### Students
```sql
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    EnrollmentDate DATE NOT NULL,
    GPA DECIMAL(3,2) NULL CHECK (GPA BETWEEN 0.00 AND 4.00)
);
```

### Sample Data

#### Departments Data
```sql
INSERT INTO Departments (DepartmentName, Budget) VALUES
('Computer Science', 2500000),
('Mechanical Engineering', 1800000),
('Electrical Engineering', 1700000),
('Civil Engineering', 1500000),
('Mathematics', 900000),
('Physics', 850000),
('Biology', 800000),
('Chemistry', 920000),
('English', 500000),
('History', 400000);
```

#### Students Data
```sql
INSERT INTO Students (FirstName, LastName, EnrollmentDate, GPA) VALUES
('Arjun','Sharma','2022-07-01',3.45),
('Sneha','Khan','2021-07-01',3.80),
('Ravi','Patel','2022-07-01',3.20),
('Priya','Singh','2023-07-01',3.60),
('Aman','Verma','2020-07-01',3.10),
('Sana','Ali','2019-07-01',3.90),
('Vikram','Jain','2021-01-15',2.95),
('Divya','Nair','2022-08-10',3.70),
('Karan','Bhatia','2023-01-05',3.00),
('Meera','Shah','2020-09-20',3.55);
```

#### Courses Data
```sql
INSERT INTO Courses (CourseCode, CourseName, DepartmentID, Credits, LeadProfessor) VALUES
('CS101', 'Intro to Programming', 1, 4, 'Rahul Mehta'),
('CS201', 'Data Structures', 1, 4, 'John Matthew'),
('ME101','Thermodynamics', 2, 3, 'Neha Singh'),
('EE101','Circuit Analysis', 3, 3, 'Anita Roy'),
('CE201','Strength of Materials', 4, 4, 'Peter Khan'),
('MA101','Calculus I', 5, 4, 'Laura Gomez'),
('PH101','Physics I', 6, 4, 'Ibrahim Ali'),
('BI101','Biology I', 7, 3, 'Sophie Turner'),
('CH101','Inorganic Chemistry', 8, 3, 'Carlos Mendez'),
('EN101','English Literature', 9, 2, 'Mina Patel');
```

## Questions

1. List all courses from departments that have a budget greater than 1 million.
2. List all departments along with the number of courses they offer.
3. List all departments that offer more than 3 courses.
4. Find the course with the second-highest credit hours in the 'Computer Science' department.
5. List all students whose GPA is above the average GPA of all students.
6. Find the department with the highest number of courses.
7. List students who enrolled on the same enrollment date as at least one other student.
8. Find all courses where the LeadProfessor name contains the word 'Head'.
9. Retrieve courses offered by departments whose budget is above the average department budget.
10. List students who enrolled after the earliest enrollment date in the table.

## Answers

### SQL Solutions — University (3-table schema)

1. **List all courses from departments that have a budget greater than 1 million.**
   ```sql
   SELECT c.CourseName, c.CourseCode, d.DepartmentName, d.Budget
   FROM Courses c
   JOIN Departments d ON c.DepartmentID = d.DepartmentID
   WHERE d.Budget > 1000000;
   ```

2. **List all departments along with the number of courses they offer.**
   ```sql
   SELECT d.DepartmentName, COUNT(c.CourseID) AS CourseCount
   FROM Departments d
   LEFT JOIN Courses c ON d.DepartmentID = c.DepartmentID
   GROUP BY d.DepartmentName;
   ```

3. **List all departments that offer more than 3 courses.**
   ```sql
   SELECT d.DepartmentName, COUNT(c.CourseID) AS TotalCourses
   FROM Departments d
   JOIN Courses c ON d.DepartmentID = c.DepartmentID
   GROUP BY d.DepartmentName
   HAVING COUNT(c.CourseID) > 3;
   ```

4. **Find the course with the second-highest credit hours in the 'Computer Science' department.**
   ```sql
   SELECT TOP 1 c.CourseName, c.Credits
   FROM Courses c
   JOIN Departments d ON c.DepartmentID = d.DepartmentID
   WHERE d.DepartmentName = 'Computer Science' AND c.Credits < (
       SELECT MAX(Credits)
       FROM Courses
       WHERE DepartmentID = d.DepartmentID
   )
   ORDER BY c.Credits DESC;
   ```

5. **List all students whose GPA is above the average GPA of all students.**
   ```sql
   SELECT *
   FROM Students
   WHERE GPA > (SELECT AVG(GPA) FROM Students);
   ```

6. **Find the department with the highest number of courses.**
   ```sql
   SELECT TOP 1 d.DepartmentName, COUNT(c.CourseID) AS CourseCount
   FROM Departments d
   LEFT JOIN Courses c ON d.DepartmentID = c.DepartmentID
   GROUP BY d.DepartmentName
   ORDER BY CourseCount DESC;
   ```

7. **List students who enrolled on the same enrollment date as at least one other student.**
   ```sql
   SELECT s.StudentID, s.FirstName, s.LastName, s.EnrollmentDate
   FROM Students s
   WHERE s.EnrollmentDate IN (
       SELECT EnrollmentDate
       FROM Students
       GROUP BY EnrollmentDate
       HAVING COUNT(*) > 1
   )
   ORDER BY s.EnrollmentDate;
   ```

8. **Find all courses where the LeadProfessor name contains the word 'Head'.**
   ```sql
   SELECT *
   FROM Courses
   WHERE LeadProfessor LIKE '%Head%';
   ```

9. **Retrieve courses offered by departments whose budget is above the average department budget.**
   ```sql
   SELECT c.CourseName, d.DepartmentName, d.Budget
   FROM Courses c
   JOIN Departments d ON c.DepartmentID = d.DepartmentID
   WHERE d.Budget > (SELECT AVG(Budget) FROM Departments);
   ```

10. **List students who enrolled after the earliest enrollment date in the table.**
    ```sql
    SELECT *
    FROM Students
    WHERE EnrollmentDate > (SELECT MIN(EnrollmentDate) FROM Students);
    ```