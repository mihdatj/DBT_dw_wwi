WITH stg_buying_group__source AS(
    SELECT
        *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_BuyingGroups`
)

, stg_buying_group__rename AS (
    SELECT
        BuyingGroupID AS BuyingGroup_key
        , BuyingGroupName AS BuyingGroup_name
    FROM stg_buying_group__source
)

, stg_buying_group__cast_type AS (
    SELECT
        Cast(BuyingGroup_key AS INTEGER) AS BuyingGroup_key
        , Cast(BuyingGroup_name AS STRING) AS BuyingGroup_name
    FROM stg_buying_group__rename
)

SELECT  
    BuyingGroup_key
    ,   BuyingGroup_name
FROM stg_buying_group__cast_type
