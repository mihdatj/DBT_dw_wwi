WITH stg_Supplier_Categories__source AS (
    SELECT
        * 
    FROM `data-wh-mihdatj1.Wide_World_Importers.Purchasing_SupplierCategorie`
)

, stg_Supplier_Categories__rename AS (
    SELECT
        supplier_category_id AS supplier_category_key
        , supplier_category_name
    FROM stg_Supplier_Categories__source
)

, stg_Supplier_Categories__cast_type AS (
    SELECT
        Cast(supplier_category_key AS INTEGER) AS supplier_category_key
        , Cast(supplier_category_name AS String) AS supplier_category_name
    FROM stg_Supplier_Categories__rename
)

, stg_Supplier_Categories__add_undefined AS (
    SELECT
        supplier_category_key
        , supplier_category_name
    FROM stg_Supplier_Categories__cast_type

    UNION ALL
    SELECT
        0 AS supplier_category_key
        , 'Undefine' AS State_Province_Code

    UNION ALL
    SELECT
        -1 AS supplier_category_key
        , 'Invalid' AS supplier_category_name
)

SELECT
    supplier_category_key
    , supplier_category_name
FROM stg_Supplier_Categories__add_undefined