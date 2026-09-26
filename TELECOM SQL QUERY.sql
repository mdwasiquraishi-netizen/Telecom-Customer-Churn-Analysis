DROP TABLE IF EXISTS telco_customer_churn;

CREATE TABLE telco_customer_churn(
	customerID VARCHAR(20),
	gender VARCHAR(20),
	SeniorCitizen INTEGER,
	Partner VARCHAR(10),
	Dependents VARCHAR(10),
	tenure INTEGER,
	PhoneService VARCHAR(10),
	MultipleLines VARCHAR(30),
	InternetService VARCHAR(30),
	OnlineSecurity VARCHAR(30),
	OnlineBackup VARCHAR(30),
	DeviceProtection VARCHAR(30),
	TechSupport VARCHAR(30),
	StreamingTV VARCHAR(30),
	StreamingMovies VARCHAR(30),
	Contract VARCHAR(30),
	PaperlessBilling VARCHAR(30),
	PaymentMethod VARCHAR(50),
	MonthlyCharges NUMERIC(10,2)
	TotalCharges TEXT,
	Churn VARCHAR(10)
);

SELECT * FROM telco_customer_churn;

-----Business Problems And Solutions-----

--Q1)What is the total number of customers?
SELECT COUNT(DISTINCT(customerid)) AS total_customers
FROM telco_customer_churn;

--Q2)How many customers are currently active/retained versus churned?
SELECT churn, COUNT (*) AS total_customers
FROM telco_customer_churn
GROUP BY churn
ORDER BY total_customers DESC;

--Q3)What is the overall customer churn rate?
SELECT COUNT(*) AS total_customers,
COUNT(*) FILTER (WHERE "churn" = 'Yes') AS churned_customer,
ROUND(100.0 * COUNT(*) FILTER (WHERE "churn" = 'Yes')/ COUNT(*),2)
FROM telco_customer_churn;

--Q4)How are customers distributed by gender?
SELECT gender, COUNT(*) AS customer_count,
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),2) AS percentage_of_customers
FROM telco_customer_churn
GROUP BY gender
ORDER BY customer_count DESC;

--Q5)How many customers are senior citizens?
SELECT COUNT(seniorcitizen) AS total_senior_citizen
FROM telco_customer_churn
WHERE seniorcitizen = 1;

--Q6)What percentage of customers have partners?
SELECT COUNT(*) FILTER(WHERE "partner" = 'Yes') AS customer_with_partner,
COUNT(*) AS total_customers,
ROUND(100.0 * COUNT(*) FILTER(WHERE "partner" = 'Yes') / COUNT(*),2) AS percentage_of_partners
FROM telco_customer_churn;

--Q7)What percentage of customers have dependents?
SELECT COUNT(*) FILTER(WHERE "dependents" = 'Yes') AS customer_with_dependents,
COUNT(*) AS total_customers,
ROUND(100 * COUNT(*) FILTER(WHERE "dependents" = 'Yes') / COUNT(*), 2) AS percentage_of_dependents
FROM telco_customer_churn;

--Q8)What is the average customer tenure?
SELECT ROUND(AVG(tenure),2) AS avg_customer_tenure
FROM telco_customer_churn;

--Q9)What are the minimum and maximum customer tenure values?
SELECT MAX(tenure) AS maximum_tenure,
MIN(tenure) AS minimum_tenure
FROM telco_customer_churn;

--Q10)How many customers have been with the company for less than 12 months?
SELECT COUNT(*) AS customer_less_than_12months
FROM telco_customer_churn
WHERE tenure < 12;

--Q11)What is the churn rate among senior citizens versus non-senior citizens?
SELECT
    CASE
        WHEN "seniorcitizen" = 1 THEN 'Senior Citizen'
        ELSE 'Non-Senior Citizen'
    END AS customer_group,

    COUNT(*) AS total_customers,

    COUNT(*) FILTER (WHERE "churn" = 'Yes') AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE "churn" = 'Yes')
        / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM telco_customer_churn
GROUP BY "seniorcitizen"
ORDER BY churn_rate_percentage DESC;


--Q12)Does having a partner affect customer churn?
------Churn rate based on partner status?
SELECT partner, COUNT(*) AS total_customer,
COUNT(*) FILTER(WHERE churn = 'Yes') AS churned_customers,
ROUND(100.0 * COUNT(*) FILTER(WHERE churn = 'Yes') / COUNT(*),2) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY partner
ORDER BY churn_rate_percentage DESC;

--Q13)Does having dependents affect customer churn?
---Churn rate based on dependent status?
SELECT dependents, COUNT(*) AS total_customers,
COUNT(*) FILTER(WHERE churn = 'Yes') AS churned_customers,
ROUND(100.0 * COUNT(*) FILTER(WHERE churn = 'Yes') / COUNT(*),2) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY dependents
ORDER BY churn_rate_percentage DESC;

--Q14)Which internet service type has the highest churn rate?
SELECT internetservice, COUNT(*) AS total_customers,
COUNT(*) FILTER(WHERE churn = 'Yes') AS churned_customer,
ROUND(100.0 * COUNT(*) FILTER(WHERE churn = 'Yes') / COUNT(*),2) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY internetservice
ORDER BY churn_rate_percentage DESC;

--Q15)Which contract type has the highest churn rate?
SELECT contract, COUNT(*) AS total_customers,
COUNT(*) FILTER(WHERE churn = 'Yes') AS churned_customers,
ROUND(100.0 * COUNT(*) FILTER(WHERE churn = 'Yes') / COUNT(*),2) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY contract
ORDER BY churn_rate_percentage DESC;

--Q16)How many customers have churned and how many have been retained?
SELECT churn, COUNT(*) AS total_customers
FROM telco_customer_churn
GROUP BY churn
ORDER BY total_customers DESC;

--Q17)What is the overall customer churn rate?
SELECT COUNT(*) AS total_customers,
COUNT(*) FILTER(WHERE churn = 'Yes') AS churned_customers,
ROUND(100.0 * COUNT(*) FILTER(WHERE churn = 'Yes') / COUNT(*),2) AS churn_rate_percentage
FROM telco_customer_churn;

--Q18)What is the churn rate by payment method?
SELECT paymentmethod, COUNT(*) AS total_customers,
COUNT(*) FILTER(WHERE churn = 'Yes') AS churned_customers,
ROUND(100.0 * COUNT(*) FILTER(WHERE churn = 'Yes') / COUNT(*),2) AS churn_rate_percentage
FROM telco_customer_churn
GROUP BY paymentmethod
ORDER BY churn_rate_percentage DESC;

--Q19)Which tenure group has the highest churn rate?
WITH tenure_groups AS (
    SELECT
        *,
        CASE
            WHEN "tenure" <= 12 THEN '0-12 Months'
            WHEN "tenure" <= 24 THEN '13-24 Months'
            WHEN "tenure" <= 36 THEN '25-36 Months'
            WHEN "tenure" <= 48 THEN '37-48 Months'
            WHEN "tenure" <= 60 THEN '49-60 Months'
            ELSE '61-72 Months'
        END AS tenure_group
    FROM telco_customer_churn
)

SELECT tenure_group, COUNT(*) AS total_customers,
COUNT(*) FILTER(WHERE churn = 'Yes') AS churned_customers,
ROUND(100.0 * COUNT(*) FILTER(WHERE churn = 'Yes') / COUNT(*),2) AS churn_rate_percentage
FROM tenure_groups
GROUP BY tenure_group
ORDER BY MIN(tenure);

--Q20)How much monthly revenue is associated with churned customers?
SELECT churn, SUM(monthlycharges)
FROM telco_customer_churn
WHERE churn = 'Yes'
GROUP BY churn;



