WITH dim_customer__source AS (
    SELECT
        * 
    FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_Customers`
)

, dim_customer__rename AS (
    SELECT
        CustomerID AS Customer_key
        , CustomerName
        , CustomerCategoryID AS CustomerCategory_key
        , BuyingGroupID AS BuyingGroup_key
    FROM dim_customer__source
)

, dim_customer__cast_type AS (
    SELECT 
        Cast(Customer_key AS INTEGER) AS Customer_key
        , Cast(CustomerName AS STRING) AS CustomerName
        , Cast(CustomerCategory_key AS INTEGER) AS CustomerCategory_key
        , Safe_Cast(BuyingGroup_key AS INTEGER) AS BuyingGroup_key
    FROM dim_customer__rename
)
SELECT

    dim_customer.Customer_key
    , dim_customer.CustomerName
    , dim_customer.CustomerCategory_key
    , stg_customer.CustomerCategory_name
    , dim_customer.BuyingGroup_key 
    , stg_buying.BuyingGroup_name

FROM dim_customer__cast_type AS dim_customer 

LEFT JOIN {{ ref('stg_customer_categories')}} AS stg_customer
    ON dim_customer.CustomerCategory_key = stg_customer.CustomerCategory_key
LEFT JOIN {{ ref('stg_buying_group')}} AS stg_buying
    ON dim_customer.BuyingGroup_key = stg_buying.BuyingGroup_key