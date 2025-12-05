WITH dim_customer__source AS (
    SELECT
        * 
    FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_Customers`
)

, dim_customer__rename AS (
    SELECT
        customer_id AS Customer_key
        , customer_name
        , bill_to_customer_id AS Bill_to_customer_key
        , customer_category_id AS Customer_Category_key
        , buying_group_id AS Buying_Group_key
        , primary_contact_person_id AS Primary_Contact_Person_key
        , delivery_method_id AS Delivery_Method_key
        , delivery_city_id AS Delivery_City_key
        , postal_city_id AS postal_city_key
        , payment_days AS Payment_days
        , credit_limit AS Credit_Limit
        , account_opened_date AS Account_Opened_Date
        , standard_discount_percentage AS Standard_Discount_Percentage
        , is_statement_sent AS is_statement_sent_BOOLEAN
        , is_on_credit_hold AS is_on_credit_hold_BOOLEAN 
    FROM dim_customer__source
)

, dim_customer__cast_type AS (
    SELECT 
        Cast(Customer_key AS INTEGER) AS Customer_key
        , Cast(customer_name AS STRING) AS customer_name
        , Cast(Bill_to_customer_key AS INTEGER) AS Bill_to_customer_key
        , Cast(Customer_Category_key AS INTEGER) AS Customer_Category_key
        , Safe_Cast(Buying_Group_key AS INTEGER) AS Buying_Group_key
        , Cast(Primary_Contact_Person_key AS INTEGER) AS Primary_Contact_Person_key
        , CAST(Delivery_Method_key AS INTEGER) AS Delivery_Method_key
        , CAST(Delivery_City_key AS INTEGER) AS Delivery_City_key
        , Cast(postal_city_key AS INTEGER) AS Postal_City_key
        , Cast(Payment_days AS INTEGER) AS Payment_days
        , CAST(Credit_Limit AS INTEGER) AS Credit_Limit
        , CAST(Account_Opened_Date AS TIMESTAMP) AS Account_Opened_Date
        , CAST(Standard_Discount_Percentage AS NUMERIC) AS Standard_Discount_Percentage
        , Cast(is_statement_sent_BOOLEAN AS BOOLEAN) AS is_statement_sent_BOOLEAN
        , Cast(is_on_credit_hold_BOOLEAN AS BOOLEAN) AS is_on_credit_hold_BOOLEAN
    FROM dim_customer__rename
)

, dim_customer__conver_boolean AS (
    SELECT
        * 
        , CASE
            WHEN is_statement_sent_BOOLEAN IS TRUE THEN 'Statement Sent'
            WHEN is_statement_sent_BOOLEAN IS FALSE THEN 'Not Statement Sent'
            WHEN is_statement_sent_BOOLEAN IS NULL THEN 'Undefined'
            ELSE 'Invalid' END 
        AS is_statement_sent

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
        , customer_name
        , Bill_to_customer_key
        , Customer_Category_key
        , Buying_Group_key
        , Primary_Contact_Person_key
        , Delivery_Method_key
        , Delivery_City_key
        , Postal_City_key
        , Payment_days
        , Credit_Limit
        , Account_Opened_Date
        , Standard_Discount_Percentage
        , is_statement_sent
        , is_on_credit_hold
    FROM dim_customer__conver_boolean

    UNION ALL
    SELECT
        0 AS Customer_key
        , 'Undefined' AS customer_name
        , 0 AS Bill_to_customer_key
        , 0 AS CustomerCategory_key
        , 0 AS BuyingGroup_key
        , 0 AS Primary_Contact_Person_key
        , 0 AS Delivery_Method_key
        , 0 AS Delivery_City_key
        , 0 AS Postal_City_key
        , 0 AS Payment_days
        , 0 AS Credit_Limit
        , CURRENT_TIMESTAMP() ASAccount_Opened_Date
        , 0 AS Standard_Discount_Percentage
        , 'Undefined' AS is_statement_sent
        , 'Undefined' AS is_on_credit_hold
    
    UNION ALL
    SELECT
        -1 AS Customer_key
        , 'Invalid' AS customer_name
        , -1 AS Bill_to_customer_key
        , -1 AS CustomerCategory_key
        , -1 AS BuyingGroup_key
        , -1 AS Primary_Contact_Person_key
        , -1 AS Delivery_Method_key
        , -1 AS Delivery_City_key
        , -1 AS Postal_City_key
        , -1 AS Payment_days
        , -1 AS Credit_Limit
        , CURRENT_TIMESTAMP() ASAccount_Opened_Date
        , -1 AS Standard_Discount_Percentage
        , 'Invalid' AS is_statement_sent
        , 'Invalid' AS is_on_credit_hold
)

SELECT

    dim_customer.Customer_key
    , dim_customer.customer_name
    , dim_customer.Bill_to_customer_key
    , Coalesce(dim_Bill_to_customer.customer_name, 'Invalid') AS Bill_to_customer_name
    , dim_customer.Customer_Category_key
    , Coalesce(stg_customer.CustomerCategory_name, 'Invalid') AS CustomerCategory_name 
    , Coalesce(dim_customer.Buying_Group_key, 0) AS Buying_Group_key
    , Coalesce(stg_buying.BuyingGroup_name, 'Invalid') AS BuyingGroup_name 
    , dim_customer.Primary_Contact_Person_key
    , dim_customer.Delivery_Method_key
    , stg_dim_Delivery_Method.Delivery_Method_Name
    , dim_customer.Delivery_City_key
    , Coalesce(stg_dim_Delivery_cities.City_Name, 'Invalid') AS Delivery_City_name
    , Coalesce(stg_dim_Delivery_cities.State_Province_key, 0) AS Delivery_StateProvince_key
    , Coalesce(stg_dim_Delivery_cities.State_Province_Name, 'Invalid') AS Delivery_StateProvince_name
    , dim_customer.Postal_City_key
    , Coalesce(stg_dim_Postal_cities.City_Name, 'Invalid') AS PostalCity
    , Coalesce(stg_dim_Postal_cities.State_Province_key, 0) AS Postal_StateProvince_key
    , Coalesce(stg_dim_Postal_cities.State_Province_Name, 'Invalid') AS Postal_StateProvince_name
    , dim_customer.Payment_days
    , dim_customer.Credit_Limit
    , dim_customer.Account_Opened_Date
    , dim_customer.Standard_Discount_Percentage
    , dim_customer.is_statement_sent
    , dim_customer.is_on_credit_hold

FROM dim_customer__add_undefined AS dim_customer 

LEFT JOIN {{ ref('stg_customer_categories')}} AS stg_customer
    ON dim_customer.Customer_Category_key = stg_customer.CustomerCategory_key

LEFT JOIN {{ ref('stg_buying_group')}} AS stg_buying
    ON dim_customer.Buying_Group_key = stg_buying.BuyingGroup_key

LEFT JOIN {{ ref("stg_dim_Delivery_Method")}} AS stg_dim_Delivery_Method
    On dim_customer.Delivery_Method_key = stg_dim_Delivery_Method.Delivery_Method_key

LEFT JOIN {{ ref("stg_dim_cities")}} AS stg_dim_Delivery_cities
    ON dim_customer.Delivery_City_key = stg_dim_Delivery_cities.City_key

LEFT JOIN {{ ref("stg_dim_cities")}} AS stg_dim_Postal_cities
    ON dim_customer.Postal_City_key = stg_dim_Postal_cities.City_key

LEFT JOIN dim_customer__add_undefined AS dim_Bill_to_customer
    ON dim_customer.Bill_to_customer_key = dim_Bill_to_customer.Customer_key