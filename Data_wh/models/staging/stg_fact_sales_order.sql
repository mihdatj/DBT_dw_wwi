WITH stg_fact_sales_order__source AS (  
    SELECT 
        * 
    FROM `data-wh-mihdatj1.Wide_World_Importers.Sales-Orders`
)
, stg_fact_sales_order__rename AS (
    SELECT 
        order_id AS Sales_Order_key
        , customer_id AS Customer_key
        , salesperson_person_id AS Sales_person_person_key
        , picked_by_person_id AS Picked_By_Person_key
        , contact_person_id AS Contact_person_key
        , order_date
        , backorder_order_id AS Back_Order_key
        , expected_delivery_date AS Expected_Delivery_Date
        , is_undersupply_backordered AS Is_Under_supply_Backordered_boolean
        , picking_completed_when AS Order_Picking_Completed_When
    FROM stg_fact_sales_order__source
)

, stg_fact_sales_order__cast_type AS (
    SELECT
        Cast( Sales_Order_key AS INTEGER) AS Sales_Order_key
        , Cast(Customer_key AS INTEGER) AS Customer_key
        , Cast(Sales_person_person_key AS INTEGER) AS Sales_person_person_key
        , SAFE_Cast(Picked_By_Person_key AS NUMERIC) AS Picked_By_Person_key
        , Cast(Contact_person_key AS INTEGER) AS Contact_person_key
        , Cast(order_date AS DATE) AS OrderDate
        , Cast(Back_Order_key AS INTEGER) AS Back_Order_key
        , CAST(Expected_Delivery_Date AS DATE) AS Expected_Delivery_Date
        , CAST(Is_Under_supply_Backordered_boolean AS BOOLEAN) AS Is_Under_supply_Backordered_boolean
        , Cast(Order_Picking_Completed_When AS STRING) AS Order_Picking_Completed_When
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
    stg_fact_sales_order.Sales_Order_key
    , stg_fact_sales_order.Customer_key
    , Coalesce(dim_customer.customer_name,'Invalid') AS Customer_name
    , stg_fact_sales_order.Sales_person_person_key
    , Coalesce(stg_fact_sales_order.Picked_By_Person_key, 0) AS Picked_By_Person_key
    , COALESCE(stg_fact_sales_order.Back_Order_key, 0) AS Back_Order_key
    , stg_fact_sales_order.Contact_person_key
    , stg_fact_sales_order.OrderDate
    , stg_fact_sales_order.Expected_Delivery_Date 
    , stg_fact_sales_order.Is_Under_supply_Backordered
    , stg_fact_sales_order.Order_Picking_Completed_When

FROM stg_fact_sales_order__conver_boolean AS stg_fact_sales_order

LEFT JOIN {{ ref("dim_customer")}} AS dim_customer
    ON stg_fact_sales_order.Customer_key = dim_customer.Customer_key
