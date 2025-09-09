-- This query is used for retrieving the emails of the top 5 spenders
SELECT customer.email_address, getAmountSpent(order.customerID) AS TotalSpent
FROM customer
RIGHT JOIN `order` ON order.customerID = customer.customerID
GROUP BY customer.email_address
ORDER BY TotalSpent DESC
LIMIT 5;

-- This query finds people who live at the same address and calculates days to birthdays to potentially advertise some birthday gifts for the duration up to the birthday. This is to attempt to drive up purchases from people who have ‘buying a gift’ on their to-do list. 
SELECT DISTINCT getFullName(customer1.customerID) AS customer1Name, customer1.email_address,
       ROUND((getAge(customer2.customerID) / 4) + (365 - (getAge(customer1.customerID) - FLOOR(getAge(customer1.customerID) / 365) * 365))) AS daysToBirthday
FROM customer customer1
INNER JOIN customer customer2 ON customer1.address_id = customer2.address_id
WHERE customer1Name != customer2Name;

-- To find the categories bringing in the most revenue to know what’s important to keep up with in terms of stock and marketing.
-- Easily changed to find the least revenue generating categories by replacing DESC with ASC in ORDER BY clause, for checking what categories of item require attention or would be better dropped altogether.
SELECT SUM(order_items.unit_price) AS totalSpent, category.category_name AS category
FROM order_items
INNER JOIN product ON order_items.productID = product.productID
INNER JOIN category ON product.categoryID = category.categoryID
GROUP BY category
ORDER BY totalSpent DESC;

-- Comparing sales amounts following a price change for tracking whether results are acceptable. The changes in sales values are displayed for each product, laid out this way so as to be easy to read. 
SELECT product.product_name AS product,
       product_history.previous_number_of_purchases AS previousNumberSold,
       SUM(order_items.item_quantity) AS numberSold,
       product_history.product_price AS previousPrice,
       product.product_price AS Price,
       (SUM(order_items.item_quantity) - product_history.previous_number_of_purchases) AS numberSoldChange,
       (product.product_price - product_history.previous_price) AS priceChange
FROM order_items
INNER JOIN product ON (order_items.productID = product.productID)
INNER JOIN product_history ON (product.productID = product_history.productID)
GROUP BY product.product_name;

-- Check levels of stock maintained against amount of stock depletion, to adjust stock levels accordingly. 
-- Stock maintained at a location may be too high for stock being spent and therefore a waste of space and possibly value spent on under-desired products; or too low and risk selling out too easily. 
SELECT address.postcode AS storeLocation,
       store.contact_number AS contactStoreLocation,
       store_items.stock_limit AS maxStock,
       getStockOut(store_items.storeID),
       store_items.productID AS stockSpent,
       product.product_name AS product
FROM store_items
RIGHT JOIN store ON (store_items.storeID = store.storeID)
INNER JOIN address ON (address.address_id = store.address_id)
INNER JOIN product ON (store_items.productID = product.productID)
ORDER BY (SELECT MAX(stockSpent)) DESC;
