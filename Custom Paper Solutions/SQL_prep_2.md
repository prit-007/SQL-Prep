
### 🏏 Paper: The Cricket Analyst's Nightmare

#### **Section 1: Medium-Hard Queries**

**1. Top Tournament Scorers:** 

```sql
SELECT TOP 10
    P.PlayerName,
    SUM(BP.RunsScored) AS TotalRuns
FROM Batting_Performance BP
JOIN Players P ON BP.PlayerID = P.PlayerID
JOIN Matches M ON BP.MatchID = M.MatchID
JOIN Tournaments T ON M.TournamentID = T.TournamentID
WHERE T.TournamentName = 'ICC World Cup 2023'
GROUP BY P.PlayerName
ORDER BY TotalRuns DESC;
```

- **Explanation:** This query joins four tables. It filters by `TournamentName`, groups by `PlayerName` to `SUM()` the `RunsScored`, and orders to find the `TOP 10`.

**2. Man of the Match:** 

```sql
SELECT TOP 1 WITH TIES
    P.PlayerName,
    COUNT(M.MatchID) AS MOTM_Awards
FROM Matches M
JOIN Players P ON M.ManOfTheMatchID = P.PlayerID
WHERE M.MatchType = 'ODI'
GROUP BY P.PlayerName
ORDER BY MOTM_Awards DESC;
```

- **Explanation:** This filters by `MatchType`, groups by `PlayerName`, and counts the awards. `TOP 1 WITH TIES` handles ties.

**3. Venue Win-Rate:** 

```sql
DECLARE @TeamID INT = (SELECT TeamID FROM Teams WHERE TeamName = 'Australia');

SELECT
    M.Venue,
    COUNT(M.MatchID) AS MatchesPlayed,
    AVG(CASE WHEN M.WinningTeamID = @TeamID THEN 1.0 ELSE 0.0 END) * 100 AS WinPercentage
FROM Matches M
WHERE M.Team1ID = @TeamID OR M.Team2ID = @TeamID
GROUP BY M.Venue
HAVING COUNT(M.MatchID) >= 5
   AND AVG(CASE WHEN M.WinningTeamID = @TeamID THEN 1.0 ELSE 0.0 END) > 0.75;
```

- **Explanation:** This calculates a percentage within an aggregate. The `AVG()` function uses a `CASE` statement to create a "virtual" column of 1s (wins) and 0s (losses/draws), which are then averaged to get the win rate.

**4. Highest Score in Losing Cause:** 

```sql
SELECT TOP 1
    P.PlayerName,
    BP.RunsScored,
    M.MatchDate
FROM Batting_Performance BP
JOIN Players P ON BP.PlayerID = P.PlayerID
JOIN Matches M ON BP.MatchID = M.MatchID
WHERE
    M.WinningTeamID IS NOT NULL
    AND BP.TeamID != M.WinningTeamID -- The player's team lost
ORDER BY BP.RunsScored DESC;
```

- **Explanation:** The `WHERE` clause `BP.TeamID != M.WinningTeamID` logically isolates all innings played for a losing team. `TOP 1` finds the highest score among them.

**5. Role-Bending Players:** 

```sql
SELECT
    P.PlayerName,
    SUM(B.WicketsTaken) AS TotalWickets
FROM Players P
JOIN Bowling_Performance B ON P.PlayerID = B.PlayerID
WHERE P.Role = 'Batsman'
GROUP BY P.PlayerName
HAVING SUM(B.WicketsTaken) >= 20;
```

- **Explanation:** This query filters by `Role` _before_ grouping, then uses a `HAVING` clause _after_ grouping to find those whose `SUM` of wickets meets the criteria.

**6. "Best vs. Worst" Bowlers:** 

```sql
WITH TestPerformance AS (
    SELECT
        PlayerID,
        SUM(RunsConceded) / SUM(OversBowled) AS Economy
    FROM Bowling_Performance B
    JOIN Matches M ON B.MatchID = M.MatchID
    WHERE M.MatchType = 'Test'
    GROUP BY PlayerID
    HAVING SUM(OversBowled) >= 50
),
T20Performance AS (
    SELECT
        PlayerID,
        SUM(RunsConceded) / SUM(OversBowled) AS Economy
    FROM Bowling_Performance B
    JOIN Matches M ON B.MatchID = M.MatchID
    WHERE M.MatchType = 'T20'
    GROUP BY PlayerID
    HAVING SUM(OversBowled) >= 50
)
SELECT P.PlayerName, TP.Economy AS TestEconomy, T20P.Economy AS T20Economy
FROM TestPerformance TP
JOIN T20Performance T20P ON TP.PlayerID = T20P.PlayerID
JOIN Players P ON P.PlayerID = TP.PlayerID
WHERE TP.Economy < 4.0 AND T20P.Economy > 9.0;
```

- **Explanation:** Uses two Common Table Expressions (CTEs) to separately aggregate performance in 'Test' and 'T20'. The final query joins these two CTEs on `PlayerID` to find players who exist in both filtered sets.

**7. Century Against Specific Opponent:** 

```sql
DECLARE @OpponentID INT = (SELECT TeamID FROM Teams WHERE TeamName = 'England');

SELECT DISTINCT P.PlayerName, BP.RunsScored, M.MatchDate
FROM Batting_Performance BP
JOIN Matches M ON BP.MatchID = M.MatchID
JOIN Players P ON BP.PlayerID = P.PlayerID
WHERE
    BP.RunsScored >= 100
    AND BP.TeamID != @OpponentID -- The player was not on England
    AND (M.Team1ID = @OpponentID OR M.Team2ID = @OpponentID); -- England played
```

- **Explanation:** Identifies the opponent (`@OpponentID`). It then finds all 100+ scores where the opponent was in the match _but_ was not the player's own team.

**8. Toss-Loss, Match-Win:** 

```sql
SELECT TOP 1 WITH TIES
    T.TeamName,
    COUNT(M.MatchID) AS Wins_Losing_Toss
FROM Matches M
JOIN Teams T ON M.WinningTeamID = T.TeamID
WHERE M.TossWinnerTeamID != M.WinningTeamID
  AND M.WinningTeamID IS NOT NULL
GROUP BY T.TeamName
ORDER BY Wins_Losing_Toss DESC;
```

- **Explanation:** A simple `GROUP BY` where the `WHERE` clause finds all matches where the `WinningTeamID` is not the `TossWinnerTeamID`.

**9. Runs & Wickets at Venue:** 

```sql
SELECT
    (SELECT SUM(BP.RunsScored)
     FROM Batting_Performance BP
     JOIN Matches M ON BP.MatchID = M.MatchID
     WHERE M.Venue = 'Wankhede Stadium') AS TotalRuns_At_Venue,

    (SELECT SUM(BO.WicketsTaken)
     FROM Bowling_Performance BO
     JOIN Matches M ON BO.MatchID = M.MatchID
     WHERE M.Venue = 'Wankhede Stadium') AS TotalWickets_At_Venue;
```

- **Explanation:** Uses two scalar subqueries (subqueries in the `SELECT` list that return one value). Each subquery performs its own aggregation, filtered for the same venue.

**10. Tournament Exclusivity:** 

```sql
WITH PlayersInMatch AS (
    SELECT DISTINCT MatchID, PlayerID FROM Batting_Performance
    UNION
    SELECT DISTINCT MatchID, PlayerID FROM Bowling_Performance
),
PlayersInTournament AS (
    SELECT DISTINCT P.PlayerID, T.TournamentName
    FROM PlayersInMatch P
    JOIN Matches M ON P.MatchID = M.MatchID
    JOIN Tournaments T ON M.TournamentID = T.TournamentID
)
SELECT P.PlayerName
FROM PlayersInTournament PIT
JOIN Players P ON PIT.PlayerID = P.PlayerID
WHERE PIT.TournamentName = 'IPL 2024'
EXCEPT
SELECT P.PlayerName
FROM PlayersInTournament PIT
JOIN Players P ON PIT.PlayerID = P.PlayerID
WHERE PIT.TournamentName = 'ICC World Cup 2023';
```

- **Explanation:** Uses the `EXCEPT` set operator. It gets the set of all 'IPL 2024' players and subtracts the set of all 'ICC World Cup 2023' players, leaving only those exclusive to the IPL.

**11. 350+ Scores:** 

```sql
WITH TeamMatchScores AS (
    SELECT
        BP.TeamID,
        M.MatchID,
        SUM(BP.RunsScored) AS TotalTeamScore
    FROM Batting_Performance BP
    JOIN Matches M ON BP.MatchID = M.MatchID
    WHERE M.MatchType = 'ODI'
    GROUP BY BP.TeamID, M.MatchID
)
SELECT TOP 1 WITH TIES
    T.TeamName,
    COUNT(TMS.MatchID) AS Scores_350_Plus
FROM TeamMatchScores TMS
JOIN Teams T ON TMS.TeamID = T.TeamID
WHERE TMS.TotalTeamScore >= 350
GROUP BY T.TeamName
ORDER BY Scores_350_Plus DESC;
```

- **Explanation:** A two-level aggregation. The CTE `TeamMatchScores` gets the total score for _one team in one match_. The outer query then counts how many times those `TotalTeamScore`s were 350+ for each team.

**12. The "Duck" King:** 

```sql
SELECT TOP 1 WITH TIES
    P.PlayerName,
    COUNT(BP.PerformanceID) AS TotalDucks
FROM Batting_Performance BP
JOIN Players P ON BP.PlayerID = P.PlayerID
WHERE BP.RunsScored = 0 AND BP.IsOut = 1
GROUP BY P.PlayerName
ORDER BY TotalDucks DESC;
```

- **Explanation:** A simple `GROUP BY` with a `WHERE` clause that correctly defines a "duck" (out for 0) vs. a "0 not out" score.

**13. Best Economy (Min Overs):** 

```sql
SELECT TOP 1
    P.PlayerName,
    SUM(B.RunsConceded) / SUM(B.OversBowled) AS EconomyRate
FROM Bowling_Performance B
JOIN Players P ON B.PlayerID = P.PlayerID
JOIN Matches M ON B.MatchID = M.MatchID
JOIN Tournaments T ON M.TournamentID = T.TournamentID
WHERE T.TournamentName = 'IPL 2024'
GROUP BY P.PlayerName
HAVING SUM(B.OversBowled) >= 40
ORDER BY EconomyRate ASC;
```

- **Explanation:** A `GROUP BY` that aggregates performance, filters by minimum overs with `HAVING`, and `ORDER BY ASC` to find the lowest (best) economy rate.

---

#### **Section 2: Very Hard Queries (No Window Functions)**

**14. The "Clutch" Player (Finals Performance):** 

```sql
WITH PlayerStats AS (
    SELECT
        BP.PlayerID,
        -- Sums for Final Matches
        SUM(CASE WHEN M.MatchStage = 'Final' THEN BP.RunsScored ELSE 0 END) AS FinalRuns,
        SUM(CASE WHEN M.MatchStage = 'Final' AND BP.IsOut = 1 THEN 1 ELSE 0 END) AS FinalOuts,
        -- Sums for Other Matches
        SUM(CASE WHEN M.MatchStage != 'Final' THEN BP.RunsScored ELSE 0 END) AS OtherRuns,
        SUM(CASE WHEN M.MatchStage != 'Final' AND BP.IsOut = 1 THEN 1 ELSE 0 END) AS OtherOuts
    FROM Batting_Performance BP
    JOIN Matches M ON BP.MatchID = M.MatchID
    GROUP BY BP.PlayerID
),
Averages AS (
    SELECT
        PlayerID,
        (FinalRuns * 1.0) / NULLIF(FinalOuts, 0) AS FinalAverage,
        (OtherRuns * 1.0) / NULLIF(OtherOuts, 0) AS OtherAverage
    FROM PlayerStats
    WHERE FinalOuts > 0 AND OtherOuts > 0
)
SELECT TOP 1
    P.PlayerName,
    A.FinalAverage,
    A.OtherAverage,
    (A.FinalAverage - A.OtherAverage) / A.OtherAverage * 100 AS Pct_Increase
FROM Averages A
JOIN Players P ON A.PlayerID = P.PlayerID
ORDER BY Pct_Increase DESC;
```

- **Explanation:** This query uses **conditional aggregation**. It "pivots" the data _within_ the `SUM` function, calculating stats for 'Final' vs. 'Other' stages in a single pass. `NULLIF(..., 0)` prevents division-by-zero errors. No window functions are needed.

**15. The "Tournament Specialist" (SQL Division):** 

```sql
SELECT P.PlayerName
FROM (
    -- Get all players who participated in the tournament
    SELECT DISTINCT BP.PlayerID, BP.TeamID
    FROM Batting_Performance BP
    JOIN Matches M ON BP.MatchID = M.MatchID
    JOIN Tournaments T ON M.TournamentID = T.TournamentID
    WHERE T.TournamentName = 'ICC World Cup 2023'
    UNION -- Use UNION to combine with bowlers
    SELECT DISTINCT BO.PlayerID, BO.TeamID
    FROM Bowling_Performance BO
    JOIN Matches M ON BO.MatchID = M.MatchID
    JOIN Tournaments T ON M.TournamentID = T.TournamentID
    WHERE T.TournamentName = 'ICC World Cup 2023'
) AS PlayerTeams
JOIN Players P ON PlayerTeams.PlayerID = P.PlayerID
WHERE NOT EXISTS (
    -- Find a tournament match their team played
    SELECT 1
    FROM Matches M
    JOIN Tournaments T ON M.TournamentID = T.TournamentID
    WHERE T.TournamentName = 'ICC World Cup 2023'
      AND (M.Team1ID = PlayerTeams.TeamID OR M.Team2ID = PlayerTeams.TeamID)
      -- That the player did NOT participate in
      AND NOT EXISTS (
        SELECT 1
        FROM Batting_Performance BP
        WHERE BP.MatchID = M.MatchID AND BP.PlayerID = PlayerTeams.PlayerID
      )
      AND NOT EXISTS (
        SELECT 1
        FROM Bowling_Performance BO
        WHERE BO.MatchID = M.MatchID AND BO.PlayerID = PlayerTeams.PlayerID
      )
);
```

- **Explanation:** This is a classic **SQL Division** problem solved using "double-negative logic" (`NOT EXISTS... AND NOT EXISTS...`).
  1.  The `PlayerTeams` subquery finds every player who played at least one game in the tournament for a specific team.
  2.  The outer query translates the English: "Find a player for whom a match _does not exist_ that their team played in, that they _did not_ play in."
  3.  This double-negative confirms that the set of matches they played is equal to the set of matches their team played. This is pure, brutal, non-windowing logic.

**16. The "Lonely Warrior":** 

```sql
WITH TeamMatchPerformance AS (
    SELECT
        MatchID,
        TeamID,
        COUNT(CASE WHEN RunsScored >= 50 THEN 1 END) AS Num50s,
        MAX(CASE WHEN RunsScored >= 50 THEN PlayerID END) AS PlayerID_of_50
    FROM Batting_Performance
    GROUP BY MatchID, TeamID
)
SELECT
    P.PlayerName,
    BP.RunsScored,
    M.MatchDate
FROM TeamMatchPerformance TMP
JOIN Matches M ON TMP.MatchID = M.MatchID
JOIN Batting_Performance BP ON TMP.PlayerID_of_50 = BP.PlayerID AND TMP.MatchID = BP.MatchID
JOIN Players P ON BP.PlayerID = P.PlayerID
WHERE
    TMP.Num50s = 1 -- Only one player scored 50+
    AND M.WinningTeamID IS NOT NULL
    AND TMP.TeamID != M.WinningTeamID; -- And the team lost
```

- **Explanation:** This query is a clever use of conditional aggregation. The CTE groups by match and team, counting how many 50s were scored (`Num50s`). The `MAX(CASE...)` trick only works to identify the player _if_ we assume there's only one (which we then filter for with `Num50s = 1`). The final query joins this to `Matches` to find the losses.

**17. The "Impact" Player (Full Outer Join):** 

```sql
WITH TournamentBatting AS (
    SELECT
        BP.PlayerID,
        SUM(BP.RunsScored) AS TotalRuns
    FROM Batting_Performance BP
    JOIN Matches M ON BP.MatchID = M.MatchID
    JOIN Tournaments T ON M.TournamentID = T.TournamentID
    WHERE T.TournamentName = 'ICC World Cup 2023'
    GROUP BY BP.PlayerID
),
TournamentBowling AS (
    SELECT
        BO.PlayerID,
        SUM(BO.WicketsTaken) AS TotalWickets
    FROM Bowling_Performance BO
    JOIN Matches M ON BO.MatchID = M.MatchID
    JOIN Tournaments T ON M.TournamentID = T.TournamentID
    WHERE T.TournamentName = 'ICC World Cup 2023'
    GROUP BY BO.PlayerID
)
SELECT TOP 5
    P.PlayerName,
    ISNULL(B.TotalRuns, 0) AS Runs,
    ISNULL(O.TotalWickets, 0) AS Wickets,
    (ISNULL(B.TotalRuns, 0) + (ISNULL(O.TotalWickets, 0) * 20)) AS ImpactScore
FROM Players P
LEFT JOIN TournamentBatting B ON P.PlayerID = B.PlayerID
LEFT JOIN TournamentBowling O ON P.PlayerID = O.PlayerID
WHERE B.TotalRuns IS NOT NULL OR O.TotalWickets IS NOT NULL
ORDER BY ImpactScore DESC;
```

- **Explanation:** This query must combine two different aggregations. Using two CTEs for `Batting` and `Bowling` aggregates is clean. The final query `LEFT JOIN`s them from `Players` to handle "pure batsmen" or "pure bowlers" who would be `NULL` in one of the CTEs. `ISNULL(..., 0)` is critical for the final calculation.

---

**The "Nightmare" Queries (Re-written without Window Functions)**

**18. The "Form" Player (Consecutive 50s):**

- **Question:** Find all players who have scored 50+ runs in three _consecutive_ matches.
- **Answer (The "Triple Self-Join"):**
  ```sql
  WITH PlayerInnings AS (
      -- Get all innings for all players
      SELECT BP.PlayerID, M.MatchDate, BP.RunsScored, BP.MatchID
      FROM Batting_Performance BP
      JOIN Matches M ON BP.MatchID = M.MatchID
  ),
  Player50s AS (
      -- Filter for only 50+ scores
      SELECT * FROM PlayerInnings WHERE RunsScored >= 50
  )
  SELECT DISTINCT P.PlayerName, p3.MatchDate AS Date_of_3rd_50
  FROM Player50s p1
  JOIN Player50s p2 ON p1.PlayerID = p2.PlayerID AND p1.MatchDate < p2.MatchDate
  JOIN Player50s p3 ON p2.PlayerID = p3.PlayerID AND p2.MatchDate < p3.MatchDate
  JOIN Players P ON p1.PlayerID = P.PlayerID
  WHERE
      -- Check that p2 is the *next* match after p1
      p2.MatchDate = (
          SELECT MIN(MatchDate)
          FROM PlayerInnings
          WHERE PlayerID = p1.PlayerID AND MatchDate > p1.MatchDate
      )
      -- Check that p3 is the *next* match after p2
      AND p3.MatchDate = (
          SELECT MIN(MatchDate)
          FROM PlayerInnings
          WHERE PlayerID = p2.PlayerID AND MatchDate > p2.MatchDate
      );
  ```
- **Explanation:** This is how you "suffer."
  1.  We get all 50+ scores in the `Player50s` CTE.
  2.  We **self-join** this CTE three times (`p1`, `p2`, `p3`) on the same `PlayerID`.
  3.  The `p1.MatchDate < p2.MatchDate < p3.MatchDate` condition ensures we have three 50+ scores in chronological order.
  4.  The **brutal** part is the `WHERE` clause. It runs a correlated subquery _for each row_ to ensure that `p2`'s match is the _very next match_ the player played after `p1` (not just _any_ match after), and `p3` is the _very next match_ after `p2`. This is what checks for "consecutive."

**19. The "Winning Streak" (Gaps & Islands):**

- **Note:** Finding the _longest_ streak without window functions or recursion is a famous problem that is borderline impossible with a single static query. The question is modified to be solvable.
- **Modified Question:** Find all teams that have had a winning streak of **at least 3** matches in a single tournament.
- **Answer (The "Triple Self-Join" for Matches):**
  ```sql
  WITH TeamMatches AS (
      -- Get a clean list of matches and wins
      SELECT M.MatchID, M.MatchDate, M.TournamentID, T.TeamID, T.TeamName,
             CASE WHEN M.WinningTeamID = T.TeamID THEN 1 ELSE 0 END AS DidWin
      FROM Teams T
      JOIN Matches M ON T.TeamID = M.Team1ID OR T.TeamID = M.Team2ID
  )
  SELECT DISTINCT T1.TeamName, T1.TournamentID, T1.MatchDate AS StreakStart
  FROM TeamMatches T1
  JOIN TeamMatches T2 ON T1.TeamID = T2.TeamID AND T1.TournamentID = T2.TournamentID
  JOIN TeamMatches T3 ON T2.TeamID = T3.TeamID AND T2.TournamentID = T3.TournamentID
  WHERE
      T1.DidWin = 1 AND T2.DidWin = 1 AND T3.DidWin = 1
      -- Find T2 as the *next* match after T1 in the tournament
      AND T2.MatchDate = (
          SELECT MIN(MatchDate)
          FROM TeamMatches
          WHERE TeamID = T1.TeamID AND TournamentID = T1.TournamentID AND MatchDate > T1.MatchDate
      )
      -- Find T3 as the *next* match after T2 in the tournament
      AND T3.MatchDate = (
          SELECT MIN(MatchDate)
          FROM TeamMatches
          WHERE TeamID = T2.TeamID AND TournamentID = T2.TournamentID AND MatchDate > T2.MatchDate
      );
  ```
- **Explanation:** This uses the exact same self-join logic as the previous query, but for matches.
  1.  `TeamMatches` CTE cleans the data, creating one row per team, per match.
  2.  We self-join `TeamMatches` three times (`T1`, `T2`, `T3`) on `TeamID` and `TournamentID`.
  3.  We filter `WHERE T1.DidWin = 1 AND T2.DidWin = 1 AND T3.DidWin = 1`.
  4.  The two correlated subqueries in the `WHERE` clause are the "consecutive" check, ensuring `T2` is the _next_ match after `T1` and `T3` is the _next_ match after `T2`.

**20. The "Career Progression" (First 10 vs. Last 10):**

- **Question:** Identify the player whose batting average in their _most recent_ 10 career matches shows the largest absolute improvement compared to their _first_ 10 career matches.
- **Answer (Using `OUTER APPLY`):** (This works in SQL Server/Oracle)
  ```sql
  WITH PlayerAverages AS (
      SELECT
          P.PlayerID,
          P.PlayerName,
          First10.Avg AS First10Avg,
          Last10.Avg AS Last10Avg
      FROM Players P
      -- Correlated subquery to get first 10 innings avg
      OUTER APPLY (
          SELECT
              SUM(Firsts.RunsScored) * 1.0 / NULLIF(SUM(CASE WHEN Firsts.IsOut = 1 THEN 1 ELSE 0 END), 0) AS Avg
          FROM (
              SELECT TOP 10 BP.RunsScored, BP.IsOut
              FROM Batting_Performance BP
              JOIN Matches M ON BP.MatchID = M.MatchID
              WHERE BP.PlayerID = P.PlayerID
              ORDER BY M.MatchDate ASC
          ) AS Firsts
      ) AS First10
      -- Correlated subquery to get last 10 innings avg
      OUTER APPLY (
          SELECT
              SUM(Lasts.RunsScored) * 1.0 / NULLIF(SUM(CASE WHEN Lasts.IsOut = 1 THEN 1 ELSE 0 END), 0) AS Avg
          FROM (
              SELECT TOP 10 BP.RunsScored, BP.IsOut
              FROM Batting_Performance BP
              JOIN Matches M ON BP.MatchID = M.MatchID
              WHERE BP.PlayerID = P.PlayerID
              ORDER BY M.MatchDate DESC
          ) AS Lasts
      ) AS Last10
  )
  SELECT TOP 1
      PlayerName,
      First10Avg,
      Last10Avg,
      (Last10Avg - First10Avg) AS Improvement
  FROM PlayerAverages
  WHERE First10Avg IS NOT NULL AND Last10Avg IS NOT NULL
  ORDER BY Improvement DESC;
  ```
- **Explanation:** This is the _only_ way to get "TOP N per group" without window functions.
  1.  `OUTER APPLY` (or `CROSS APPLY`) allows you to run a correlated subquery that returns a _table_ (not just a single value).
  2.  For each `Player`, the first `OUTER APPLY` subquery runs, finds that player's first 10 innings (`TOP 10... ORDER BY ASC`), calculates their average, and "applies" it as a new column.
  3.  The second `OUTER APPLY` does the same for the _last_ 10 innings (`TOP 10... ORDER BY DESC`).
  4.  The final query then just subtracts the two calculated averages and finds the `TOP 1` improvement. This is an extremely difficult query.
