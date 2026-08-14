# Magist Project – Business Analysis

use magist;

## In Relation to the Products
-- 1. What categories of tech products does Magist have?

SELECT DISTINCT product_category_name_english AS Tech_Products
FROM product_category_name_translation
WHERE product_category_name_english IN 
	(
    'audio',
    'consoles_games',
    'electronics',
    'computers_accessories',
    'pc_gamer',
    'computers',
    'tablets_printing_image',
    'telephony'
    );
    
    # The tech categories are: Audio, Consoles & Games, Electronics, Computer Accessories, PC Gamer, Tablets & Printing and Telephony
    
    
   -- 2. How many products of these tech categories have been sold?
   
   SELECT
    COUNT(oi.order_item_id) AS total_products_sold, SUM(CASE
	WHEN pt.product_category_name_english IN (
                'audio',
                'consoles_games',
                'electronics',
                'computers_accessories',
                'pc_gamer',
                'computers',
                'tablets_printing_image',
                'telephony')
	THEN 1
	ELSE 0
	END) AS tech_products_sold,
    ROUND(100.0 * SUM(CASE	WHEN pt.product_category_name_english IN (
                    'audio',
                    'consoles_games',
                    'electronics',
                    'computers_accessories',
                    'pc_gamer',
                    'computers',
                    'tablets_printing_image',
                    'telephony')
                    THEN 1
                    ELSE 0
                    END) / COUNT(oi.order_item_id), 2) AS tech_percentage
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pt
    ON p.product_category_name = pt.product_category_name;
    
    # There are a total of 112650 products being sold. 16935 of them are tech products, which is about 15% of the total.

-- 3. What’s the average price of the products being sold?

SELECT ROUND(AVG(price), 2) AS Average_Price
FROM order_items;

# The average price of the products being sold is 120.65€


-- 4. Are expensive tech products popular?

# Find out how many categories we have

SELECT
  COUNT(product_category_name)
FROM product_category_name_translation;

# There are 74 product categories. 8 of these are marked as Tech products, meaning 66 are Non-Tech.

# Finding out how many items are sold per category to have a realtion between them

SELECT
    product_category_name_translation.product_category_name_english AS category,
    COUNT(*) AS items_sold,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percent_of_all_sales

FROM products

JOIN product_category_name_translation
    ON products.product_category_name
       = product_category_name_translation.product_category_name

JOIN order_items
    ON products.product_id = order_items.product_id

GROUP BY product_category_name_translation.product_category_name_english

ORDER BY items_sold DESC;

# We can see, Bed & Bath, Health & Beauty, Sports & Leisure, Furniture & Decor is sold very well.
# Closely followed already by Computers Accessories with 7827 items sold.
# Also close behind with Telefony 4545 items sold.
# Electronics further below with 2767 items sold
# Comupters has only 203 items sold
# PC Gamer  with only 9 sales
# Conclusion 1: hardware in  computers which are specialized for gamers are have bad sales
# Conclusion 2: Computer Accessories are have the best sales out of the Tech Products, which could be good for us. 
# Conclusion 3: also Telephony works well, also good for us.
# Conclusion 4: Electronics works fine at least.
# Conclusion 5: for some product categories might be good, for others, especially more specialized products, bad

# A conclusion of categories in main categories to see, if main tech category has a higher rank than other categories

WITH classified_sales AS (

    SELECT
        product_category_name_translation.product_category_name_english AS original_category,
        order_items.price,

        CASE
            -- Eniac-relevant Tech
            WHEN product_category_name_english IN (
                'computers',
                'pc_gamer',
                'computers_accessories',
                'electronics',
                'telephony'
            )
            THEN 'Tech'

            -- Elektronik / Medien, aber NICHT unsere Eniac-Tech-Definition
            WHEN product_category_name_english IN (
                'audio',
                'consoles_games',
                'fixed_telephony',
                'tablets_printing_image',
                'cine_photo',
                'cds_dvds_musicals',
                'dvds_blu_ray',
                'music',
                'musical_instruments'
            )
            THEN 'Electronics & Media'

            -- Wohnen / Möbel
            WHEN product_category_name_english IN (
                'bed_bath_table',
                'home_comfort',
                'home_comfort_2',
                'home_construction',
                'furniture_mattress_and_upholstery',
                'kitchen_dining_laundry_garden_furniture',
                'furniture_decor',
                'office_furniture',
                'furniture_bedroom',
                'furniture_living_room',
                'housewares',
                'la_cuisine',
                'flowers'
            )
            THEN 'Home & Furniture'

            -- Haushaltsgeräte
            WHEN product_category_name_english IN (
                'home_appliances',
                'home_appliances_2',
                'small_appliances',
                'small_appliances_home_oven_and_coffee',
                'portable_kitchen_food_processors',
                'air_conditioning'
            )
            THEN 'Home Appliances'

            -- Fashion
            WHEN product_category_name_english IN (
                'fashion_bags_accessories',
                'fashion_shoes',
                'fashion_sport',
                'fashion_female_clothing',
                'fashion_childrens_clothes',
                'fashion_male_clothing',
                'fashion_underwear_beach',
                'luggage_accessories',
                'watches_gifts'
            )
            THEN 'Fashion & Accessories'

            -- Beauty
            WHEN product_category_name_english IN (
                'health_beauty',
                'perfumery'
            )
            THEN 'Beauty & Personal Care'

            -- Kinder
            WHEN product_category_name_english IN (
                'baby',
                'toys',
                'diapers_and_hygiene'
            )
            THEN 'Kids & Baby'

            -- Essen / Getränke
            WHEN product_category_name_english IN (
                'food',
                'food_drink',
                'drinks'
            )
            THEN 'Food & Beverage'

            -- Sport / Freizeit
            WHEN product_category_name_english IN (
                'sports_leisure',
                'cool_stuff'
            )
            THEN 'Sports & Leisure'

            -- Bücher
            WHEN product_category_name_english IN (
                'books_imported',
                'books_general_interest',
                'books_technical',
                'stationery'
            )
            THEN 'Books & Stationery'

            -- Bau / Werkzeuge
            WHEN product_category_name_english IN (
                'construction_tools_construction',
                'construction_tools_tools',
                'construction_tools_lights',
                'construction_tools_garden',
                'construction_tools_safety',
                'garden_tools',
                'signaling_and_security'
            )
            THEN 'Tools & Construction'

            -- Kunst / Events
            WHEN product_category_name_english IN (
                'art',
                'arts_and_craftmanship',
                'party_supplies',
                'christmas_supplies'
            )
            THEN 'Arts & Events'

            WHEN product_category_name_english = 'auto'
            THEN 'Automotive'

            WHEN product_category_name_english = 'pet_shop'
            THEN 'Pet'

            WHEN product_category_name_english IN (
                'industry_commerce_and_business',
                'agro_industry_and_commerce',
                'market_place',
                'security_and_services'
            )
            THEN 'Business & Services'

            ELSE 'Other'
        END AS super_category,

        CASE
            WHEN order_items.price >
                 (SELECT AVG(price) FROM order_items)
            THEN 'Expensive'
            ELSE 'Not Expensive'
        END AS price_group

    FROM order_items

    JOIN products
        ON order_items.product_id = products.product_id

    LEFT JOIN product_category_name_translation
        ON products.product_category_name =
           product_category_name_translation.product_category_name
)



SELECT
    super_category,

    COUNT(*) AS items_sold,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percent_of_all_sales,

    SUM(
        CASE
            WHEN price_group = 'Expensive' THEN 1
            ELSE 0
        END
    ) AS expensive_items_sold,

    ROUND(
        SUM(
            CASE
                WHEN price_group = 'Expensive' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS expensive_share_percent

FROM classified_sales

GROUP BY super_category

ORDER BY items_sold DESC;







# Conclusion: Home and Furniture works the best, followed by Tech. Thats good for us, but we have to take a closer look at WHAT Tech it actually is!

# Do they sell more expensive or cheap Tech and normal products?

SELECT
CASE
	WHEN product_category_name_english IN ("computers", "pc_gamer","computers_accessories", "electronics", "telephony")
    THEN "Tech"
    ELSE "Other"
END AS category_group,

CASE
    WHEN order_items.price > (SELECT AVG(price) FROM order_items)
    THEN 'Expensive'
    ELSE 'Not Expensive'
END AS price_group,
COUNT(*) AS products_sold

FROM products

JOIN product_category_name_translation
    ON products.product_category_name
       = product_category_name_translation.product_category_name
JOIN order_items
    ON products.product_id = order_items.product_id
GROUP BY category_group, price_group;

# Conclusion: They sell rather non-expensive products. In other-categories, but also in tech.

## In Relation to the Sellers

-- How many months of data are included in the Magist database?

SELECT YEAR(order_purchase_timestamp) AS order_year, COUNT(DISTINCT MONTH(order_purchase_timestamp)) AS months_in_year 
FROM orders 
GROUP BY YEAR(order_purchase_timestamp) 
ORDER BY order_year;

# There are a total of 25 months of data in the Magist database.

-- How many sellers are there? How many Tech sellers are there?

SELECT
    COUNT(DISTINCT s.seller_id) AS total_sellers,

    COUNT(DISTINCT CASE
        WHEN pt.product_category_name_english IN (
            'audio',
            'consoles_games',
            'electronics',
            'computers_accessories',
            'pc_gamer',
            'computers',
            'tablets_printing_image',
            'telephony'
        )
        THEN s.seller_id
    END) AS tech_sellers,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN pt.product_category_name_english IN (
                'audio',
                'consoles_games',
                'electronics',
                'computers_accessories',
                'pc_gamer',
                'computers',
                'tablets_printing_image',
                'telephony'
            )
            THEN s.seller_id
        END)
        / COUNT(DISTINCT s.seller_id),
        2
    ) AS tech_seller_percentage

FROM sellers s
INNER JOIN order_items oi
    ON s.seller_id = oi.seller_id
INNER JOIN products p
    ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt
    ON p.product_category_name = pt.product_category_name;
    
# There are a total of 2095 sellers, 477 of which are tech sellers, that's roughly 15,4% of all sellers.

-- What is the total amount earned by all sellers, What is the total amount earned by all Tech sellers?

SELECT COUNT(DISTINCT seller_id) AS All_Sellers,
COUNT(DISTINCT CASE
WHEN products.product_category_name IN(
    'telefonia',
    'tablets_impressao_imagem',
    'pcs',
    'informatica_acessorios',
    'audio',
    'eletronicos',
    'consoles_games',
    'pc_gamer')
    THEN seller_id END) AS Tech_Sellers,
ROUND(SUM(price), 0) AS revenue_all_sellers,
ROUND(SUM(CASE
WHEN products.product_category_name IN(
    'telefonia',
    'tablets_impressao_imagem',
    'pcs',
    'informatica_acessorios',
    'audio',
    'eletronicos',
    'consoles_games',
    'pc_gamer')
    THEN price
    ELSE 0
END), 0) AS revenue_tech_sellers
FROM order_items
LEFT JOIN products
	on products.product_id = order_items.product_id;
    
    -- Revenue sales and percentage of Tech sales

SELECT 
    COUNT(DISTINCT seller_id) AS All_Sellers,

    COUNT(DISTINCT CASE
        WHEN products.product_category_name IN (
            'telefonia',
            'tablets_impressao_imagem',
            'pcs',
            'informatica_acessorios',
            'audio',
            'eletronicos',
            'consoles_games',
            'pc_gamer'
        )
        THEN seller_id
    END) AS Tech_Sellers,

    ROUND(SUM(order_items.price), 0) AS revenue_all_sellers,

    ROUND(SUM(CASE
        WHEN products.product_category_name IN (
            'telefonia',
            'tablets_impressao_imagem',
            'pcs',
            'informatica_acessorios',
            'audio',
            'eletronicos',
            'consoles_games',
            'pc_gamer'
        )
        THEN order_items.price
        ELSE 0
    END), 0) AS revenue_tech_sellers,

    ROUND(
        100.0 * SUM(CASE
            WHEN products.product_category_name IN (
                'telefonia',
                'tablets_impressao_imagem',
                'pcs',
                'informatica_acessorios',
                'audio',
                'eletronicos',
                'consoles_games',
                'pc_gamer'
            )
            THEN order_items.price
            ELSE 0
        END) / NULLIF(SUM(order_items.price), 0),
        2
    ) AS tech_revenue_percentage

FROM order_items

LEFT JOIN products
    ON products.product_id = order_items.product_id;
    
# The revenue of all sellers is 13.591.644€, while the tech revenue is at 1.836.060€, so 14% of that.

-- What is the average monthly income of all sellers, What is the average monthly income of Tech sellers?

# Average monthly income of all sellers

SELECT
    ROUND(AVG(total_income), 2) AS average_income
FROM (
    SELECT
        seller_id,
        SUM(price) AS total_income
    FROM order_items
    GROUP BY seller_id
) AS seller_income;

# The average monthly income of a seller is 4391.48 €

# Average income of Tech sellers

SELECT
    ROUND(AVG(total_income), 2) AS average_tech_income
FROM (
    SELECT
        oi.seller_id,
        SUM(oi.price) AS total_income
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    LEFT JOIN product_category_name_translation pt
        ON p.product_category_name = pt.product_category_name
    WHERE pt.product_category_name_english IN (
        'audio',
        'consoles_games',
        'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony'
    )
    GROUP BY oi.seller_id
) AS seller_income;

-- 

SELECT
    pt.product_category_name_english AS category,
    ROUND(SUM(oi.price), 0) AS revenue,
    'Tech' AS category_type
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pt
    ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN (
    'audio',
    'consoles_games',
    'electronics',
    'computers_accessories',
    'pc_gamer',
    'computers',
    'tablets_printing_image',
    'telephony'
)
GROUP BY pt.product_category_name_english

UNION ALL

SELECT
    category,
    revenue,
    'Non-Tech' AS category_type
FROM (
    SELECT
        pt.product_category_name_english AS category,
        ROUND(SUM(oi.price), 0) AS revenue
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation pt
        ON p.product_category_name = pt.product_category_name
    WHERE pt.product_category_name_english NOT IN (
        'audio',
        'consoles_games',
        'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony'
    )
    GROUP BY pt.product_category_name_english
    ORDER BY revenue DESC
    LIMIT 8
) AS top_non_tech

ORDER BY revenue DESC;

-- What’s the average time between the order being placed and the product being delivered?

SELECT ROUND(AVG(TIMESTAMPDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date))) AS avg_delivery_days
FROM orders;

# Average time between the order being placed and the product being delivered is 12 days.

-- How many orders are delivered on time vs. orders delivered with a delay?

SELECT 
    COUNT(DISTINCT CASE
        WHEN orders.order_delivered_customer_date <= orders.order_estimated_delivery_date
        THEN orders.order_id
    END) AS On_Time_Orders,
    COUNT(DISTINCT CASE
        WHEN orders.order_delivered_customer_date > orders.order_estimated_delivery_date
        THEN orders.order_id
    END) AS Delayed_Orders,
    COUNT(DISTINCT CASE
        WHEN orders.order_delivered_customer_date <= orders.order_estimated_delivery_date
          OR orders.order_delivered_customer_date > orders.order_estimated_delivery_date
        THEN orders.order_id
    END) AS Total_Orders

FROM orders
WHERE orders.order_delivered_customer_date IS NOT NULL
  AND orders.order_estimated_delivery_date IS NOT NULL;
  
  # There are a total of 96475 orders, 7827 of which are delayed. That's roughly 8% of the total deliveries.
  
  -- Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT     
CASE 
WHEN DATEDIFF(
order_delivered_customer_date, order_estimated_delivery_date) > 0
THEN 'Delayed'
ELSE 'On Time'
END AS Delivery_Status,
ROUND(AVG(DATEDIFF(order_approved_at, order_purchase_timestamp)),1) AS Avg_Order_Placement_to_Approval, 
ROUND(AVG(DATEDIFF(order_delivered_carrier_date, order_approved_at)),1) AS Avg_Approval_to_Carrier, 
ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_delivered_carrier_date)),1) AS Avg_Carrier_to_Customer 
FROM orders 
GROUP BY CASE
WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0
THEN 'Delayed'
ELSE 'On Time'
END;

# The biggest delays happen from the product being handed from Magist to the postal office, there is the average delay time almost 3 additional days.
# Most concerning is the average delay from the postal office to the customer. It's almost 28 days, almost a whole month of average delivery delays.

-- sales vs orders

#total orders 
SELECT COUNT(order_item_id) 
FROM order_items;

# Amount of total orders: 112650

#tech orders 
SELECT 
    COUNT(*) 
FROM order_items 
LEFT JOIN products 
    ON order_items.product_id = products.product_id 
LEFT JOIN product_category_name_translation 
    ON products.product_category_name = product_category_name_translation.product_category_name 
WHERE product_category_name_english IN (
    'audio', 
    'consoles_games', 
    'electronics',
    'computers_accessories', 
    'pc_gamer', 
    'computers',
    'tablets_printing_image', 
    'telephony'
);
    
# Total tech orders: 16935
    
    
#total sellers 
SELECT COUNT(DISTINCT seller_id) 
FROM sellers; 

# Total sellers: 3095


#tech sellers
SELECT 
	COUNT(DISTINCT sellers.seller_id) 
    FROM sellers 

INNER JOIN order_items 
	ON sellers.seller_id = order_items.seller_id 

INNER JOIN products 
	ON order_items.product_id = products.product_id 
    
INNER JOIN product_category_name_translation 
	ON products.product_category_name = product_category_name_translation.product_category_name 
    
WHERE product_category_name_english 
	IN 
    ( 'audio', 'consoles_games', 'electronics',
    'computers_accessories', 'pc_gamer', 'computers',
    'tablets_printing_image', 'telephony');

# Total tech sellers: 477


#order growth over time
SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM 
    orders
WHERE 
    order_status = 'delivered'
GROUP BY 
    order_month
ORDER BY 
    order_month;
    
# Orders grow well over time, drop and stagnate a little after 2017.
    
    
#Tech order growth over time
SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS total_tech_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE t.product_category_name_english IN (
        'telephony',
        'tablets_printing_image',
        'computers',
        'computers_accessories',
        'audio',
        'electronics',
        'consoles_games',
        'pc_gamer'
    )
  AND o.order_status = 'delivered'
GROUP BY 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY 
    month ASC;
# Tech orders grow well over the time, slight stagnation in the past 6 months, after a big drop at the beginning of 2018.
    
    
#tech seller growth over time
SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT oi.seller_id) AS active_tech_sellers
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE t.product_category_name_english IN (
        'telephony',
        'tablets_printing_image',
        'computers',
        'computers_accessories',
        'audio',
        'electronics',
        'consoles_games',
        'pc_gamer'
    )
  AND o.order_status = 'delivered'
GROUP BY 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY 
    month ASC;
    
# relatively few tech sellers, growth rate stagnates in early 2018


#Total seller growth over time
SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT oi.seller_id) AS total_active_sellers
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY 
    month ASC;
    
# The amount of total sellers has a steady growth, stagnates slightly in the latest few months.