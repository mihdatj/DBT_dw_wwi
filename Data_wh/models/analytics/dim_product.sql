SELECT
  Cast(StockItemID AS INTEGER) AS Product_key
  , Cast(StockItemName AS STRING) AS Product_name
  , Cast(Brand AS String) AS Brand_name
FROM `data-wh-mihdatj1.Wide_World_Importers.Warehouse_StockItems`