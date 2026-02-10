-- PL: Miesięczna analiza sprzedaży na podstawie danych Superstore.
-- Zapytanie agreguje liczbę zamówień oraz łączną sprzedaż w ujęciu miesięcznym.
-- Stanowi bazę do dalszej analizy trendów (MoM, YoY).
--
-- EN: Monthly sales analysis based on the Superstore dataset.
-- The query aggregates the number of orders and total sales per month.
-- It serves as a base for further time-series analysis (MoM, YoY).

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
ORDER BY miesiac ASC;
