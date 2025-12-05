WITH dim_person__source AS (
    SELECT 
    *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Application_People`
)

, dim_person__rename AS (
    SELECT
        person_id AS person_key
        , full_name 
    FROM dim_person__source
)

, dim_person__cast_type AS (
    SELECT 
        Cast(person_key AS INTEGER) AS person_key
        , Cast(full_name AS STRING) AS FullName
    FROM dim_person__rename
)

, dim_person__union_all AS (
    SELECT 
        person_key
        , FullName
    FROM dim_person__cast_type

    UNION ALL 
    SELECT 
        0 AS person_key
        , 'Undefined' AS FullName
    
    UNION ALL 
    SELECT 
        -1 AS person_key
        , 'Invalid' AS FullName
)

SELECT 
    person_key
    , FullName
FROM dim_person__union_all
