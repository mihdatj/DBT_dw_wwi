WITH stg_customer_categories__source AS (
    SELECT 
        * 
    FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_CustomerCategories`
)

, stg_customer_categories__rename AS(
    SELECT
        CustomerCategoryID AS CustomerCategory_key
        , CustomerCategoryName AS CustomerCategory_name
    FROM stg_customer_categories__source
)

, stg_buying_group__cast_type AS (
    SELECT
        Cast(CustomerCategory_key AS INTEGER) AS CustomerCategory_key
        , Cast(CustomerCategory_name AS STRING) AS CustomerCategory_name
    FROM stg_customer_categories__rename
)

SELECT
    CustomerCategory_key
    , CustomerCategory_name
FROM stg_buying_group__cast_type