-- PL: Analiza sprzedaży oraz średniej wartości zamówienia (AOV) dla kategorii i podkategorii.
-- Dane są agregowane do poziomu zamówienia, aby poprawnie obliczyć AOV.
--
-- EN: Sales and Average Order Value (AOV) analysis by category and sub-category.
-- Data is aggregated at the order level to ensure correct AOV calculation.
WITH wartosc_pozycji AS (
SELECT Category AS kategoria,
"Sub-Category" AS subkategoria,
"Order ID" AS numer_zamowienia,
SUM (Sales) AS wartosc_zamowienia
FROM superstore
GROUP BY "Order ID", Category, "Sub-Category"
)
SELECT kategoria, subkategoria,
COUNT(*) AS orders_n,
SUM (wartosc_zamowienia) AS total_sales,
AVG(wartosc_zamowienia) AS avg_order_value
FROM wartosc_pozycji
GROUP BY kategoria, subkategoria
ORDER BY total_sales DESC;
