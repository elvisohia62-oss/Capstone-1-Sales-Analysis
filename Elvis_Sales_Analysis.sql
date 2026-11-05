-- Capstone 1
-- Elvis Sales Analysis
-- Washington Northeast Region


-- What is total revenue overall for sales in the assigned territory, plus the start date and end date
-- that tell you what period the data covers?

SELECT SUM(Sale_Amount) AS Total_Revenue, 
       MIN(Transaction_Date) As Start_Date, 
       MAX(Transaction_Date) AS End_Date
FROM store_sales JOIN store_locations
       ON Store_ID = StoreId
WHERE State = 'Washington';

-- What is the revenue breakdown by year and month for the sales territory?


SELECT
    YEAR(Date) AS Sales_Year,
    MONTH(Date) AS Sales_Month,
    MONTHNAME(Date) AS Month_Name,
    SUM(SalesTotal) AS Monthly_Revenue
FROM Online_Sales
WHERE ShiptoState = 'Washington'
GROUP BY
    YEAR(Date),
    MONTH(Date),
    MONTHNAME(Date)
ORDER BY
    Sales_Year ASC,
    Sales_Month ASC;


 -- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.  


SELECT
    CASE
    WHEN ShiptoState = 'Washington'
    THEN 'Washington Territory'
    ELSE 'Northeast Region'
    END AS Sales_Territory,
    SUM(SalesTotal) AS Total_Revenue
FROM Online_Sales
WHERE ShiptoState IN (
    'Washington',
    'Maryland',
    'Massachusetts',
    'Maine',
    'New Jersey'
)
GROUP BY
    CASE
    WHEN ShiptoState = 'Washington'
    THEN 'Washington Territory'
    ELSE 'Northeast Region'
    END
ORDER BY Total_Revenue DESC;


-- What is the number of transactions per month and average transaction amount by product
-- category for the sales territory?


SELECT
    YEAR(OS.Date) AS Sales_Year,
    MONTH(OS.Date) AS Sales_Month,
    IC.Category AS Product_Category,
    COUNT(*) AS Number_of_Sales_Records,
    AVG(OS.SalesTotal) AS Average_Transaction_Amount
FROM Online_Sales OS
JOIN Products P
    ON OS.ProdNum = P.ProdNum
JOIN Inventory_Categories IC
    ON P.Categoryid = IC.Categoryid
WHERE OS.ShiptoState = 'Washington'
GROUP BY
    YEAR(OS.Date),
    MONTH(OS.Date),
    IC.Category
ORDER BY
    Sales_Year ASC,
    Sales_Month ASC,
    Number_of_Sales_Records DESC;


-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
-- ranking of online sales performance by state within an online sales territory? 


SELECT
    ShiptoState AS State,
    ROUND(SUM(SalesTotal), 2) AS Total_Revenue,
    RANK() OVER (
        ORDER BY SUM(SalesTotal) DESC
    ) AS Sales_Ranking
FROM Online_Sales
GROUP BY ShiptoState
ORDER BY Sales_Ranking;


-- What is your recommendation for where to focus sales attention in the next quarter? 


-- I recommend focusing sales attention on the product categories that generate the highest revenue in Washington. 
-- The sales team should continue promoting strong-performing categories while creating marketing strategies and promotions for categories with lower sales.
-- I would also monitor monthly revenue to identify seasonal trends and use those trends to plan inventory and sales campaigns for the next quarter.