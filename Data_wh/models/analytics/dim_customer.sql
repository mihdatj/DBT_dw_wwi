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
        , PrimaryContactPersonID AS Primary_Contact_Person_key
        , DeliveryMethodID AS Delivery_Method_key
        , DeliveryCityID AS Delivery_City_key
        , CreditLimit
        , AccountOpenedDate
        , StandardDiscountPercentage
        , IsStatementSent
        , IsOnCreditHold AS is_on_credit_hold_BOOLEAN 
        , PaymentDays
    FROM dim_customer__source
)

, dim_customer__cast_type AS (
    SELECT 
        Cast(Customer_key AS INTEGER) AS Customer_key
        , Cast(CustomerName AS STRING) AS CustomerName
        , Cast(CustomerCategory_key AS INTEGER) AS CustomerCategory_key
        , Safe_Cast(BuyingGroup_key AS INTEGER) AS BuyingGroup_key
        , Cast(is_on_credit_hold_BOOLEAN AS BOOLEAN) AS is_on_credit_hold_BOOLEAN
    FROM dim_customer__rename
)

, dim_customer__conver_boolean AS (
    SELECT
        * 
        , CASE
                WHEN is_on_credit_hold_BOOLEAN IS TRUE THEN 'On Credit Hold'
                WHEN is_on_credit_hold_BOOLEAN IS FALSE THEN 'Not On Credit Hold'
                WHEN is_on_credit_hold_BOOLEAN IS NULL THEN 'Undefined'
          ELSE 'Invalid' END
        AS is_on_credit_hold
    FROM dim_customer__cast_type
)

, dim_customer__add_undefined AS (
    SELECT
        Customer_key
        , CustomerName
        , CustomerCategory_key
        , BuyingGroup_key
        , is_on_credit_hold
    FROM dim_customer__conver_boolean

    UNION ALL
    SELECT
        0 AS Customer_key
        , 'Undefined' AS CustomerName
        , 0 AS CustomerCategory_key
        , 0 AS BuyingGroup_key
        , 'Undefined' AS is_on_credit_hold
    
    UNION ALL
    SELECT
        -1 AS Customer_key
        , 'Invalid' AS CustomerName
        , -1 AS CustomerCategory_key
        , -1 AS BuyingGroup_key
        , 'Invalid' AS is_on_credit_hold
)

SELECT
    dim_customer.Customer_key
    , dim_customer.CustomerName
    , dim_customer.CustomerCategory_key
    , Coalesce(stg_customer.CustomerCategory_name, 'Invalid') AS CustomerCategory_name 
    , Coalesce(dim_customer.BuyingGroup_key, 0) AS BuyingGroup_key
    , Coalesce(stg_buying.BuyingGroup_name, 'Invalid') AS BuyingGroup_name 
    , dim_customer.is_on_credit_hold
FROM dim_customer__add_undefined AS dim_customer 

LEFT JOIN {{ ref('stg_customer_categories')}} AS stg_customer
    ON dim_customer.CustomerCategory_key = stg_customer.CustomerCategory_key
LEFT JOIN {{ ref('stg_buying_group')}} AS stg_buying
    ON dim_customer.BuyingGroup_key = stg_buying.BuyingGroup_key