WITH fact_sales_order_line__source AS (
  SELECT
    *
  FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_OrderLines`

)
, fact_sales_order_line__rename AS (
  SELECT
    OrderLineID  AS Sales_order_line_key
    , OrderID AS Sales_Order_key
    , StockItemID  AS Product_key
    , Quantity   
    , UnitPrice  
  FROM fact_sales_order_line__source
)

, fact_sales_order_line__cast_type AS (
  SELECT
  Cast(Sales_order_line_key AS INTEGER) AS Sales_order_line_key
  , Cast(Sales_Order_key AS INTEGER) AS Sales_Order_key
  , Cast(Product_key AS STRING) AS Product_key
  , Cast(Quantity AS INTEGER) AS Quantity 
  , Cast(UnitPrice AS NUMERIC) AS UnitPrice 
  FROM fact_sales_order_line__rename
)


SELECT
  fact_line.Sales_order_line_key
  , fact_line.Sales_Order_key
  , fact_line.Product_key
  , Coalesce(fact_header.Customer_key, -1) AS Customer_key
  , fact_line.Quantity 
  , fact_line.UnitPrice 
  , fact_line.Quantity * fact_line.UnitPrice  AS Grossamount
  , Coalesce(fact_header.Picked_By_Person_key, -1) AS Picked_By_Person_key
  , fact_header.OrderDate
FROM fact_sales_order_line__cast_type AS fact_line
LEFT JOIN {{ ref('stg_fact_sales_order')}} AS  fact_header
ON fact_line.Sales_Order_key = fact_header.Sales_Order_key