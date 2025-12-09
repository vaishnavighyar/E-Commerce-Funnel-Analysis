SELECT * 
FROM `e-commerce_funnel_analysis`.customer_journey;

# Metric 1: Overall funnel analysis
WITH funnel_stages AS (
     SELECT
         COUNT(DISTINCT CASE WHEN PageType='home' THEN SessionID END) as home_visitors,
         COUNT(DISTINCT CASE WHEN PageType='product_page' THEN SessionID END) as product_viewers,
         COUNT(DISTINCT CASE WHEN PageType='cart' THEN SessionID END) as cart_adds,
         COUNT(DISTINCT CASE WHEN PageType='checkout' THEN SessionID END) as checkouts,
         COUNT(DISTINCT CASE WHEN PageType='confirmation' THEN SessionID END) as purchases
         
     FROM customer_journey
)

SELECT 
    'HOME' as stage,
    home_visitors as sessions,
    100.0 as retention_rate,
    0.0 as drop_off_rate
FROM funnel_stages

UNION ALL

SELECT
  'Product Page',
  product_viewers,
  ROUND(product_viewers*100.0/home_visitors, 2),
  ROUND((home_visitors - product_viewers)*100.0 / home_visitors, 2)
FROM funnel_stages

UNION ALL

SELECT 
    'Cart',
    cart_adds,
    ROUND(cart_adds * 100.0 / product_viewers, 2),
    ROUND((product_viewers - cart_adds) * 100.0 / product_viewers, 2)
FROM funnel_stages

UNION ALL

SELECT
  'Checkout',
  checkouts,
  ROUND(checkouts*100.0/ cart_adds, 2),
  ROUND((cart_adds - checkouts)*100.0 / cart_adds, 2)
FROM funnel_stages

UNION ALL

SELECT
   'Purchase',
    purchases,
    ROUND(purchases * 100.0 / checkouts, 2),
    ROUND((checkouts - purchases) * 100.0 / checkouts, 2)
FROM funnel_stages;

# Metric 2: Conversion breakdown
# 2.1 where do users drop off?

WITH session_stages AS (
    SELECT 
        SessionID,
        MAX(CASE WHEN PageType = 'home' THEN 1 ELSE 0 END) as reached_home,
        MAX(CASE WHEN PageType = 'product_page' THEN 1 ELSE 0 END) as reached_product,
        MAX(CASE WHEN PageType = 'cart' THEN 1 ELSE 0 END) as reached_cart,
        MAX(CASE WHEN PageType = 'checkout' THEN 1 ELSE 0 END) as reached_checkout,
        MAX(CASE WHEN PageType = 'confirmation' THEN 1 ELSE 0 END) as reached_confirmation,
        MAX(Purchased) as purchased
    FROM customer_journey
    GROUP BY SessionID
)
SELECT 
    CASE 
        WHEN reached_confirmation = 1 THEN 'Completed Purchase'
        WHEN reached_checkout = 1 THEN 'Abandoned at Checkout'
        WHEN reached_cart = 1 THEN 'Abandoned at Cart'
        WHEN reached_product = 1 THEN 'Viewed Products Only'
        WHEN reached_home = 1 THEN 'Homepage Bounce'
    END as drop_off_point,
    COUNT(*) as session_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM session_stages), 2) as percentage
FROM session_stages
GROUP BY 
    CASE 
        WHEN reached_confirmation = 1 THEN 'Completed Purchase'
        WHEN reached_checkout = 1 THEN 'Abandoned at Checkout'
        WHEN reached_cart = 1 THEN 'Abandoned at Cart'
        WHEN reached_product = 1 THEN 'Viewed Products Only'
        WHEN reached_home = 1 THEN 'Homepage Bounce'
    END
ORDER BY drop_off_point;

# 2.2 relation between time spent and conversion

SELECT 
   PageType,
   CASE WHEN Purchased = 1 THEN 'Converted' ELSE 'Not Converted' END as status,
   COUNT(*) as page_views,
   ROUND(AVG(TimeOnPage_seconds), 2) as avg_time,
   MIN(TimeOnPage_seconds) as min_time,
   MAX(TimeOnPage_seconds) as max_time
FROM customer_journey
WHERE TimeOnPage_seconds IS NOT NULL
GROUP BY PageType, Purchased
ORDER BY PageType, Purchased;   

#Metric 3: External factors
# 3.1 How much conversion by each device

SELECT
    DeviceType,
    COUNT(DISTINCT SessionID) as total_sessions,
    COUNT(DISTINCT CASE WHEN Purchased = 1 THEN SessionID END) as converted_sessions,
    ROUND(
          COUNT(DISTINCT CASE WHEN Purchased = 1 THEN SessionID END) * 100.0 / COUNT(DISTINCT SessionID), 2) as conversion_rate,
    ROUND(AVG(TimeOnPage_seconds), 2) as avg_time_on_page,
    ROUND(AVG(ItemsInCart), 2) as avg_items_in_cart
FROM customer_journey
GROUP BY DeviceType
ORDER BY conversion_rate DESC;    
          
#3.2 Conversion through traffic source

SELECT
   ReferralSource,
   COUNT(DISTINCT SessionID) as total_sessions,
   COUNT(DISTINCT CASE WHEN Purchased = 1 THEN SessionID END) as conversions,
   ROUND(
        COUNT(DISTINCT CASE WHEN Purchased = 1 THEN SessionID END) * 100.0 / COUNT(DISTINCT SessionID), 2) as conversion_rate,
   ROUND(AVG(CASE WHEN Purchased = 1 THEN TimeOnPage_seconds END), 2) as avg_time_converters
FROM customer_journey
GROUP BY ReferralSource
ORDER BY conversion_rate DESC;

#3.3 Performance by country

SELECT
   Country,
   COUNT(DISTINCT SessionID) as total_sessions,
   COUNT(DISTINCT CASE WHEN Purchased = 1 THEN SessionID END) as conversions,
   ROUND(
        COUNT(DISTINCT CASE WHEN Purchased = 1 THEN SessionID END) * 100.0 / COUNT(DISTINCT SessionID), 2) as conversion_rate
FROM customer_journey
GROUP BY Country
HAVING COUNT(DISTINCT SessionID) >= 10
ORDER BY conversion_rate DESC;


  
