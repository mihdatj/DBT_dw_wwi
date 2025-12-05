WITH stg_customer_categories__source AS (
    SELECT 
        * 
    FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_CustomerCategories`
)

, stg_customer_categories__rename AS(
    SELECT
        customer_category_id AS CustomerCategory_key
        , customer_category_name AS CustomerCategory_name
    FROM stg_customer_categories__source
)

, stg_customer_categories__cast_type AS (
    SELECT
        Cast(CustomerCategory_key AS INTEGER) AS CustomerCategory_key
        , Cast(CustomerCategory_name AS STRING) AS CustomerCategory_name
    FROM stg_customer_categories__rename
)

, stg_customer_categories__add_undefined AS (
    SELECT
        CustomerCategory_key
        , CustomerCategory_name
    FROM stg_customer_categories__cast_type
    
    UNION ALL
    SELECT
        0 AS CustomerCategory_key
        , 'Undefine' AS CustomerCategory_name

    UNION ALL
    SELECT
        -1 AS CustomerCategory_key
        , 'Invalid' AS CustomerCategory_name
)

SELECT
    CustomerCategory_key
    , CustomerCategory_name
FROM stg_customer_categories__add_undefined