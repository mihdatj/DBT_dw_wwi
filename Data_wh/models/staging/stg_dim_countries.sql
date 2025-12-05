WITH stg_dim_countries__source AS (
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Application_Countries`
)

, stg_dim_countries__rename AS (
    SELECT
        country_id AS Country_key
        , country_name AS Country_Name
    FROM stg_dim_countries__source
)

, stg_dim_countries__cast_type AS (
    SELECT
        Cast(Country_key AS INTEGER) AS Country_key
        , Cast(Country_Name AS STRING) AS Country_Name
    FROM stg_dim_countries__rename
)

SELECT 
    Country_key
    , Country_Name
FROM stg_dim_countries__cast_type

