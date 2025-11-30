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
        , IsChillerStock AS Is_Chiller_Stock
    FROM dim_product__source
)

, dim_product__cast_type AS(
    SELECT
    Cast(Product_key AS INTEGER) AS Product_key
    , Cast(Supplier_key AS  INTEGER) AS Supplier_key
    , Cast(Product_name AS STRING) AS Product_name
    , Cast(Brand_name AS String) AS Brand_name
    , Cast(Is_Chiller_Stock AS BOOLEAN) AS Is_Chiller_Stock
    FROM dim_product__rename
)

, dim_product__converT_boolean AS(
    SELECT
        Product_key
        , Supplier_key
        , Product_name
        , Brand_name
        , CASE 
            WHEN Is_Chiller_Stock IS TRUE THEN 'Chiller Stock'
            WHEN Is_Chiller_Stock IS FALSE THEN 'Not Chiller Stock'
            WHEN Is_Chiller_Stock IS NULL THEN 'Undefined'
          ELSE 'Invalid' END
          AS Is_Chiller_Stock
    FROM dim_product__cast_type
)

, dim_product__Coalesce AS (
    SELECT
        Product_key
        , Supplier_key
        , Product_name
        , COALESCE(Brand_name, 'Undefined') AS Brand_name
        , Is_Chiller_Stock
    FROM dim_product__converT_boolean
)

, dim_product__add_undefined AS (
    SELECT
        Product_key
        , Supplier_key
        , Product_name
        , Brand_name
        , Is_Chiller_Stock
    FROM dim_product__Coalesce

    UNION ALL
    SELECT
        0 AS Product_key
        , 0 AS Supplier_key
        , 'Undefind' AS Product_name
        , 'Undefind' AS Brand_name
        , 'Undefind' AS Is_Chiller_Stock
    
    UNION ALL
    SELECT
        -1 AS Product_key
        , -1 AS Supplier_key
        , 'Invalid' AS Product_name
        , 'Invalid' AS Brand_name
        , 'Invalid' AS Is_Chiller_Stock
)


SELECT
    dim_product.Product_key
    , dim_product.Product_name
    , dim_product.Supplier_key
    , COALESCE(dim_suppliers.Supplier_name, 'Invalid') AS Supplier_name
    , dim_product.Brand_name
    , dim_product.Is_Chiller_Stock
FROM dim_product__add_undefined AS dim_product
LEFT JOIN {{ ref("dim_suppliers") }} AS dim_suppliers
ON dim_product.Supplier_key = dim_suppliers.Supplier_key