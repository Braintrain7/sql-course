/*
A comparison of CTEs vs table subqueries vs temp tables
*/

-- Temp tables
DROP TABLE IF EXISTS #PatientsByDate;

SELECT
    ps.AdmittedDate    
    , COUNT(*) AS NumberOfPatientsEachDay
    , SUM(ps.Tariff) AS TotalTariffEachDay
INTO #PatientsByDate
FROM PatientStay ps
GROUP BY ps.AdmittedDate;

--SELECT * FROM #PatientsByDate

SELECT
    pbd.AdmittedDate
    , pbd.NumberOfPatientsEachDay
    , pbd.TotalTariffEachDay
    , SUM(pbd.TotalTariffEachDay) OVER (ORDER BY pbd.AdmittedDate) AS RunningTariff
    , SUM(pbd.NumberOfPatientsEachDay) OVER (ORDER BY pbd.AdmittedDate) AS CumulativePatients
FROM #PatientsByDate pbd
ORDER BY pbd.AdmittedDate;

-- Table subqueries

SELECT
    pbd.AdmittedDate
    , pbd.NumberOfPatientsEachDay
    , pbd.TotalTariffEachDay
    , SUM(pbd.TotalTariffEachDay) OVER (ORDER BY pbd.AdmittedDate) AS RunningTariff
    , SUM(pbd.NumberOfPatientsEachDay) OVER (ORDER BY pbd.AdmittedDate) AS CumulativePatients
FROM
    (SELECT
        ps.AdmittedDate    
     , COUNT(*) AS NumberOfPatientsEachDay
     , SUM(ps.Tariff) AS TotalTariffEachDay
    FROM PatientStay ps
    GROUP BY ps.AdmittedDate) AS pbd


-- CTEs

;WITH
    cte
    AS
    (
        SELECT
            ps.AdmittedDate    
            , COUNT(*) AS NumberOfPatientsEachDay
            , SUM(ps.Tariff) AS TotalTariffEachDay
        FROM PatientStay ps
        GROUP BY ps.AdmittedDate

    )
SELECT
    cte.AdmittedDate
    , cte.NumberOfPatientsEachDay
    , cte.TotalTariffEachDay
    , SUM(cte.TotalTariffEachDay) OVER (ORDER BY cte.AdmittedDate) AS RunningTariff
    , SUM(cte.NumberOfPatientsEachDay) OVER (ORDER BY cte.AdmittedDate) AS CumulativePatients
FROM cte
ORDER BY cte.AdmittedDate;

--CTE2
;WITH
    cte (AdmittedDate, NumberOfPatientsEachDay, TotalTariffEachDay)
    AS
    (
        SELECT
            ps.AdmittedDate    
            , COUNT(*) --AS NumberOfPatientsEachDay
            , SUM(ps.Tariff)--AS TotalTariffEachDay
        FROM PatientStay ps
        GROUP BY ps.AdmittedDate

    )
SELECT
    cte.AdmittedDate
    , cte.NumberOfPatientsEachDay
    , cte.TotalTariffEachDay
    , SUM(cte.TotalTariffEachDay) OVER (ORDER BY cte.AdmittedDate) AS RunningTariff
    , SUM(cte.NumberOfPatientsEachDay) OVER (ORDER BY cte.AdmittedDate) AS CumulativePatients
FROM cte
ORDER BY cte.AdmittedDate;

---CTE2 MORE STEPS
;WITH
    cte
    AS
    (
        SELECT
            ps.AdmittedDate    
            , COUNT(*) AS NumberOfPatientsEachDay
            , SUM(ps.Tariff) AS TotalTariffEachDay
        FROM PatientStay ps
        GROUP BY ps.AdmittedDate

    ),
    CTE2
    AS
    (
        SELECT *
        FROM CTE
    )
SELECT
    cte2.AdmittedDate
    , cte2.NumberOfPatientsEachDay
    , cte2.TotalTariffEachDay
    , SUM(cte2.TotalTariffEachDay) OVER (ORDER BY cte2.AdmittedDate) AS RunningTariff
    , SUM(cte2.NumberOfPatientsEachDay) OVER (ORDER BY cte2.AdmittedDate) AS CumulativePatients
FROM cte2
ORDER BY cte2.AdmittedDate;



--MW EXAMPLE 

;WITH
    cte
    AS
    (
        SELECT
            ps.AdmittedDate    
            , COUNT(*) AS NumberOfPatientsEachDay
            , SUM(ps.Tariff) AS TotalTariffEachDay
        FROM PatientStay ps
        GROUP BY ps.AdmittedDate
    ),
    cte2
    AS
    (
        select *
        from cte
    )
SELECT
    cte2.AdmittedDate    
    , cte2.NumberOfPatientsEachDay
    , cte2.TotalTariffEachDay
    , SUM(cte2.TotalTariffEachDay) OVER (ORDER BY cte2.AdmittedDate) AS RunningTariff
    , SUM(cte2.NumberOfPatientsEachDay) OVER (ORDER BY cte2.AdmittedDate) AS CumulativePatients
FROM cte2
where cte2.AdmittedDate >= '2024-03-01'
ORDER BY cte2.AdmittedDate
 