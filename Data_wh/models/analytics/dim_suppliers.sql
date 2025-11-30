WITH dim_suppliers__source AS (
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Purchasing_Suppliers`
)

, dim_suppliers__rename AS (
    SELECT
        SupplierID AS Supplier_key
        , SupplierName AS Supplier_name
    FROM dim_suppliers__source
)

, dim_suppliers__cast_type AS (
    SELECT 
        Cast(Supplier_key AS INTEGER) AS Supplier_key
        , Cast(Supplier_name AS STRING) AS Supplier_name
    FROM dim_suppliers__rename
)

, dim_product__add_undefined AS (
    SELECT
        Supplier_key
        , Supplier_name
    FROM dim_suppliers__cast_type

    UNION ALL
    SELECT
        0 AS Supplier_key
        , 'Undefind' AS Supplier_name
        
    UNION ALL
    SELECT
        -1 AS Supplier_key
        , 'Invalid' AS Supplier_name
)


SELECT 
    Supplier_key
    , Supplier_name
FROM dim_product__add_undefined