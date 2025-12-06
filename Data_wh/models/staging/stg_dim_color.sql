WITH stg_dim_color__source AS (
    SELECT 
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Warehouse_Colors`
)

, stg_dim_color__rename AS (
    SELECT
        color_id AS Color_key
        , color_name AS Color_name
    FROM stg_dim_color__source
)

, stg_dim_color__cast_type AS (
    SELECT
    Cast(Color_key AS INTEGER) AS Color_key
    , Cast(Color_name AS String) AS Color_name
    FROM stg_dim_color__rename
)

, stg_dim_color__add_undefined AS (
    SELECT
        Color_key
        , Color_name
    FROM stg_dim_color__cast_type

    UNION ALL
    SELECT
        0 AS Color_key
        , 'Undefine' AS Color_name

    UNION ALL
    SELECT
        -1 AS Color_key
        , 'Invalid' AS Color_name
)

SELECT
    Color_key
    , Color_name
FROM stg_dim_color__cast_type