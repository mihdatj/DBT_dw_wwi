WITH stg_dim_State_Provinces__source AS (
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Application_StateProvinces`
)


, stg_dim_State_Provinces__rename AS (
    SELECT
        state_province_id AS State_Province_key
        , state_province_code AS State_Province_Code
        , state_province_name AS State_Province_Name
    FROM stg_dim_State_Provinces__source
)

, stg_dim_State_Provinces__cast_type AS (
    SELECT
        Cast(State_Province_key AS INTEGER) AS State_Province_key
        , Cast(State_Province_Code AS STRING) AS State_Province_Code
        , Cast(State_Province_Name AS STRING) AS State_Province_Name 
    FROM stg_dim_State_Provinces__rename
)

, stg_dim_State_Provinces__add_undefined AS (
    SELECT
        State_Province_key
        , State_Province_Code
        , State_Province_Name
    FROM stg_dim_State_Provinces__cast_type

    UNION ALL
    SELECT
        0 AS State_Province_key
        , 'Undefine' AS State_Province_Code
        , 'Undefine' AS State_Province_Name

    UNION ALL
    SELECT
        -1 AS State_Province_key
        , 'Invalid' AS State_Province_Code
        , 'Invalid' AS State_Province_Name
)
SELECT
    State_Province_key
    , State_Province_Code
    , State_Province_Name
FROM stg_dim_State_Provinces__add_undefined 

