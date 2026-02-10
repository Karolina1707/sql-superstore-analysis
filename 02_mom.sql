-- PL: Analiza Month-over-Month (MoM) – procentowa zmiana sprzedaży względem poprzedniego miesiąca.
-- Wykorzystanie funkcji okna LAG() do analizy krótkoterminowych trendów sprzedaży.
--
-- EN: Month-over-Month (MoM) analysis – percentage change in sales compared to the previous month.
-- Uses the LAG() window function to analyze short-term sales trends.
WITH miesiecznie AS (
SELECT strftime('%Y-%m', DataISO) AS miesiac,
COUNT (DISTINCT "Order ID") AS liczba_zamowien,
SUM (Sales) AS suma_zamowien
FROM (
SELECT "Order Date", Sales, "Order ID",
substr("Order Date",  1, 2) AS day,
substr("Order Date",  4, 2) AS month,
substr("Order Date",  7, 4) AS year,
substr("Order Date",  7, 4) || "-" || substr("Order Date",  4, 2) || "-" || substr("Order Date",  1, 2) AS DataISO
FROM superstore
) AS t
GROUP BY miesiac
)
SELECT miesiac, suma_zamowien,
LAG(suma_zamowien) OVER (ORDER BY miesiac) AS prev_sales,
100.0 * (suma_zamowien - LAG(suma_zamowien) OVER (ORDER BY miesiac)) / (LAG(suma_zamowien) OVER (ORDER BY miesiac)) AS mom_pct
FROM miesiecznie
ORDER BY miesiac;
