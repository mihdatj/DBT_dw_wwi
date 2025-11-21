SELECT
  Cast(OrderLineID AS INTEGER) AS Sales_order_line_id
  , Cast(StockItemID AS STRING) AS Product_key
  , Cast(Quantity as INTEGER) AS Quantity 
  , Cast(UnitPrice as NUMERIC) AS UnitPrice 
  , Quantity * UnitPrice AS Grossamount
FROM `data-wh-mihdatj1.Wide_World_Importers.Sales_OrderLines`