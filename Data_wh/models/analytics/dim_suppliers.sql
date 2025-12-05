WITH dim_suppliers__source AS (
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Purchasing_Suppliers`
)

, dim_suppliers__rename AS (
    SELECT
        supplier_id AS Supplier_key
        , supplier_name AS Supplier_name
        , supplier_category_id AS Supplier_category_key
        , primary_contact_person_id AS Primary_Contact_Person_key
        , alternate_contact_person_id AS Alternate_Contact_Person_key
        , delivery_method_id AS Delivery_Method_key
        , delivery_city_id AS Delivery_City_key
        , postal_city_id AS Postal_City_key
        , payment_days AS Payment_Days
    FROM dim_suppliers__source
)

, dim_suppliers__cast_type AS (
    SELECT 
        Cast(Supplier_key AS INTEGER) AS Supplier_key
        , Cast(Supplier_name AS STRING) AS Supplier_name
        , Cast(Supplier_category_key AS INTEGER) AS Supplier_category_key
        , Cast(Primary_Contact_Person_key AS INTEGER) AS Primary_Contact_Person_key
        , Cast(Alternate_Contact_Person_key AS INTEGER) AS Alternate_Contact_Person_key
        , Cast(Delivery_Method_key AS INTEGER) AS Delivery_Method_key
        , Cast(Delivery_City_key AS INTEGER) AS Delivery_City_key
        , Cast(Postal_City_key AS INTEGER) AS Postal_City_key
        , Cast(Payment_Days AS INTEGER) AS Payment_Days
    FROM dim_suppliers__rename
)

, dim_product__add_undefined AS (
    SELECT
        Supplier_key
        , Supplier_name
        , Supplier_category_key
        , Primary_Contact_Person_key
        , Alternate_Contact_Person_key
        , Delivery_Method_key
        , Delivery_City_key
        , Postal_City_key
        , Payment_Days
    FROM dim_suppliers__cast_type

    UNION ALL
    SELECT
        0 AS Supplier_key
        , 'Undefind' AS Supplier_name
        , 0 AS Supplier_category_key
        , 0 AS Primary_Contact_Person_key
        , 0 AS Alternate_Contact_Person_key
        , 0 AS Delivery_Method_key
        , 0 AS Delivery_City_key
        , 0 AS Postal_City_key
        , 0 AS Payment_Days

    UNION ALL
    SELECT
        -1 AS Supplier_key
        , 'Invalid' AS Supplier_name
        , -1 AS Supplier_category_key
        , -1 AS Primary_Contact_Person_key
        , -1 AS Alternate_Contact_Person_key
        , -1 AS Delivery_Method_key
        , -1 AS Delivery_City_key
        , -1 AS Postal_City_key
        , -1 AS Payment_Days
)


SELECT 
    dim_product.Supplier_key
    , dim_product.Supplier_name
    , dim_product.Supplier_category_key
    , COALESCE(stg_Supplier_Categories.supplier_category_name,'Invalid') AS Supplier_category_name
    , dim_product.Primary_Contact_Person_key
    , COALESCE(dim_Primary_person.FullName,'Invalid') AS Primary_Contact_full_name
    , dim_product.Alternate_Contact_Person_key
    , COALESCE(dim_Alternate_person.FullName,'Invalid') AS Alternate_Contact_full_name
    , dim_product.Delivery_Method_key
    , stg_dim_Delivery_Method.Delivery_Method_Name
    , dim_product.Delivery_City_key
    , COALESCE(stg_dim_Delivery_cities.City_Name,'Invalid') AS Delivery_City_Name
    , COALESCE(stg_dim_Delivery_cities.State_Province_key,-1) AS Delivery_State_Province_key
    , COALESCE(stg_dim_Delivery_cities.State_Province_Name,'Invalid') AS Delivery_State_Province_Name
    , dim_product.Postal_City_key
    , COALESCE(stg_dim_Postal_cities.City_Name,'Invalid') AS Postal_City_Name
    , COALESCE(stg_dim_Postal_cities.State_Province_key,-1) AS Postal_State_Province_key
    , COALESCE(stg_dim_Postal_cities.State_Province_Name,'Invalid') AS Postal_State_Province_Name
    , dim_product.Payment_Days
FROM dim_product__add_undefined AS dim_product

LEFT JOIN {{ ref("stg_Supplier_Categories")}} AS stg_Supplier_Categories
    ON dim_product.Supplier_category_key = stg_Supplier_Categories.supplier_category_key

LEFT JOIN {{ ref("dim_person")}} AS dim_Primary_person
    ON dim_product.Primary_Contact_Person_key = dim_Primary_person.person_key

LEFT JOIN {{ ref("dim_person")}} AS dim_Alternate_person
    ON dim_product.Alternate_Contact_Person_key = dim_Alternate_person.person_key

LEFT JOIN {{ ref("stg_dim_Delivery_Method")}} AS stg_dim_Delivery_Method
    ON dim_product.Delivery_Method_key = stg_dim_Delivery_Method.Delivery_Method_key

LEFT JOIN {{ ref("stg_dim_cities")}} AS stg_dim_Delivery_cities
    ON dim_product.Delivery_City_key = stg_dim_Delivery_cities.City_key

LEFT JOIN {{ ref("stg_dim_cities")}} AS stg_dim_Postal_cities
    ON dim_product.Postal_City_key = stg_dim_Postal_cities.City_key



