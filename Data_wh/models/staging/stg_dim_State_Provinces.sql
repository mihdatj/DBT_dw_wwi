WITH stg_dim_State_Provinces__source AS (
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Application_StateProvinces`
)


, stg_dim_State_Provinces__rename AS (
    SELECT
        StateProvinceID AS State_Province_key
        , StateProvinceCode AS State_Province_Code
        , StateProvinceName AS State_Province_Name
        , CountryID AS Country_key
    FROM stg_dim_State_Provinces__source
)

, stg_dim_State_Provinces__cast_type AS (
    SELECT
        Cast(State_Province_key AS INTEGER) AS State_Province_key
        , Cast(State_Province_Code AS STRING) AS State_Province_Code
        , Cast(State_Province_Name AS STRING) AS State_Province_Name
        , Cast(Country_key AS INTEGER) AS Country_key
    FROM stg_dim_State_Provinces__rename
)

SELECT
    stg_dim_State_Provinces. State_Province_key
    , stg_dim_State_Provinces.State_Province_Code
    , stg_dim_State_Provinces.State_Province_Name
    , stg_dim_State_Provinces.Country_key
    , stg_dim_countries.Country_Name
FROM stg_dim_State_Provinces__cast_type AS stg_dim_State_Provinces
LEFT JOIN {{ ref("stg_dim_countries")}} AS stg_dim_countries
ON stg_dim_State_Provinces.Country_key = stg_dim_countries.Country_key
