CREATE TABLE "Financial_loan" ();

SELECT * FROM "Financial_loan"

-- Total loan applications
SELECT COUNT(id) AS total_loan_applications FROM "Financial_loan"

-- MTD total loan applications
SELECT COUNT(id) AS MTD_total_loan_applications FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 12 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021;

-- MoM = (MTD-PMTD)/PMTD

-- PMTD total loan applications (previous MTD)
SELECT COUNT(id) AS PMTD_total_loan_applications FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 11 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021;

-- Total funded amount
SELECT SUM(loan_amount) AS total_funded_amount FROM "Financial_loan"

-- MTD total funded amount
SELECT SUM(loan_amount) AS MTD_total_funded_amount FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 12 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021;

--PMTD total funded amount
SELECT SUM(loan_amount) AS PMTD_total_funded_amount FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 11 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021;

-- total amount received
SELECT SUM(total_payment) AS total_amount_received FROM "Financial_loan"

-- MTD total amount received
SELECT SUM(total_payment) AS MTD_total_amount_received FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 12 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021;

-- PMTD total amount received
SELECT SUM(total_payment) AS PMTD_total_amount_received FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 11 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021;

-- average interest rate (in %age)
SELECT AVG(int_rate) * 100 AS average_interest_rate FROM "Financial_loan"

-- MTD average interest rate (in %age)
SELECT AVG(int_rate) * 100 AS MTD_average_interest_rate FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 12 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021;

-- PMTD average interest rate (in %age)
SELECT AVG(int_rate) * 100 AS PMTD_average_interest_rate FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 11 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021;

-- average DTI (in %age)
SELECT AVG(dti) * 100 AS average_DTI FROM "Financial_loan"

-- MTD average DTI (in %age)
SELECT AVG(dti) * 100 AS MTD_average_DTI FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 12 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021;

-- PMTD average DTI (in %age)
SELECT AVG(dti) * 100 AS PMTD_average_DTI FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 11 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021;

-- percentage of good loan applications
SELECT (COUNT (CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)* 100.0) / COUNT(id)
AS Good_loan_percentage FROM "Financial_loan"

-- number of good loan applications
SELECT COUNT(id) AS good_loan_applications FROM "Financial_loan"
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- good loan funded amount
SELECT SUM(loan_amount) AS good_loan_funded_amount FROM "Financial_loan"
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- good loan received amount
SELECT SUM(total_payment) AS good_loan_received_amount FROM "Financial_loan"
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- percentage of bad loan applications
SELECT (COUNT (CASE WHEN loan_status = 'Charged Off' THEN id END)* 100.0) / COUNT(id)
AS Bad_loan_percentage FROM "Financial_loan"

-- number of bad loan applications
SELECT COUNT(id) AS bad_loan_applications FROM "Financial_loan"
WHERE loan_status = 'Charged Off'

-- bad loan funded amount
SELECT SUM(loan_amount) AS bad_loan_funded_amount FROM "Financial_loan"
WHERE loan_status = 'Charged Off'

-- bad loan received amount
SELECT SUM(total_payment) AS bad_loan_received_amount FROM "Financial_loan"
WHERE loan_status = 'Charged Off'

-- loan status grid view
SELECT loan_status , 
COUNT(id) AS total_loan_applications , 
SUM(loan_amount) AS total_funded_amount ,
SUM(total_payment) AS total_received_amount , 
AVG(int_rate) * 100 AS average_interest_rate , 
AVG(dti) * 100 AS average_DTI_ratio ,
FROM "Financial_loan"
GROUP BY loan_status
ORDER BY total_loan_applications DESC

SELECT loan_status , 
SUM(loan_amount) AS MTD_total_funded_amount ,
SUM(total_payment) AS MTD_total_received_amount
FROM "Financial_loan"
WHERE EXTRACT(month from to_date(issue_date , 'DD-MM-YYYY')) = 12 AND EXTRACT(year from to_date(issue_date , 'DD-MM-YYYY')) = 2021
GROUP BY loan_status

-- CHARTS

-- monthly trends by issue date
SELECT 
EXTRACT(month from issue_date::date) AS issue_month_number , 
TO_CHAR(issue_date::date , 'Month') AS issue_month_name , 
COUNT(id) AS total_loan_applications , 
SUM(loan_amount) AS total_funded_amount , 
SUM(total_payment) AS total_received_amount
FROM "Financial_loan"
GROUP BY issue_month_number , issue_month_name
ORDER BY issue_month_number ASC

-- regional analysis by state
SELECT address_state AS state , 
COUNT(id) AS total_loan_applications , 
SUM(loan_amount) AS total_funded_amount , 
SUM(total_payment) AS total_received_amount 
FROM "Financial_loan"
GROUP BY state
ORDER BY state

-- loan term analysis
SELECT term AS loan_term , 
COUNT(id) AS total_loan_applications , 
SUM(loan_amount) AS total_funded_amount , 
SUM(total_payment) AS total_received_amount 
FROM "Financial_loan"
GROUP BY loan_term
ORDER BY loan_term

-- employee length analysis
SELECT emp_length ,
COUNT(id) AS total_loan_applications , 
SUM(loan_amount) AS total_funded_amount , 
SUM(total_payment) AS total_received_amount 
FROM "Financial_loan"
GROUP BY emp_length
ORDER BY emp_length

-- loan purpose breakdown
SELECT purpose AS loan_purpose , 
COUNT(id) AS total_loan_applications , 
SUM(loan_amount) AS total_funded_amount , 
SUM(total_payment) AS total_received_amount 
FROM "Financial_loan"
GROUP BY loan_purpose
ORDER BY total_loan_applications DESC

-- home ownership analysis
SELECT home_ownership ,
COUNT(id) AS total_loan_applications , 
SUM(loan_amount) AS total_funded_amount , 
SUM(total_payment) AS total_received_amount 
FROM "Financial_loan"
GROUP BY home_ownership
ORDER BY total_loan_applications DESC