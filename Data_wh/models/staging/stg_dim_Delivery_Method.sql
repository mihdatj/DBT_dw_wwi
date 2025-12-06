WITH stg_dim_Delivery_Method__source AS (
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Application_DeliveryMethods`
)

, stg_dim_Delivery_Method__rename AS( 
    SELECT
        delivery_method_id AS Delivery_Method_key
        , delivery_method_name AS Delivery_Method_Name
    FROM stg_dim_Delivery_Method__source
)

, stg_dim_Delivery_Method__cast_type AS (
    SELECT 
        Cast(Delivery_Method_key AS INTEGER) AS Delivery_Method_key
        , Cast(Delivery_Method_Name AS STRING) AS Delivery_Method_Name
    FROM stg_dim_Delivery_Method__rename
)

, stg_dim_Delivery_Method__add_undefined AS (
    SELECT
        Delivery_Method_key
        , Delivery_Method_Name
    FROM stg_dim_Delivery_Method__cast_type

    UNION ALL
    SELECT
        0 AS Delivery_Method_key
        , 'Undefine' AS Delivery_Method_Name

    UNION ALL
    SELECT
        -1 AS Delivery_Method_key
        , 'Invalid' AS Delivery_Method_Name
)

SELECT
    Delivery_Method_key
    , Delivery_Method_Name
FROM stg_dim_Delivery_Method__cast_type

