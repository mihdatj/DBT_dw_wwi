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
        , BackorderOrderID AS Back_Order_key
        , ExpectedDeliveryDate AS Expected_Delivery_Date
        , IsUndersupplyBackordered AS Is_Under_supply_Backordered_boolean
    FROM stg_fact_sales_order__source
)

, stg_fact_sales_order__cast_type AS (
    SELECT
        Cast( Sales_Order_key AS INTEGER) AS Sales_Order_key
        , Cast(Customer_key AS INTEGER) AS Customer_key
        , SAFE_Cast(Picked_By_Person_key AS INTEGER) AS Picked_By_Person_key
        , Cast(OrderDate AS DATE) AS OrderDate
        , Cast(Back_Order_key AS INTEGER) AS Back_Order_key
        , CAST(Expected_Delivery_Date AS DATE) AS Expected_Delivery_Date
        , CAST(Is_Under_supply_Backordered_boolean AS BOOLEAN) AS Is_Under_supply_Backordered_boolean
    FROM stg_fact_sales_order__rename
) 

, stg_fact_sales_order__conver_boolean AS (
    SELECT
        *
        , CASE
            WHEN Is_Under_supply_Backordered_boolean IS TRUE THEN 'Under Supply Backordered'
            WHEN Is_Under_supply_Backordered_boolean IS FALSE THEN 'NOT Under Supply Backordered'
            WHEN Is_Under_supply_Backordered_boolean IS NULL THEN 'Undefined'
        ELSE 'Invalid' END AS Is_Under_supply_Backordered
    FROM stg_fact_sales_order__cast_type
)

SELECT
    Sales_Order_key
    , Customer_key
    , Coalesce(Picked_By_Person_key, 0) AS Picked_By_Person_key
    , COALESCE(Back_Order_key, 0) AS Back_Order_key
    , OrderDate
    , Expected_Delivery_Date 
    , Is_Under_supply_Backordered_boolean
FROM stg_fact_sales_order__conver_boolean