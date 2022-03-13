
/*
    This is a fact table which has details of death and recovery day by day
*/

{{ config(materialized='table') }}

WITH LOC_DETAILS AS
(

    SELECT * FROM {{ ref('location_details') }}
)
SELECT
    DATE,
    LOC.LOCATION_DETAILS_ID,
    TOTAL_DEATHS,
    TOTAL_DEATHS_PER_MILLION,
    NEW_DEATHS,
    NEW_DEATHS_PER_MILLION,
    GROWTH_FACTOR_OF_NEW_DEATHS,
    TOTAL_RECOVERED,
    NEW_RECOVERED,
    CASE_RECOVERED_RATE
FROM "FIVETRAN_INTERVIEW_DB"."GOOGLE_SHEETS"."COVID_19_INDONESIA_ABINAYA_SUBBIAH" SRC LEFT JOIN 
LOC_DETAILS LOC ON 
LOC.LOCATION = SRC.LOCATION AND COALESCE(LOC.PROVINCE,'INDONESIA') = COALESCE(SRC.PROVINCE,'INDONESIA')



