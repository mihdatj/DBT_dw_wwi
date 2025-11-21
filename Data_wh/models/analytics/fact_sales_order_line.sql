WITH fact_sales_order_line__source AS (
  SELECT
    *
  FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_OrderLines`

)
, fact_sales_order_line__rename AS (
  SELECT
    OrderLineID  AS Sales_order_line_id
    , StockItemID  AS Product_key
    , Quantity   
    , UnitPrice  
  FROM fact_sales_order_line__source
)

, fact_sales_order_line__cast_type AS (
  SELECT
  Cast(Sales_order_line_id AS INTEGER) AS Sales_order_line_id
  , Cast(Product_key AS STRING) AS Product_key
  , Cast(Quantity as INTEGER) AS Quantity 
  , Cast(UnitPrice as NUMERIC) AS UnitPrice 
  FROM fact_sales_order_line__rename
)


SELECT
   Sales_order_line_id
  , Product_key
  , Quantity 
  , UnitPrice 
  , Quantity * UnitPrice AS Grossamount
FROM fact_sales_order_line__cast_type