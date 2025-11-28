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

SELECT
    CustomerCategory_key
    , CustomerCategory_name
FROM stg_customer_categories__rename