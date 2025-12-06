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

, stg_dim_State_Provinces__add_undefined AS (
    SELECT
        City_key
        , City_Name
        , State_Province_key
    FROM stg_dim_cities__cast_type

    UNION ALL
    SELECT
        0 AS City_key
        , 'Undefine' AS City_Name
        , 0 AS State_Province_key

    UNION ALL
    SELECT
        -1 AS City_key
        , 'Invalid' AS City_Name
        , -1 AS State_Province_key
)

SELECT
    stg_dim_cities.City_key
    , stg_dim_cities.City_Name
    , stg_dim_cities.State_Province_key
    , stg_dim_State_Provinces.State_Province_Name
    
FROM stg_dim_cities__cast_type AS stg_dim_cities

LEFT JOIN {{ref("stg_dim_State_Provinces")}} AS stg_dim_State_Provinces
    ON stg_dim_cities.State_Province_key = stg_dim_State_Provinces.State_Province_key
