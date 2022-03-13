

-- This is a cummulative view which shows details of active cases, death and recovery rates along with cumulatives of few columns

{{ config(materialized='view') }}
WITH AC_DETAILS AS
(

    SELECT * FROM {{ ref('active_cases') }}
),
DRD_DETAILS AS
(

    SELECT * FROM {{ ref('death_recovery_details') }}
)

select 
    AC.DATE,
    AC.LOCATION_DETAILS_ID,
    AC.TOTAL_CASES,
    AC.TOTAL_ACTIVE_CASES,
    AC.TOTAL_CASES_PER_MILLION,
    AC.NEW_CASES,
    AC.NEW_ACTIVE_CASES,
    AC.NEW_CASES_PER_MILLION,
    AC.CASE_FATALITY_RATE,
    AC.GROWTH_FACTOR_OF_NEW_CASES,
    DRD.TOTAL_DEATHS,
    DRD.TOTAL_DEATHS_PER_MILLION,
    DRD.NEW_DEATHS,
    DRD.NEW_DEATHS_PER_MILLION,
    DRD.GROWTH_FACTOR_OF_NEW_DEATHS,
    DRD.TOTAL_RECOVERED,
    DRD.NEW_RECOVERED,
    DRD.CASE_RECOVERED_RATE,
    SUM(AC.NEW_CASES) OVER (PARTITION BY AC.LOCATION_DETAILS_ID ORDER BY AC.DATE ASC) AS CUMULATION_NEW_CASES,
    SUM(AC.NEW_ACTIVE_CASES) OVER (PARTITION BY AC.LOCATION_DETAILS_ID ORDER BY AC.DATE ASC) AS CUMULATION_NEW_ACTIVE_CASES,
    SUM(DRD.NEW_DEATHS) OVER (PARTITION BY DRD.LOCATION_DETAILS_ID ORDER BY DRD.DATE ASC) AS CUMULATION_NEW_DEATHS,
    SUM(DRD.NEW_RECOVERED) OVER (PARTITION BY DRD.LOCATION_DETAILS_ID ORDER BY DRD.DATE ASC) AS CUMULATION_NEW_RECOVERED  
from 
AC_DETAILS AC LEFT JOIN
DRD_DETAILS DRD ON AC.DATE = DRD.DATE AND AC.LOCATION_DETAILS_ID = DRD.LOCATION_DETAILS_ID
ORDER BY AC.LOCATION_DETAILS_ID, AC.DATE
