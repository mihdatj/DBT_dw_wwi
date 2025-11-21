WITH dim_customer__source AS (
    SELECT
        * 
    FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_Customers`
)

, dim_customer__rename AS (
    SELECT
        CustomerID AS Customer_key
    , CustomerName
    from dim_customer__source
)

select
 Customer_key
, CustomerName
from dim_customer__rename