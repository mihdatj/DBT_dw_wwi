WITH stg_fact_sales_order__source AS (  
    SELECT 
        * 
    FROM `data-wh-mihdatj1.Wide_World_Importers.Sales-Orders`
)
, stg_fact_sales_order__rename AS (
    SELECT 
        OrderID AS Sales_Order_key
        , CustomerID AS Customer_key
        , PickedByPersonID AS Picked_By_Person_key
        , OrderDate
    FROM stg_fact_sales_order__source
)

, stg_fact_sales_order__cast_type AS (
    SELECT
        Cast( Sales_Order_key AS INTEGER) AS Sales_Order_key
        , Cast(Customer_key AS INTEGER) AS Customer_key
        , SAFE_Cast(Picked_By_Person_key AS INTEGER) AS Picked_By_Person_key
        , Cast(OrderDate AS DATE) AS OrderDate
    FROM stg_fact_sales_order__rename
) 
SELECT
    Sales_Order_key
    , Customer_key
    , Coalesce(Picked_By_Person_key,0) AS Picked_By_Person_key
    , OrderDate
FROM stg_fact_sales_order__cast_type