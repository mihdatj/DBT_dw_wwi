WITH dim_product__source AS (
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Warehouse_StockItems`
)

, dim_product__rename AS(
    SELECT
        stock_item_id AS Product_key
        , supplier_id AS Supplier_key
        , stock_item_name AS Product_name
        , color_id AS Color_key
        , unit_package_id AS Unit_Package_key
        , outer_package_id AS Outer_Package_key
        , brand AS Brand_name
        , size AS Size
        , is_chiller_stock AS Is_Chiller_Stock_boolean
        , tax_rate AS Tax_rate
        , unit_price AS Unit_price
    FROM dim_product__source
)

, dim_product__cast_type AS(
    SELECT
        Cast(Product_key AS INTEGER) AS Product_key
        , Cast(Supplier_key AS  INTEGER) AS Supplier_key
        , Cast(Product_name AS STRING) AS Product_name
        , Cast(Color_key AS NUMERIC) AS Color_key
        , Cast(Unit_Package_key AS INTEGER) AS Unit_Package_key
        , Cast(Outer_Package_key AS INTEGER) AS Outer_Package_key
        , Cast(Brand_name AS String) AS Brand_name
        , Cast(Size as String) AS Size
        , Cast(Is_Chiller_Stock_boolean AS BOOLEAN) AS Is_Chiller_Stock_boolean
        , Cast(Tax_rate AS NUMERIC) AS Tax_rate
        , Cast(Unit_price AS NUMERIC) AS Unit_price
    FROM dim_product__rename
)

, dim_product__converT_boolean AS(
    SELECT
        *
        , CASE 
            WHEN Is_Chiller_Stock_boolean IS TRUE THEN 'Chiller Stock'
            WHEN Is_Chiller_Stock_boolean IS FALSE THEN 'Not Chiller Stock'
            WHEN Is_Chiller_Stock_boolean IS NULL THEN 'Undefined'
          ELSE 'Invalid' END
          AS Is_Chiller_Stock
    FROM dim_product__cast_type
)

, dim_product__add_undefined AS (
    SELECT
        Product_key
        , Supplier_key
        , Product_name
        , Color_key
        , Unit_Package_key
        , Outer_Package_key
        , Brand_name
        , Size
        , Is_Chiller_Stock
        , Tax_rate
        , Unit_price
    FROM dim_product__converT_boolean

    UNION ALL
    SELECT
        0 AS Product_key
        , 0 AS Supplier_key
        , 'Undefind' AS Product_name
        , 0 AS Color_key
        , 0 AS Unit_Package_key
        , 0 AS Outer_Package_key
        , 'Undefind' AS Size
        , 'Undefind' AS Brand_name
        , 'Undefind' AS Is_Chiller_Stock
        , 0 AS Tax_rate
        , 0 AS Unit_price
    
    UNION ALL
    SELECT
        -1 AS Product_key
        , -1 AS Supplier_key
        , 'Invalid' AS Product_name
        , -1 AS Color_key
        , -1 AS Unit_Package_key
        , -1 AS Outer_Package_key
        , 'Invalid' AS Size
        , 'Invalid' AS Brand_name
        , 'Invalid' AS Is_Chiller_Stock
        , -1 AS Tax_rate
        , -1 AS Unit_price
)


SELECT
      
    dim_product.Product_key
    , dim_product.Product_name
    , dim_product.Supplier_key
    , COALESCE(dim_suppliers.Supplier_name, 'Invalid') AS Supplier_name
    , dim_product.Color_key
    , COALESCE(stg_dim_color.Color_name, 'Invalid') AS Color_name
    , dim_product.Unit_Package_key
    , COALESCE(stg_dim_Unit_Package_type.Package_Type_Name, 'Invalid') AS Unit_Package_Type_Name
    , dim_product.Outer_Package_key
    , COALESCE(stg_dim_Outer_Package_type.Package_Type_Name, 'Invalid') AS Outer_Package_Type_Name
    , dim_product.Size
    , COALESCE(dim_product.Brand_name, 'Undefined') AS Brand_name
    , dim_product.Is_Chiller_Stock
    , dim_product.Tax_rate
    , dim_product.Unit_price

FROM dim_product__add_undefined AS dim_product

LEFT JOIN {{ ref("dim_suppliers") }} AS dim_suppliers
    ON dim_product.Supplier_key = dim_suppliers.Supplier_key

LEFT JOIN {{ ref("stg_dim_color")}} AS stg_dim_color
    ON dim_product.Color_key = stg_dim_color.Color_key

LEFT JOIN {{ ref("stg_dim_Package_type")}} AS stg_dim_Unit_Package_type
    ON dim_product.Unit_Package_key = stg_dim_Unit_Package_type.Package_Type_key

LEFT JOIN {{ ref("stg_dim_Package_type")}} AS stg_dim_Outer_Package_type
    ON dim_product.Outer_Package_key = stg_dim_Outer_Package_type.Package_Type_key
