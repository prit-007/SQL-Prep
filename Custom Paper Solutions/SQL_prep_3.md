
---

### 🔑 Answer Key: Paper 10

#### **Section 1: Medium-Hard Queries**

**1. Top "Cart-Adders"**

```sql
SELECT TOP 1
    U.UserName,
    COUNT(E.EventID) AS CartAdds
FROM Events E
JOIN Page_Views PV ON E.ViewID = PV.ViewID
JOIN Users U ON PV.UserID = U.UserID
WHERE E.EventName = 'add_to_cart'
GROUP BY U.UserName
ORDER BY CartAdds DESC;
```

- **Explanation:** This query joins `Events`, `Page_Views`, and `Users`. It filters for the 'add_to_cart' event, groups by the user's name, counts the events, and returns the `TOP 1` ordered by the count.

**2. Most Viewed Page**

```sql
SELECT TOP 1
    P.PageURL,
    COUNT(PV.ViewID) AS TotalViews
FROM Page_Views PV
JOIN Pages P ON PV.PageID = P.PageID
GROUP BY P.PageURL
ORDER BY TotalViews DESC;
```

- **Explanation:** A simple query that joins `Page_Views` and `Pages`, groups by the `PageURL`, and counts the views, returning the `TOP 1`.

**3. Country Activity**

```sql
SELECT
    U.Country,
    COUNT(PV.ViewID) AS TotalPageViews,
    COUNT(DISTINCT U.UserID) AS UniqueUsers
FROM Page_Views PV
JOIN Users U ON PV.UserID = U.UserID
GROUP BY U.Country;
```

- **Explanation:** This query joins `Page_Views` and `Users`, then groups by `Country`. It uses `COUNT()` for total views and `COUNT(DISTINCT ...)` to get the unique user count for each country.

**4. Bounced Users**

```sql
SELECT
    U.UserName
FROM Users U
JOIN Page_Views PV ON U.UserID = PV.UserID
GROUP BY U.UserID, U.UserName
HAVING COUNT(PV.ViewID) = 1;
```

- **Explanation:** This query groups all page views by user. The `HAVING` clause filters the results to show only those users whose total `COUNT` of page views is exactly 1.

**5. "Leaky" Cart**

```sql
SELECT P.PageURL
FROM Pages P
WHERE P.PageType = 'Product'
  AND NOT EXISTS (
    SELECT 1
    FROM Page_Views PV
    JOIN Events E ON PV.ViewID = E.ViewID
    WHERE PV.PageID = P.PageID
      AND E.EventName = 'add_to_cart'
  );
```

- **Explanation:** This query uses a `NOT EXISTS` subquery. It selects all 'Product' pages, then checks for each page: "Does an 'add_to_cart' event _not exist_ for this page?" This is more efficient than a `LEFT JOIN` on a large event table.

**6. "Buy" Button Mismatch**

```sql
SELECT DISTINCT P.PageURL
FROM Pages P
JOIN Page_Views PV ON P.PageID = PV.PageID
JOIN Events E ON PV.ViewID = E.ViewID
WHERE
    E.EventName = 'click_buy'
    AND P.PageType != 'Checkout';
```

- **Explanation:** This query joins the three tables, filters for the 'click_buy' event, and adds a second filter to find where the `PageType` is _not_ 'Checkout', indicating a mismatch.

**7. The "Lurkers"**

```sql
-- Find users with > 10 article views
WITH ArticleViewers AS (
    SELECT PV.UserID, COUNT(PV.ViewID) AS ArticleViews
    FROM Page_Views PV
    JOIN Pages P ON PV.PageID = P.PageID
    WHERE P.PageType = 'Article'
    GROUP BY PV.UserID
    HAVING COUNT(PV.ViewID) > 10
),
-- Find users who have seen a product page
ProductViewers AS (
    SELECT DISTINCT PV.UserID
    FROM Page_Views PV
    JOIN Pages P ON PV.PageID = P.PageID
    WHERE P.PageType = 'Product'
)
-- Get the first set, and remove the second set
SELECT U.UserName
FROM ArticleViewers AV
JOIN Users U ON AV.UserID = U.UserID
EXCEPT
SELECT U.UserName
FROM ProductViewers PV
JOIN Users U ON PV.UserID = U.UserID;
```

- **Explanation:** This uses the `EXCEPT` set operator. The first CTE finds all users who meet the `> 10` article view criteria. The second CTE finds all users who have _any_ product views. `EXCEPT` subtracts the second set from the first.

**8. Orphaned Events**

```sql
SELECT
    E.EventName,
    COUNT(E.EventID) AS OrphanedEventCount
FROM Events E
LEFT JOIN Page_Views PV ON E.ViewID = PV.ViewID
WHERE PV.ViewID IS NULL
GROUP BY E.EventName;
```

- **Explanation:** This uses a `LEFT JOIN` to find all events that _do not_ have a matching `ViewID` in the `Page_Views` table (indicated by `PV.ViewID IS NULL`).

---

#### **Section 2: Very Hard Queries**

**9. The "Loyalists" (SQL Division)**

```sql
SELECT U.UserName
FROM Users U
WHERE NOT EXISTS (
    -- Find an 'Article' page...
    SELECT 1
    FROM Pages P
    WHERE P.PageType = 'Article'
      -- ...that the user has NOT viewed
      AND NOT EXISTS (
        SELECT 1
        FROM Page_Views PV
        WHERE PV.UserID = U.UserID
          AND PV.PageID = P.PageID
      )
);
```

- **Explanation:** This is a classic SQL Division problem using "double-negative logic." The query translates to: "Find a User (`U`) for whom an 'Article' page (`P`) _does not exist_ that they have _not viewed_." If a user has missed even one article, the inner `NOT EXISTS` will fail, and they will be excluded.

**10. The "Purchase Funnel" (Non-Consecutive)**

```sql
SELECT DISTINCT U.UserName
FROM Users U
WHERE
  -- They viewed a Product
  EXISTS (
    SELECT 1 FROM Page_Views PV
    JOIN Pages P ON PV.PageID = P.PageID
    WHERE PV.UserID = U.UserID AND P.PageType = 'Product'
  )
  -- AND they viewed a Cart page after their first Product view
  AND EXISTS (
    SELECT 1 FROM Page_Views PV_Cart
    JOIN Pages P_Cart ON PV_Cart.PageID = P_Cart.PageID
    WHERE PV_Cart.UserID = U.UserID AND P_Cart.PageType = 'Cart'
      AND PV_Cart.ViewTimestamp > (
        SELECT MIN(PV_Prod.ViewTimestamp) FROM Page_Views PV_Prod
        JOIN Pages P_Prod ON PV_Prod.PageID = P_Prod.PageID
        WHERE PV_Prod.UserID = U.UserID AND P_Prod.PageType = 'Product'
      )
  )
  -- AND they viewed a Checkout page after their first Cart view
  AND EXISTS (
    SELECT 1 FROM Page_Views PV_Check
    JOIN Pages P_Check ON PV_Check.PageID = P_Check.PageID
    WHERE PV_Check.UserID = U.UserID AND P_Check.PageType = 'Checkout'
      AND PV_Check.ViewTimestamp > (
        SELECT MIN(PV_Cart2.ViewTimestamp) FROM Page_Views PV_Cart2
        JOIN Pages P_Cart2 ON PV_Cart2.PageID = P_Cart2.PageID
        WHERE PV_Cart2.UserID = U.UserID AND P_Cart2.PageType = 'Cart'
      )
  );
```

- **Explanation:** This query checks for the _existence_ of each step in the funnel in the correct time-order. It confirms a 'Product' view exists. Then it confirms a 'Cart' view exists _after_ the _first_ 'Product' view. Finally, it confirms a 'Checkout' view exists _after_ the _first_ 'Cart' view.

**11. The "Stickiest" User**

```sql
SELECT TOP 1
    U.UserName,
    COUNT(DISTINCT CAST(PV.ViewTimestamp AS DATE)) AS ActiveDays
FROM Page_Views PV
JOIN Users U ON PV.UserID = U.UserID
GROUP BY U.UserName
ORDER BY ActiveDays DESC;
```

- **Explanation:** This query groups all views by user. The key is `COUNT(DISTINCT CAST(PV.ViewTimestamp AS DATE))`. `CAST(... AS DATE)` truncates the time, leaving only the date. `COUNT(DISTINCT ...)` then counts the unique dates for each user.

**12. The "Specialists"**

```sql
SELECT U.UserName
FROM Users U
WHERE
  -- Ensure the user has viewed at least one 'Article'
  EXISTS (
    SELECT 1 FROM Page_Views PV
    JOIN Pages P ON PV.PageID = P.PageID
    WHERE PV.UserID = U.UserID AND P.PageType = 'Article'
  )
  -- AND ensure the user has NOT viewed any non-Article page
  AND NOT EXISTS (
    SELECT 1 FROM Page_Views PV
    JOIN Pages P ON PV.PageID = P.PageID
    WHERE PV.UserID = U.UserID AND P.PageType != 'Article'
  );
```

- **Explanation:** This uses `EXISTS` and `NOT EXISTS`. The query finds users who 1) `EXISTS` in the set of 'Article' viewers and 2) `NOT EXISTS` in the set of 'non-Article' viewers.

**13. User's "Favorite" Page**

```sql
-- CTE 1: Get all view counts for every user-page combination
WITH UserPageCounts AS (
    SELECT
        UserID,
        PageID,
        COUNT(ViewID) AS ViewCount
    FROM Page_Views
    GROUP BY UserID, PageID
),
-- CTE 2: Find the single MAX view count for EACH user
UserMaxCounts AS (
    SELECT
        UserID,
        MAX(ViewCount) AS MaxViewCount
    FROM UserPageCounts
    GROUP BY UserID
)
-- Final Select: Find the page(s) that match the max count
SELECT
    U.UserName,
    P.PageURL,
    UMC.MaxViewCount
FROM UserMaxCounts UMC
JOIN UserPageCounts UPC ON UMC.UserID = UPC.UserID
                       AND UMC.MaxViewCount = UPC.ViewCount
JOIN Users U ON UMC.UserID = U.UserID
JOIN Pages P ON UPC.PageID = P.PageID
ORDER BY U.UserName;
```

- **Explanation:** This is the standard "top N per group" solution without window functions.
  1.  `UserPageCounts`: Counts views for every page a user has seen.
  2.  `UserMaxCounts`: Finds the _single highest_ number of views for each user.
  3.  The final query joins them, keeping only the rows where the `ViewCount` from CTE1 _equals_ the `MaxViewCount` from CTE2. This handles ties correctly.

**14. The "Abandoned Cart"**

```sql
-- Find all users who have added to cart
WITH CartUsers AS (
    SELECT DISTINCT PV.UserID
    FROM Events E
    JOIN Page_Views PV ON E.ViewID = PV.ViewID
    WHERE E.EventName = 'add_to_cart'
),
-- Find all users who have visited checkout
CheckoutUsers AS (
    SELECT DISTINCT PV.UserID
    FROM Page_Views PV
    JOIN Pages P ON PV.PageID = P.PageID
    WHERE P.PageType = 'Checkout'
)
-- Subtract the second set from the first
SELECT U.UserName
FROM CartUsers CU
JOIN Users U ON CU.UserID = U.UserID
EXCEPT
SELECT U.UserName
FROM CheckoutUsers CK
JOIN Users U ON CK.UserID = U.UserID;
```

- **Explanation:** This uses `EXCEPT`. It finds the set of all users who have an 'add_to_cart' event, then subtracts the set of all users who have _any_ 'Checkout' page view.

**15. Time-to-Purchase**

```sql
SELECT TOP 1
    U.UserName,
    DATEDIFF(
        second,
        U.JoinDate,
        MIN(PV.ViewTimestamp)
    ) AS SecondsToFirstPurchase
FROM Users U
JOIN Page_Views PV ON U.UserID = PV.UserID
JOIN Events E ON PV.ViewID = E.ViewID
WHERE E.EventName = 'click_buy'
GROUP BY U.UserID, U.UserName, U.JoinDate
ORDER BY SecondsToFirstPurchase ASC;
```

- **Explanation:** This query finds all 'click_buy' events, groups them by user, and finds the `MIN(ViewTimestamp)` (the first purchase). It then uses `DATEDIFF` to calculate the time in seconds between their `JoinDate` and that first purchase, ordering to find the `TOP 1` fastest.

**16. Session-Bouncer**

```sql
-- CTE 1: Find the timestamp of the last view for each user on each day
WITH LastViewOfDay AS (
    SELECT
        UserID,
        CAST(ViewTimestamp AS DATE) AS ViewDate,
        MAX(ViewTimestamp) AS LastTimestamp
    FROM Page_Views
    GROUP BY UserID, CAST(ViewTimestamp AS DATE)
)
-- Find the page associated with that exact timestamp
SELECT TOP 1
    P.PageURL,
    COUNT(PV.ViewID) AS SessionEnds
FROM Page_Views PV
JOIN LastViewOfDay LVO ON PV.UserID = LVO.UserID
                       AND PV.ViewTimestamp = LVO.LastTimestamp
JOIN Pages P ON PV.PageID = P.PageID
GROUP BY P.PageURL
ORDER BY SessionEnds DESC;
```

- **Explanation:** This is a two-step process.
  1.  The `LastViewOfDay` CTE groups all views by `UserID` and `ViewDate` and finds the `MAX(ViewTimestamp)` for each group. This identifies the _exact time_ of the last view in each session.
  2.  The final query joins `Page_Views` back to this CTE on that exact timestamp, effectively finding _which page_ was viewed at that last moment. It then counts those pages.

**17. Co-Occurrence**

```sql
SELECT TOP 1
    P1.PageURL AS PageA,
    P2.PageURL AS PageB,
    COUNT(*) AS CoOccurrenceCount
FROM Page_Views PV1
-- Join to another view by the same user on the same day
JOIN Page_Views PV2 ON PV1.UserID = PV2.UserID
                   AND CAST(PV1.ViewTimestamp AS DATE) = CAST(PV2.ViewTimestamp AS DATE)
JOIN Pages P1 ON PV1.PageID = P1.PageID
JOIN Pages P2 ON PV2.PageID = P2.PageID
-- This trick prevents duplicates (A,B) and self-pairs (A,A)
WHERE P1.PageID < P2.PageID
GROUP BY P1.PageURL, P2.PageURL
ORDER BY CoOccurrenceCount DESC;
```

- **Explanation:** This query performs a `self-join` on `Page_Views`. It joins a view (`PV1`) to another view (`PV2`) if they share the same `UserID` and `ViewDate`. The magic is `WHERE P1.PageID < P2.PageID`. This ensures that a pair is only counted once (e.g., 'Page 1' / 'Page 5') and not again as ('Page 5' / 'Page 1'), and also prevents a page from being paired with itself.

**18. The "True" Funnel (Consecutive)**

```sql
SELECT DISTINCT T1.UserID
FROM Page_Views T1
JOIN Pages P1 ON T1.PageID = P1.PageID
-- Join to a second view that happened *after*
JOIN Page_Views T2 ON T1.UserID = T2.UserID AND T2.ViewTimestamp > T1.ViewTimestamp
JOIN Pages P2 ON T2.PageID = P2.PageID
WHERE
    P1.PageType = 'Product'
    AND P2.PageType = 'Cart'
    -- Correlated subquery to check for consecutiveness
    AND T2.ViewTimestamp = (
        SELECT MIN(T3.ViewTimestamp)
        FROM Page_Views T3
        WHERE T3.UserID = T1.UserID
          AND T3.ViewTimestamp > T1.ViewTimestamp
    );
```

- **Explanation:** This is the _brutal_ way to find the "next" event.
  1.  It joins `T1` (a 'Product' view) to `T2` (a 'Cart' view) where `T2` happened _after_ `T1`.
  2.  The `WHERE` clause contains a correlated subquery that says: "The timestamp for `T2` must be _equal_ to the _minimum_ timestamp that is _greater than_ `T1`'s timestamp for that user." This confirms no other click happened in between.

**19. The "Zombie" Cart**

```sql
-- CTE 1: Find the last view time for every user
WITH LastViewPerUser AS (
    SELECT UserID, MAX(ViewTimestamp) AS MaxViewTime
    FROM Page_Views
    GROUP BY UserID
),
-- CTE 2: Find the last EVENT time for every user
LastEventTime AS (
    SELECT PV.UserID, MAX(PV.ViewTimestamp) AS MaxEventTime
    FROM Events E
    JOIN Page_Views PV ON E.ViewID = PV.ViewID
    GROUP BY PV.UserID
)
-- Find users whose last EVENT was 'add_to_cart'
-- AND whose last VIEW was > 6 months ago
SELECT U.UserName
FROM LastViewPerUser LV
JOIN LastEventTime LET ON LV.UserID = LET.UserID
-- Join to find the event that happened at that last event time
JOIN Page_Views PV_Event ON LET.UserID = PV_Event.UserID AND LET.MaxEventTime = PV_Event.ViewTimestamp
JOIN Events E ON PV_Event.ViewID = E.ViewID
JOIN Users U ON LV.UserID = U.UserID
WHERE
    LV.MaxViewTime = LET.MaxEventTime -- The last event was on the last day they visited
    AND E.EventName = 'add_to_cart'
    AND LV.MaxViewTime < DATEADD(month, -6, '2025-11-17');
```

- **Explanation:** This is complex.
  1.  `LastViewPerUser`: Finds the last time each user was seen at all.
  2.  `LastEventTime`: Finds the timestamp of the last _event_ for each user (which may be before their last page view).
  3.  The final query joins these. The `WHERE` clause checks:
      - The last event happened on the same day as the last view (ensuring it _was_ the last event).
      - That event was 'add_to_cart'.
      - The last view time was more than 6 months ago (from the assumed "current date" of 2025-11-17).

**20. Average Session Length**

```sql
-- CTE 1: Find the start and end of each "session" (defined as one user on one day)
WITH SessionBounds AS (
    SELECT
        UserID,
        CAST(ViewTimestamp AS DATE) AS ViewDate,
        MIN(ViewTimestamp) AS SessionStart,
        MAX(ViewTimestamp) AS SessionEnd
    FROM Page_Views
    GROUP BY UserID, CAST(ViewTimestamp AS DATE)
),
-- CTE 2: Calculate the length of each session in seconds
SessionLengths AS (
    SELECT
        DATEDIFF(second, SessionStart, SessionEnd) AS LengthInSeconds
    FROM SessionBounds
    WHERE SessionStart != SessionEnd -- Filter out "bounces" (1-click sessions)
)
-- Final: Calculate the average of all session lengths
SELECT
    AVG(LengthInSeconds * 1.0) AS AvgSessionLength_Seconds
FROM SessionLengths;
```

- **Explanation:** This is the core of "sessionization" by day.
  1.  `SessionBounds`: Groups all views by `UserID` and `ViewDate`. The `MIN` and `MAX` timestamps give the start and end of that day's session.
  2.  `SessionLengths`: Calculates the duration of each session. We filter out rows where `Start = End` because these are 1-click "bounces" with a 0-second duration, which would skew the average.
  3.  The final query calculates a simple `AVG()` of all the valid session lengths.
