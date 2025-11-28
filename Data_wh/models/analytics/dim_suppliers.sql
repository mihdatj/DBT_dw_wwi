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

SELECT 
    Supplier_key
    , Supplier_name
FROM dim_suppliers__cast_type