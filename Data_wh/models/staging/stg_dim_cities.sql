WITH stg_dim_cities__source AS (
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Application_Cities`
)

, stg_dim_cities__rename AS (
    SELECT
        city_id AS City_key
        , city_name AS City_Name
        , state_province_id AS State_Province_key
    FROM stg_dim_cities__source
)

, stg_dim_cities__cast_type AS (
    SELECT
        Cast(City_key AS INTEGER) AS City_key
        , Cast(City_Name AS STRING) AS City_Name
        , Cast(State_Province_key AS INTEGER) AS State_Province_key
    FROM stg_dim_cities__rename
)

SELECT
    stg_dim_cities.City_key
    , stg_dim_cities.City_Name
    , stg_dim_cities.State_Province_key
    , stg_dim_State_Provinces.State_Province_Code
    , stg_dim_State_Provinces.State_Province_Name
    , stg_dim_State_Provinces.Country_key
    , stg_dim_State_Provinces.Country_Name
FROM stg_dim_cities__cast_type AS stg_dim_cities
LEFT JOIN {{ ref("stg_dim_State_Provinces")}} AS stg_dim_State_Provinces
ON stg_dim_cities.State_Province_key = stg_dim_State_Provinces.State_Province_key
