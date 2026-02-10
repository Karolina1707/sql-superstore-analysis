-- PL: Analiza Year-over-Year (YoY) – porównanie sprzedaży z tym samym miesiącem rok wcześniej.
-- Zapytanie eliminuje sezonowość i pokazuje długoterminowy trend sprzedaży.
--
-- EN: Year-over-Year (YoY) analysis – comparison of sales with the same month in the previous year.
-- The query removes seasonality and highlights long-term sales trends.

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
CASE
  WHEN LAG(suma_zamowien, 12) OVER (ORDER BY miesiac) IS NULL
       OR LAG(suma_zamowien, 12) OVER (ORDER BY miesiac) = 0
  THEN NULL
  ELSE
    100.0 *
    (suma_zamowien - LAG(suma_zamowien, 12) OVER (ORDER BY miesiac))
    /
    (LAG(suma_zamowien, 12) OVER (ORDER BY miesiac))
END AS yoy_pct
FROM miesiecznie
ORDER BY miesiac;
