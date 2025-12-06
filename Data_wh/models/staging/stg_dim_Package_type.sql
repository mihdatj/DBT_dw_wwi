WITH stg_dim_Package_type__Source AS (
    SELECT 
    *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Warehouse_PackageTypes`
)

, stg_dim_Package_type__rename AS (
    SELECT
        package_type_id AS Package_Type_key
        , package_type_name AS Package_Type_Name
    FROM stg_dim_Package_type__Source
)

, stg_dim_Package_type__cast_type AS (  
    SELECT
        Cast(Package_Type_key AS INTEGER) AS Package_Type_key
        , Cast(Package_Type_Name AS STRING) AS Package_Type_Name
    FROM stg_dim_Package_type__rename
)

, stg_dim_Package_type__add_undefined AS (
    SELECT
        Package_Type_key
        , Package_Type_Name
    FROM stg_dim_Package_type__cast_type

    UNION ALL
    SELECT
        0 AS Package_Type_key
        , 'Undefine' AS Package_Type_Name

    UNION ALL
    SELECT
        -1 AS Package_Type_key
        , 'Invalid' AS Package_Type_Name
)

SELECT 
    Package_Type_key
    , Package_Type_Name
FROM stg_dim_Package_type__cast_type