WITH dim_product__source AS (
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Warehouse_StockItems`
)

, dim_product__rename AS(
    SELECT
        StockItemID AS Product_key
        , SupplierId AS Supplier_key
        , StockItemName AS Product_name
        , Brand AS Brand_name
    FROM dim_product__source
)

, dim_product__cast_type AS(
    SELECT
    Cast(Product_key AS INTEGER) AS Product_key
    , Cast(Supplier_key AS  INTEGER) AS Supplier_key
    , Cast(Product_name AS STRING) AS Product_name
    , Cast(Brand_name AS String) AS Brand_name
    FROM dim_product__rename
)

SELECT
    dim_product.Product_key
    , dim_product.Supplier_key
    , dim_product.Product_name
    , dim_product.Brand_name
FROM dim_product__cast_type AS dim_product
LEFT JOIN {{ ref("dim_suppliers") }} AS dim_suppliers
ON dim_product.Supplier_key = dim_suppliers.Supplier_key