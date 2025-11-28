WITH dim_person__source AS (
    SELECT 
    *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Application_People`
)

, dim_person__rename AS (
    SELECT
        PersonID AS person_key
        , FullName 
    FROM dim_person__source
)

, dim_person__cast_type AS (
    SELECT 
        Cast(person_key AS INTEGER) AS person_key
        , Cast(FullName AS STRING) AS FullName
    FROM dim_person__rename
)

SELECT 
    person_key
    , FullName
FROM dim_person__cast_type