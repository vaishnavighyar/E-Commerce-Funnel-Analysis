# E-Commerce-Funnel-Analysis
Analyze user behaviour through funnel analysis

**Aim**
To identify User Behaviour patterns on the E-Commerce platform using Funnel analysis.

**Dataset used**
[E-Commerce Customer Journey: Click to Conversion](https://www.kaggle.com/datasets/sufya6/e-commerce-customer-journey-click-to-conversion)

**Techstack used**
Python _(EDA)_, SQL _(KPI analysis)_, Power BI, Funnel analysis

**KPI**
1.	Where do we lose customers?
2.	Where do users drop off?
3.	How time spent on each page affect the conversion rate?
4.	Analysing conversion rate by:
           ~By Device
           ~By Referral source
5.	Country-wise user performance.

<img width="1579" height="911" alt="Image" src="https://github.com/user-attachments/assets/a566158b-7f0b-49e0-bde6-622e0fd19c4e" />

**Analysis Steps:**
1.	Performed EDA on the dataset using Python.
2.	Imported the dataset into MySQL 
3.	Identified formulas for defined KPIs.

<img width="824" height="435" alt="Image" src="https://github.com/user-attachments/assets/64b498e4-4cae-4e03-af67-b326872af12e" />

5.	Exported .csv files of the output of defined KPIs into Power BI
6.	Build Dashboard & Report showcasing insights found analysis.
**Insights from analysis**
1. Our website has **5000** total sessions with **20.20%** as its Conversion rate, i.e _1010_ sessions resulted in completing the purchase.
2. But, we lose almost half of our customers when navigating from Product page to cart page, with a _drop off_ rate of **59.89%**. 
3. On an average, a converted user spend **99.89** **sec** on each page, whereas **97.54 sec** is the time spent by a non-converted user. _(indicates user carefully reviewing their order before checkout)_
4. _Google ads_ contributes to the highest conversion rate of **21.64%** while Social media generating the least leads.
5. Desktop users are the highest converters with **20.35%** as their conversion rate.
6. After analysing country wise performance, **_France_** tops the chart with an average of **752 sessions** whereas **India** and Australia producing the least sessions.
7. From overall analysis it is found that **76%** is an average funnel retention rate, i.e 76% sessions reached next step, while 24% dropped off.
