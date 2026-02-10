-- PL: Top 3 podkategorie w każdej kategorii według wartości sprzedaży.
-- Wykorzystanie funkcji okna ROW_NUMBER() do tworzenia rankingu w obrębie kategorii.
--
-- EN: Top 3 sub-categories within each category based on total sales.
-- Uses the ROW_NUMBER() window function to rank results within each category.
WITH wartosc_pozycji AS (
SELECT Category AS kategoria,
"Sub-Category" AS subkategoria,
"Order ID" AS numer_zamowienia,
SUM (Sales) AS wartosc_zamowienia
FROM superstore
GROUP BY "Order ID", Category, "Sub-Category"
), 
agg AS (
SELECT kategoria, subkategoria,
COUNT(*) AS orders_n,
SUM (wartosc_zamowienia) AS total_sales,
AVG(wartosc_zamowienia) AS avg_order_value
FROM wartosc_pozycji
GROUP BY kategoria, subkategoria
),
ranked AS (
SELECT *, 
ROW_NUMBER() OVER ( 
PARTITION BY kategoria 
ORDER BY total_sales DESC 
) AS rnk 
FROM agg
)
SELECt *
FROM ranked
WHERE rnk <= 3 
ORDER BY kategoria, rnk;
