# Hospital Management System

## Database Schema

### Tables

#### Doctors
```sql
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Specialization VARCHAR(100),
    Salary DECIMAL(10,2),
    HireDate DATE
);
```

#### Patients
```sql
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE,
    Gender CHAR(1),
    ContactNumber VARCHAR(15)
);
```

#### Departments
```sql
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName VARCHAR(100) UNIQUE,
    Floor INT,
    HeadDoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID)
);
```

#### Appointments
```sql
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    AppointmentDate DATETIME NOT NULL,
    Status VARCHAR(20)
);
```

#### MedicalRecords
```sql
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    Diagnosis VARCHAR(255),
    Treatment VARCHAR(255),
    RecordDate DATE
);
```

## Sample Data

#### Doctors Data
```sql
INSERT INTO Doctors (FirstName, LastName, Email, Specialization, Salary, HireDate) VALUES
('John','Doe','john.doe@hosp.com','Cardiology',150000,'2015-03-10'),
('Emma','Stone','emma.stone@hosp.com','Neurology',165000,'2018-07-12'),
('Raj','Verma','raj.verma@hosp.com','Orthopedics',130000,'2016-11-20'),
('Aisha','Khan','aisha.khan@hosp.com','Pediatrics',125000,'2019-02-14'),
('Michael','Brown','michael.brown@hosp.com','Dermatology',118000,'2017-08-05'),
('Sophia','Patel','sophia.patel@hosp.com','General Medicine',145000,'2016-04-23'),
('David','Wilson','david.wilson@hosp.com','Radiology',160000,'2014-11-30'),
('Riya','Malhotra','riya.malhotra@hosp.com','Oncology',170000,'2020-09-10'),
('Arjun','Saxena','arjun.saxena@hosp.com','Gastroenterology',132000,'2018-05-19'),
('Lisa','Martin','lisa.martin@hosp.com','ENT',110000,'2013-06-28');
```

#### Patients Data
```sql
INSERT INTO Patients (FirstName, LastName, BirthDate, Gender, ContactNumber) VALUES
('Aarav','Sharma','1992-05-10','M','9990011223'),
('Priya','Patel','1987-03-12','F','9887766554'),
('John','Willis','2001-10-15','M','9776655443'),
('Rohit','Gupta','1998-09-22','M','9001122334'),
('Sara','Khan','1995-12-05','F','9112233445'),
('Emily','Clark','1989-04-18','F','9223344556'),
('Kabir','Singh','1993-11-20','M','9334455667'),
('Naina','Verma','2000-02-14','F','9445566778'),
('Victor','Gray','1984-07-29','M','9556677889'),
('Tara','Mehta','1999-01-30','F','9667788990');
```

#### Departments Data
```sql
INSERT INTO Departments (DepartmentName, Floor, HeadDoctorID) VALUES
('Cardiology',2,1),
('Neurology',3,2),
('Orthopedics',4,3),
('Pediatrics',1,4),
('Dermatology',2,5),
('General Medicine',2,6),
('Radiology',3,7),
('Oncology',3,8),
('Gastroenterology',4,9),
('ENT',1,10);
```

#### Appointments Data
```sql
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status) VALUES
(1,1,'2024-05-12 10:00','Completed'),
(2,2,'2024-07-18 12:00','Completed'),
(3,3,'2024-11-01 13:00','Completed'),
(4,5,'2024-03-10 14:30','Completed'),
(5,1,'2025-02-25 11:55','Scheduled'),
(6,7,'2024-04-22 09:45','Cancelled'),
(7,9,'2024-06-05 15:30','Completed'),
(8,8,'2025-02-11 16:00','Scheduled'),
(9,10,'2025-01-10 10:15','Scheduled'),
(10,4,'2025-01-20 10:15','Scheduled');
```

#### Medical Records Data
```sql
INSERT INTO MedicalRecords (PatientID, Diagnosis, Treatment, RecordDate) VALUES
(1,'Hypertension','Medication','2024-02-10'),
(1,'Chest Pain','ECG','2024-04-12'),
(2,'Migraine','Painkillers','2024-06-08'),
(3,'ACL Tear','Physiotherapy','2024-08-15'),
(4,'Allergy','Antihistamines','2024-05-15'),
(5,'Asthma','Inhaler Therapy','2024-07-22'),
(6,'Skin Infection','Topical Antibiotics','2024-03-18'),
(7,'Fracture','Surgery','2024-01-25'),
(8,'Early Stage Cancer','Chemotherapy','2024-09-10'),
(9,'Gastritis','Diet + Medication','2024-10-03');
```

## Questions

1. Patients without appointments in 2025.
2. Top 2 highest earning doctors per department.
3. Departments with 15+ completed appointments in 2024.
4. Second highest salary doctor in Cardiology.
5. Patients who visited 4+ doctors in 2024.
6. Department with highest avg doctor salary.
7. Patients with more than 3 medical records.
8. Doctors who are department heads AND have appointments in 2025.
9. Patients older than avg patient age.
10. Doctors with no appointments in January 2025.

## Answers

### SQL Solutions — Hospital Management System (5-table schema)

1. **Patients without appointments in 2025.**
   ```sql
   SELECT p.*
   FROM Patients p
   WHERE NOT EXISTS (
       SELECT 1 FROM Appointments a
       WHERE a.PatientID = p.PatientID AND YEAR(a.AppointmentDate) = 2025
   );
   ```

2. **Top 2 highest earning doctors per department.**
   ```sql
   SELECT d.DepartmentName, doc.FirstName, doc.LastName, doc.Salary
   FROM Doctors doc
   JOIN Departments d ON doc.Specialization = d.DepartmentName
   WHERE doc.Salary >= (
       SELECT MAX(Salary)
       FROM Doctors d2
       WHERE d2.Specialization = doc.Specialization
   )
   OR doc.Salary >= (
       SELECT MAX(Salary)
       FROM Doctors d3
       WHERE d3.Specialization = doc.Specialization
       AND d3.Salary < (
           SELECT MAX(Salary)
           FROM Doctors d4
           WHERE d4.Specialization = doc.Specialization
       )
   );
   ```

3. **Departments with 15+ completed appointments in 2024.**
   ```sql
   SELECT d.DepartmentName, COUNT(*) AS CompletedCount
   FROM Appointments a
   JOIN Doctors doc ON a.DoctorID = doc.DoctorID
   JOIN Departments d ON doc.Specialization = d.DepartmentName
   WHERE a.Status = 'Completed' AND YEAR(a.AppointmentDate) = 2024
   GROUP BY d.DepartmentName
   HAVING COUNT(*) >= 15;
   ```

4. **Second highest salary doctor in Cardiology.**
   ```sql
   SELECT TOP 1 *
   FROM Doctors
   WHERE Specialization = 'Cardiology'
   AND Salary < (
       SELECT MAX(Salary)
       FROM Doctors
       WHERE Specialization = 'Cardiology'
   )
   ORDER BY Salary DESC;
   ```

5. **Patients who visited 4+ doctors in 2024.**
   ```sql
   SELECT p.PatientID, p.FirstName, p.LastName
   FROM Patients p
   JOIN Appointments a ON p.PatientID = a.PatientID
   WHERE YEAR(a.AppointmentDate) = 2024
   GROUP BY p.PatientID, p.FirstName, p.LastName
   HAVING COUNT(DISTINCT a.DoctorID) >= 4;
   ```

6. **Department with highest avg doctor salary.**
   ```sql
   SELECT TOP 1 d.DepartmentName, AVG(doc.Salary) AS AvgSal
   FROM Doctors doc
   JOIN Departments d ON doc.Specialization = d.DepartmentName
   GROUP BY d.DepartmentName
   ORDER BY AvgSal DESC;
   ```

7. **Patients with more than 3 medical records.**
   ```sql
   SELECT p.PatientID, p.FirstName, p.LastName
   FROM Patients p
   JOIN MedicalRecords mr ON p.PatientID = mr.PatientID
   GROUP BY p.PatientID, p.FirstName, p.LastName
   HAVING COUNT(*) > 3;
   ```

8. **Doctors who are department heads AND have appointments in 2025.**
   ```sql
   SELECT doc.FirstName, doc.LastName
   FROM Doctors doc
   JOIN Departments d ON d.HeadDoctorID = doc.DoctorID
   JOIN Appointments a ON a.DoctorID = doc.DoctorID
   WHERE YEAR(a.AppointmentDate) = 2025
   GROUP BY doc.FirstName, doc.LastName;
   ```

9. **Patients older than avg patient age.**
   ```sql
   SELECT p.*
   FROM Patients p
   WHERE DATEDIFF(YEAR, p.BirthDate, GETDATE()) > (
       SELECT AVG(DATEDIFF(YEAR, BirthDate, GETDATE())) FROM Patients
   );
   ```

10. **Doctors with no appointments in January 2025.**
    ```sql
    SELECT d.*
    FROM Doctors d
    WHERE d.DoctorID NOT IN (
        SELECT DoctorID FROM Appointments
        WHERE MONTH(AppointmentDate) = 1 AND YEAR(AppointmentDate) = 2025
    );
    ```