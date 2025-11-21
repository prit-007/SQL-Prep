### 🎬 Paper : The Film Buff's Database

#### 1\. Table Generation Script (DDL)

Here is the script to create the four tables for this schema.

```sql
-- Table 1: Directors
CREATE TABLE Directors (
    DirectorID INT PRIMARY KEY,
    DirectorName VARCHAR(100) NOT NULL,
    Nationality VARCHAR(50)
);
F
-- Table 2: Actors
CREATE TABLE Actors (
    ActorID INT PRIMARY KEY,
    ActorName VARCHAR(100) NOT NULL,
    Birthdate DATE
);

-- Table 3: Movies
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(150) NOT NULL,
    ReleaseYear INT NOT NULL,
    Genre VARCHAR(50) NOT NULL,
    DirectorID INT FOREIGN KEY REFERENCES Directors(DirectorID),
    BoxOffice DECIMAL(12, 2) -- Revenue in millions
);

-- Table 4: Castings
-- This junction table links actors to movies
CREATE TABLE Castings (
    CastingID INT PRIMARY KEY IDENTITY(1,1),
    MovieID INT FOREIGN KEY REFERENCES Movies(MovieID),
    ActorID INT FOREIGN KEY REFERENCES Actors(ActorID),
    Role VARCHAR(100) NOT NULL
);
```

#### 2\. Sample Data Insertion (DML)

This script provides logical data to test all 14 queries.

```sql
-- Insert Directors
INSERT INTO Directors (DirectorID, DirectorName, Nationality) VALUES
(1, 'Christopher Nolan', 'British'),
(2, 'Quentin Tarantino', 'American'),
(3, 'Greta Gerwig', 'American'),
(4, 'Denis Villeneuve', 'Canadian'),
(5, 'Martin Scorsese', 'American');

-- Insert Actors
INSERT INTO Actors (ActorID, ActorName, Birthdate) VALUES
(101, 'Leonardo DiCaprio', '1974-11-11'),
(102, 'Cillian Murphy', '1976-05-25'),
(103, 'Margot Robbie', '1990-07-02'),
(104, 'Ryan Gosling', '1980-11-12'),
(105, 'Samuel L. Jackson', '1948-12-21'),
(106, 'Timothée Chalamet', '1995-12-27'),
(107, 'Zendaya', '1996-09-01'),
(108, 'Robert De Niro', '1943-08-17'),
(109, 'Uma Thurman', '1970-04-29'),
(110, 'Scarlett Johansson', '1984-11-22'); -- Actor with no roles

-- Insert Movies
INSERT INTO Movies (MovieID, Title, ReleaseYear, Genre, DirectorID, BoxOffice) VALUES
(1, 'Inception', 2010, 'Sci-Fi', 1, 836.8),
(2, 'Oppenheimer', 2023, 'Biography', 1, 952.6),
(3, 'Pulp Fiction', 1994, 'Crime', 2, 213.9),
(4, 'Barbie', 2023, 'Comedy', 3, 1445.6), -- Highest box office
(5, 'Dune', 2021, 'Sci-Fi', 4, 402.0),
(6, 'Dune: Part Two', 2024, 'Sci-Fi', 4, 711.8),
(7, 'Killers of the Flower Moon', 2023, 'Crime', 5, 156.9),
(8, 'The Wolf of Wall Street', 2013, 'Biography', 5, 392.0), -- 2nd highest 'Biography'
(9, 'Once Upon a Time in Hollywood', 2019, 'Comedy', 2, 374.6),
(10, 'The Departed', 2006, 'Crime', 5, 291.5),
(11, 'Animated Short', 2025, 'Animation', 5, 0.0); -- Movie with no actors

-- Insert Castings
-- Inception (Nolan)
INSERT INTO Castings (MovieID, ActorID, Role) VALUES
(1, 101, 'Dom Cobb'),
(1, 102, 'Robert Fischer'); -- DiCaprio & Murphy
-- Oppenheimer (Nolan)
INSERT INTO Castings (MovieID, ActorID, Role) VALUES
(2, 102, 'J. Robert Oppenheimer');
-- Pulp Fiction (Tarantino)
INSERT INTO Castings (MovieID, ActorID, Role) VALUES
(3, 105, 'Jules Winnfield'),
(3, 109, 'Mia Wallace');
-- Barbie (Gerwig)
INSERT INTO Castings (MovieID, ActorID, Role) VALUES
(4, 103, 'Barbie'),
(4, 104, 'Ken');
-- Dune 1 & 2 (Villeneuve)
INSERT INTO Castings (MovieID, ActorID, Role) VALUES
(5, 106, 'Paul Atreides'),
(5, 107, 'Chani'),
(6, 106, 'Paul Atreides'),
(6, 107, 'Chani');
-- Scorsese Films
INSERT INTO Castings (MovieID, ActorID, Role) VALUES
(7, 101, 'Ernest Burkhart'), -- DiCaprio & De Niro
(7, 108, 'William Hale'),
(8, 101, 'Jordan Belfort'), -- DiCaprio
(9, 101, 'Rick Dalton'), -- DiCaprio
(10, 101, 'Billy Costigan'), -- DiCaprio & De Niro
(10, 108, 'Quee nan');
```

---

### 🚀 SQL Queries (Paper 8)

#### **Section 1: Easy-Medium Queries**

**1. List all movies released in 2023 with their director's name.**

- **Expected Output:**
  | Title | DirectorName |
  | :--- | :--- |
  | Oppenheimer | Christopher Nolan |
  | Barbie | Greta Gerwig |
  | Killers of the Flower Moon | Martin Scorsese |
- **Answer Query:**
  ```sql
  SELECT
      M.Title,
      D.DirectorName
  FROM Movies M
  JOIN Directors D ON M.DirectorID = D.DirectorID
  WHERE M.ReleaseYear = 2023;
  ```

**2. List all actors (by name) who were in the movie 'Dune'.**

- **Expected Output:**
  | ActorName |
  | :--- |
  | Timothée Chalamet |
  | Zendaya |
- **Answer Query:**
  ```sql
  SELECT
      A.ActorName
  FROM Actors A
  JOIN Castings C ON A.ActorID = C.ActorID
  JOIN Movies M ON C.MovieID = M.MovieID
  WHERE M.Title = 'Dune';
  ```

**3. Count the number of movies each director has in the database.**

- **Expected Output:**
  | DirectorName | MovieCount |
  | :--- | :--- |
  | Christopher Nolan | 2 |
  | Denis Villeneuve | 2 |
  | Greta Gerwig | 1 |
  | Martin Scorsese | 4 |
  | Quentin Tarantino | 2 |
- **Answer Query:**
  ```sql
  SELECT
      D.DirectorName,
      COUNT(M.MovieID) AS MovieCount
  FROM Directors D
  LEFT JOIN Movies M ON D.DirectorID = M.DirectorID
  GROUP BY D.DirectorName
  ORDER BY MovieCount DESC;
  ```

---

#### **Section 2: Medium-Hard Queries**

**4. List all directors who have directed more than 2 movies in the database.**

- **Expected Output:**
  | DirectorName | MovieCount |
  | :--- | :--- |
  | Martin Scorsese | 4 |
- **Answer Query:**
  ```sql
  SELECT
      D.DirectorName,
      COUNT(M.MovieID) AS MovieCount
  FROM Directors D
  JOIN Movies M ON D.DirectorID = M.DirectorID
  GROUP BY D.DirectorName
  HAVING COUNT(M.MovieID) > 2;
  ```

**5. Find all movies that have no actors listed in the `Castings` table.**

- **Expected Output:**
  | Title |
  | :--- |
  | Animated Short |
- **Answer Query:**
  ```sql
  SELECT
      M.Title
  FROM Movies M
  LEFT JOIN Castings C ON M.MovieID = C.MovieID
  WHERE C.CastingID IS NULL;
  ```

**6. List all movies in the same genre as 'Pulp Fiction' (but do not include 'Pulp Fiction' itself).**

- **Expected Output:**
  | Title | Genre |
  | :--- | :--- |
  | Killers of the Flower Moon | Crime |
  | The Departed | Crime |
- **Answer Query:**
  ```sql
  SELECT
      M.Title,
      M.Genre
  FROM Movies M
  WHERE M.Genre = (
      SELECT Genre
      FROM Movies
      WHERE Title = 'Pulp Fiction'
  )
  AND M.Title <> 'Pulp Fiction';
  ```

**7. Calculate the average box office revenue for each _genre_.**

- **Expected Output:** (Rounded for clarity)
  | Genre | AverageBoxOffice |
  | :--- | :--- |
  | Animation | 0.00 |
  | Biography | 672.30 |
  | Comedy | 910.10 |
  | Crime | 220.77 |
  | Sci-Fi | 650.20 |
- **Answer Query:**
  ```sql
  SELECT
      Genre,
      CAST(AVG(BoxOffice) AS DECIMAL(12, 2)) AS AverageBoxOffice
  FROM Movies
  GROUP BY Genre;
  ```

---

#### **Section 3: Hard Queries**

**8. List all actors who have appeared in a movie directed by 'Quentin Tarantino'.**

- **Expected Output:**
  | ActorName |
  | :--- |
  | Leonardo DiCaprio |
  | Samuel L. Jackson |
  | Uma Thurman |
- **Answer Query:**
  ```sql
  SELECT DISTINCT A.ActorName
  FROM Actors A
  JOIN Castings C ON A.ActorID = C.ActorID
  JOIN Movies M ON C.MovieID = M.MovieID
  JOIN Directors D ON M.DirectorID = D.DirectorID
  WHERE D.DirectorName = 'Quentin Tarantino';
  ```

**9. Find actors who have starred in at least two different _genres_.**

- **Expected Output:**
  | ActorName | GenreCount |
  | :--- | :--- |
  | Cillian Murphy | 2 | (Sci-Fi, Biography)
  | Leonardo DiCaprio | 3 | (Sci-Fi, Crime, Biography, Comedy)
- **Answer Query:**
  ```sql
  SELECT
      A.ActorName,
      COUNT(DISTINCT M.Genre) AS GenreCount
  FROM Actors A
  JOIN Castings C ON A.ActorID = C.ActorID
  JOIN Movies M ON C.MovieID = M.MovieID
  GROUP BY A.ActorName
  HAVING COUNT(DISTINCT M.Genre) >= 2;
  ```

**10. Find actors who have _never_ worked with 'Leonardo DiCaprio' on a movie.**

- **Expected Output:** This lists all actors _except_ Cillian Murphy and Robert De Niro (who were in movies with him).
  | ActorName |
  | :--- |
  | Margot Robbie |
  | Ryan Gosling |
  | Samuel L. Jackson |
  | Timothée Chalamet |
  | Zendaya |
  | Uma Thurman |
  | Scarlett Johansson |
- **Answer Query:**

  ```sql
  -- First, get the ID for DiCaprio
  DECLARE @LeoID INT = (SELECT ActorID FROM Actors WHERE ActorName = 'Leonardo DiCaprio');

  -- Find all actors
  SELECT A.ActorName
  FROM Actors A
  WHERE A.ActorID != @LeoID -- Don't list himself
  AND NOT EXISTS (
      -- Who are in a movie
      SELECT 1
      FROM Castings C1
      WHERE C1.ActorID = A.ActorID
      -- that DiCaprio is also in
      AND C1.MovieID IN (
          SELECT C2.MovieID
          FROM Castings C2
          WHERE C2.ActorID = @LeoID
      )
  );
  ```

**11. Find the 'Biography' movie with the second-highest box office revenue.**

- **Expected Output:**
  | Title | BoxOffice |
  | :--- | :--- |
  | The Wolf of Wall Street | 392.00 |
- **Answer Query:**

  ```sql
  SELECT
      Title,
      BoxOffice
  FROM Movies
  WHERE Genre = 'Biography'
  AND BoxOffice < (
      -- Find the highest box office in that genre
      SELECT MAX(BoxOffice)
      FROM Movies
      WHERE Genre = 'Biography'
  )
  -- Order by box office to get the highest of the remaining
  ORDER BY BoxOffice DESC
  LIMIT 1; -- Using LIMIT 1 (standard SQL) or TOP 1 (SQL Server)

  -- SQL Server equivalent for the last line:
  -- SELECT TOP 1 Title, BoxOffice ...
  ```

---

#### **Section 4: Very Hard Queries**

**12. Find all pairs of actors (Actor A, Actor B) who have appeared in at least two movies _together_.**

- **Expected Output:** Leonardo DiCaprio and Robert De Niro appeared together in 'Killers of the Flower Moon' and 'The Departed'.
  | ActorA_Name | ActorB_Name | MoviesTogether |
  | :--- | :--- | :--- |
  | Leonardo DiCaprio | Robert De Niro | 2 |
- **Answer Query:**
  ```sql
  SELECT
      A1.ActorName AS ActorA_Name,
      A2.ActorName AS ActorB_Name,
      COUNT(C1.MovieID) AS MoviesTogether
  FROM Castings C1
  -- Join Castings to itself on the same movie
  JOIN Castings C2 ON C1.MovieID = C2.MovieID
  -- Ensure we get pairs (A,B) and not (B,A) or (A,A)
  AND C1.ActorID < C2.ActorID
  JOIN Actors A1 ON C1.ActorID = A1.ActorID
  JOIN Actors A2 ON C2.ActorID = A2.ActorID
  GROUP BY A1.ActorName, A2.ActorName
  HAVING COUNT(C1.MovieID) >= 2;
  ```

**13. Find actors who have appeared in _every_ movie directed by 'Martin Scorsese'.**

- **Expected Output:** Leonardo DiCaprio has appeared in 4 Scorsese films, but Scorsese has 4 films _in this dataset_. Therefore, DiCaprio is the answer.
  | ActorName |
  | :--- |
  | Leonardo DiCaprio |
- **Answer Query:**

  ```sql
  -- Get the DirectorID
  DECLARE @ScorseseID INT = (SELECT DirectorID FROM Directors WHERE DirectorName = 'Martin Scorsese');

  SELECT A.ActorName
  FROM Actors A
  WHERE NOT EXISTS (
      -- Find a Scorsese movie
      SELECT 1
      FROM Movies M
      WHERE M.DirectorID = @ScorseseID
      -- That the actor has NOT been in
      AND NOT EXISTS (
          SELECT 1
          FROM Castings C
          WHERE C.MovieID = M.MovieID
            AND C.ActorID = A.ActorID
      )
  );
  ```

**14. Find the director whose movies have the highest _average_ number of cast members.**

- **Expected Output:**
  - Nolan: (Inception: 2, Oppenheimer: 1). Avg = 1.5
  - Tarantino: (Pulp Fiction: 2, Hollywood: 1). Avg = 1.5
  - Gerwig: (Barbie: 2). Avg = 2.0
  - Villeneuve: (Dune: 2, Dune 2: 2). Avg = 2.0
  - Scorsese: (Killers: 2, Wolf: 1, Departed: 2, Short: 0). Avg = 1.25
    | DirectorName | AvgCastSize |
    | :--- | :--- |
    | Greta Gerwig | 2.0000 |
    | Denis Villeneuve | 2.0000 |
- **Answer Query:**
  ```sql
  -- Use a CTE to count the cast size for EACH movie
  WITH MovieCastCounts AS (
      SELECT
          M.MovieID,
          M.DirectorID,
          COUNT(C.ActorID) AS CastSize
      FROM Movies M
      LEFT JOIN Castings C ON M.MovieID = C.MovieID
      GROUP BY M.MovieID, M.DirectorID
  )
  -- Now, average those counts per director
  SELECT TOP 1 WITH TIES
      D.DirectorName,
      CAST(AVG(MCC.CastSize * 1.0) AS DECIMAL(10, 4)) AS AvgCastSize
  FROM MovieCastCounts MCC
  JOIN Directors D ON MCC.DirectorID = D.DirectorID
  GROUP BY D.DirectorName
  ORDER BY AvgCastSize DESC;
  ```

---

### 🔑 Query Solutions & Explanations

Here are the solutions and logic for the three queries above.

#### **15. The Director's "Favorite" Actor**

This query is difficult because it requires finding the "Top 1 per group" (the top actor for _each_ director) without using window functions like `RANK()` or `ROW_NUMBER()`. This is solved using a two-level aggregation.

**Solution:**

```sql
-- CTE 1: Count appearances for every Director-Actor pair
WITH DirectorActorCounts AS (
    SELECT
        M.DirectorID,
        C.ActorID,
        COUNT(M.MovieID) AS AppearanceCount
    FROM Movies M
    JOIN Castings C ON M.MovieID = C.MovieID
    GROUP BY M.DirectorID, C.ActorID
),
-- CTE 2: Find the MAXIMUM appearance count for EACH director
DirectorMaxCounts AS (
    SELECT
        DirectorID,
        MAX(AppearanceCount) AS MaxAppearanceCount
    FROM DirectorActorCounts
    GROUP BY DirectorID
)
-- Final Select: Join the two CTEs
SELECT
    D.DirectorName,
    A.ActorName AS FavoriteActor,
    DAC.AppearanceCount
FROM DirectorActorCounts DAC
-- Join to find the max count for that director
JOIN DirectorMaxCounts DMC ON DAC.DirectorID = DMC.DirectorID
-- This join ensures we only keep the rows that MATCH the max count
JOIN Directors D ON DAC.DirectorID = D.DirectorID
JOIN Actors A ON DAC.ActorID = A.ActorID
WHERE DAC.AppearanceCount = DMC.MaxAppearanceCount
ORDER BY D.DirectorName, FavoriteActor;
```

**Explanation:**

1.  The first CTE, `DirectorActorCounts`, creates a summary table of how many times each actor has worked with each director (e.g., Scorsese + DiCaprio = 4).
2.  The second CTE, `DirectorMaxCounts`, scans the _first_ CTE and finds the single highest number for each director (e.g., for Scorsese, the max is 4).
3.  The final query joins the two CTEs. The key is the `WHERE DAC.AppearanceCount = DMC.MaxAppearanceCount`. This acts as a filter, keeping only the rows from `DirectorActorCounts` where the actor's appearance count is equal to the maximum for that director. This neatly handles ties (like for Villeneuve, where both actors have a count of 2, which equals the max of 2).

---

#### **16. The "Genre Specialist"**

This query is a "set exclusion" problem. It asks for actors who are in "Set A" (Sci-Fi movies) but are _not_ in "Set B" (all other genres). This is solved using a correlated `NOT EXISTS` subquery.

**Solution:**

```sql
SELECT DISTINCT
    A.ActorName
FROM Actors A
JOIN Castings C ON A.ActorID = C.ActorID
JOIN Movies M ON C.MovieID = M.MovieID
WHERE
    M.Genre = 'Sci-Fi'
    -- AND... there does NOT EXIST a movie for this actor...
    AND NOT EXISTS (
        SELECT 1
        FROM Castings C2
        JOIN Movies M2 ON C2.MovieID = M2.MovieID
        WHERE
            C2.ActorID = A.ActorID
            AND M2.Genre <> 'Sci-Fi' -- ...that is NOT Sci-Fi
    );
```

**Explanation:**

1.  The outer query `SELECT A.ActorName... WHERE M.Genre = 'Sci-Fi'` creates an initial list of all actors who have been in _at least one_ Sci-Fi movie (DiCaprio, Cillian, Timothée, Zendaya).
2.  The `AND NOT EXISTS` clause then runs for _each actor_ in that list.
3.  For each actor (e.g., DiCaprio), it runs the subquery: "Does a movie exist for DiCaprio that is _not_ Sci-Fi?"
    - For **DiCaprio**, the subquery finds 'The Departed' (Crime) and returns `TRUE`. The `NOT EXISTS` then becomes `FALSE`, and DiCaprio is filtered out.
    - For **Timothée Chalamet**, the subquery searches for all his movies ('Dune', 'Dune: Part Two') and finds _no_ movie where the genre is not 'Sci-Fi'. The subquery returns `FALSE`. The `NOT EXISTS` then becomes `TRUE`, and Timothée is kept.
    - The same logic applies to **Zendaya**.

---

#### **17. The "New Generation" Director**

This is another, more complex "set exclusion" query. It must find directors for whom a certain "invalid" condition (casting an older actor) does not exist.

**Solution:**

```sql
SELECT DISTINCT
    D.DirectorName
FROM Directors D
JOIN Movies M ON D.DirectorID = M.DirectorID
JOIN Castings C ON M.MovieID = C.MovieID
WHERE
    -- Ensure the director has cast at least one person
    C.ActorID IS NOT NULL
    -- AND... there does NOT EXIST a casting for this director...
    AND NOT EXISTS (
        SELECT 1
        FROM Movies M2
        JOIN Castings C2 ON M2.MovieID = C2.MovieID
        JOIN Actors A2 ON C2.ActorID = A2.ActorID
        WHERE
            M2.DirectorID = D.DirectorID
            -- ...where the actor was born BEFORE 1990
            AND A2.Birthdate < '1990-01-01'
    );
```

**Explanation:**

1.  The outer query `SELECT D.DirectorName...` gets a list of all directors who have cast _at least one person_.
2.  The `AND NOT EXISTS` clause runs for each of those directors (Nolan, Tarantino, Gerwig, Villeneuve, Scorsese).
3.  For each director (e.g., Nolan), it runs the subquery: "Does a casting exist for Nolan where the actor's birthdate is before 1990?"
    - For **Nolan**, the subquery finds Leonardo DiCaprio (1974). It returns `TRUE`. The `NOT EXISTS` becomes `FALSE`, and Nolan is filtered out.
    - For **Greta Gerwig**, the subquery finds Ryan Gosling (1980). It returns `TRUE`. The `NOT EXISTS` becomes `FALSE`, and Gerwig is filtered out.
    - For **Denis Villeneuve**, the subquery checks Timothée (1995) and Zendaya (1996). Neither is `< '1990-01-01'`. The subquery finds no matching rows and returns `FALSE`. The `NOT EXISTS` becomes `TRUE`, and Villeneuve is kept in the list.

---
