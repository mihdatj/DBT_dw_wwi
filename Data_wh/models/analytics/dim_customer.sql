WITH dim_customer__source AS (
    SELECT
        * 
    FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_Customers`
)

, dim_customer__rename AS (
    SELECT
        CustomerID AS Customer_key
        , CustomerName
    FROM dim_customer__source
)

, dim_customer__cast_type AS (
    SELECT 
        Cast(Customer_key AS INTEGER) AS Customer_key
        , Cast(CustomerName AS STRING) AS CustomerName
    FROM dim_customer__rename
)
SELECT
    Customer_key
    , CustomerName
FROM dim_customer__cast_type