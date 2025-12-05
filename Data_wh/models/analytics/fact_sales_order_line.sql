WITH fact_sales_order_line__source AS (
  SELECT
    *
  FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_OrderLines`

)
, fact_sales_order_line__rename AS (
  SELECT
    order_line_id  AS Sales_order_line_key
    , order_id AS Sales_Order_key
    , stock_item_id  AS Product_key
    , package_type_id as Package_Type_key
    , quantity   
    , unit_price  
    , tax_rate
    , picked_quantity
    , picking_completed_when AS line_Picking_Completed_When
  FROM fact_sales_order_line__source
)

, fact_sales_order_line__cast_type AS (
  SELECT
  Cast(Sales_order_line_key AS INTEGER) AS Sales_order_line_key
  , Cast(Sales_Order_key AS INTEGER) AS Sales_Order_key
  , Cast(Product_key AS STRING) AS Product_key
  , Cast( Package_Type_key AS INTEGER) AS Package_Type_key
  , Cast(quantity AS INTEGER) AS Quantity 
  , Cast(unit_price AS NUMERIC) AS UnitPrice 
  , Cast(tax_rate AS NUMERIC) AS Tax_Rate
  , Cast(picked_quantity AS INTEGER) AS Picked_Quantity
  , Cast(line_Picking_Completed_When AS STRING) AS line_Picking_Completed_When
  FROM fact_sales_order_line__rename
)


SELECT
  fact_line.Sales_order_line_key
  , fact_line.Sales_Order_key
  , fact_line.Product_key
  , Coalesce(fact_header.Customer_key, -1) AS Customer_key
  , Coalesce(fact_header.Customer_name, 'Invalid') AS Customer_name
  , fact_line.Package_Type_key
  , Coalesce(stg_dim_Package_type.Package_Type_Name, 'Invalid') AS Package_Type_Name
  , Coalesce(fact_header.Sales_person_person_key, -1) AS Sales_person_person_key
  , Coalesce(fact_header.Picked_By_Person_key, -1) AS Picked_By_Person_key
  , Coalesce(fact_header.Contact_person_key, -1) AS Contact_person_key
  , fact_line.Quantity 
  , fact_line.UnitPrice 
  , fact_line.Quantity * fact_line.UnitPrice  AS Grossamount
  , fact_header.OrderDate
  , fact_line.Tax_Rate
  , fact_line.Picked_Quantity
  , fact_line.line_Picking_Completed_When
  , fact_header.Expected_Delivery_Date
  , fact_header.Is_Under_supply_Backordered
  , fact_header.Order_Picking_Completed_When

FROM fact_sales_order_line__cast_type AS fact_line

LEFT JOIN {{ ref('stg_fact_sales_order')}} AS  fact_header
  ON fact_line.Sales_Order_key = fact_header.Sales_Order_key

LEFT JOIN {{ ref("stg_dim_Package_type")}} AS stg_dim_Package_type
ON fact_line.Package_Type_key = stg_dim_Package_type.Package_Type_key

