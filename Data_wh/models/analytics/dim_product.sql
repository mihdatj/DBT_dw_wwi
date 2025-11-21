WITH dim_product__source AS (
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Warehouse_StockItems`
)

, dim_product__rename AS(
    SELECT
        StockItemID AS Product_key
        , StockItemName AS Product_name
        , Brand AS Brand_name
    FROM dim_product__source
)

, dim_product__cast_type AS(
    SELECT
    Cast(Product_key AS INTEGER) AS Product_key
    , Cast(Product_name AS STRING) AS Product_name
    , Cast(Brand AS String) AS Brand_name
    FROM dim_product__rename
)

SELECT
   Product_key
  , Product_name
  , Brand_name
FROM dim_product__cast_type