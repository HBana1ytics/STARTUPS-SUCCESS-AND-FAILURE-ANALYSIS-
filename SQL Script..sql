SELECT * FROM startup_project.startups_dataset;  

SELECT COUNT(*) FROM startups_dataset;

DELETE FROM startups_dataset WHERE permalink = '';  
DELETE FROM startups_dataset WHERE name = ''; 
DELETE FROM startups_dataset WHERE homepage_url = ''; 
DELETE FROM startups_dataset WHERE category_list = ''; 
DELETE FROM startups_dataset WHERE funding_total_usd = "-"; 
DELETE FROM startups_dataset WHERE status = ''; 
DELETE FROM startups_dataset WHERE country_code = ''; 
DELETE FROM startups_dataset WHERE state_code = '';  
DELETE FROM startups_dataset WHERE region = ''; 
DELETE FROM startups_dataset WHERE city = ''; 
DELETE FROM startups_dataset WHERE funding_rounds = ''; 
DELETE FROM startups_dataset WHERE founded_at = ''; 
DELETE FROM startups_dataset WHERE first_funding_at = ''; 
DELETE FROM startups_dataset WHERE last_funding_at = '';  

SELECT COUNT(*) FROM startups_dataset;

SELECT * FROM startup_project.startups_dataset;  

 
# Demographic analysis: Analyze the distribution of startups based on geographic location, industry, and funding amount      

SELECT 
  country_code, category_list, 
  AVG(funding_total_usd) AS average_funding, 
  COUNT(*) AS num_startups 
FROM startups_dataset 
GROUP BY country_code, category_list;          

 
# Funding trends: Analyze the trend of funding over time and compare the funding of startups in different regions, cities, and countries      
 
SELECT 
  year(founded_at) as founded_year, region, city, country_code, 
  AVG(funding_total_usd) as avg_funding, 
  SUM(funding_total_usd) as total_funding 
FROM startups_dataset 
GROUP BY founded_year, region, city, country_code 
ORDER BY founded_year, avg_funding DESC;  


# Success and failure: Analyze the factors that contribute to the success or failure of startups, such as industry, location, and funding amount       
  
CREATE TABLE successful_startups AS
SELECT permalink, name, homepage_url, category_list, funding_total_usd, 
       country_code, state_code, region, city, funding_rounds, founded_at, 
       first_funding_at, last_funding_at
FROM startups_dataset
WHERE status = 'operating' OR status = 'acquired' OR status = 'ipo';
 
CREATE TABLE failed_startups AS
SELECT permalink, name, homepage_url, category_list, funding_total_usd, 
       country_code, state_code, region, city, funding_rounds, founded_at, 
       first_funding_at, last_funding_at
FROM startups_dataset
WHERE status = 'closed';     

SELECT category_list, COUNT(*) as count
FROM successful_startups
GROUP BY category_list
ORDER BY count DESC;  

SELECT region, COUNT(*) as count
FROM successful_startups
GROUP BY region
ORDER BY count DESC;
 
SELECT funding_total_usd, COUNT(*) as count
FROM successful_startups
GROUP BY funding_total_usd
ORDER BY funding_total_usd DESC; 


# Performance analysis: Analyze the performance of startups based on the number of funding rounds, funding amount, and the time between funding rounds     
 
SELECT funding_rounds, AVG(funding_total_usd) AS avg_funding_amount
FROM startups_dataset
WHERE status = 'operating'
GROUP BY funding_rounds;    
  
SELECT funding_rounds, AVG(TIMESTAMPDIFF(MONTH, first_funding_at, last_funding_at)) AS avg_time_between_rounds
FROM startups_dataset
WHERE status = 'operating'
GROUP BY funding_rounds;
 
SELECT A.funding_rounds, AVG(A.funding_total_usd) AS avg_funding_amount, AVG(B.avg_time_between_rounds) AS avg_time_between_rounds
FROM startups_dataset A
JOIN (
    SELECT funding_rounds, AVG(TIMESTAMPDIFF(MONTH, first_funding_at, last_funding_at)) AS avg_time_between_rounds
    FROM startups_dataset
    WHERE status = 'operating'
    GROUP BY funding_rounds)  
B ON A.funding_rounds = B.funding_rounds
WHERE A.status = 'operating'
GROUP BY A.funding_rounds;     
 

# a summary table that aggregates the funding_total_usd by each country_code, state_code, region, and city. This will allow you to see the total amount of funding that has been raised in each location and potentially identify areas with high funding potential. And, another summary table that aggregates the funding_total_usd by the different funding round stages (operating, closed, acquired, IPO). This would give you a better understanding of which stages are receiving the most funding and where there may be potential opportunities for investment.     
CREATE TABLE location_summary AS 
SELECT country_code, state_code, region, city, SUM(funding_total_usd) AS total_funding 
FROM startups_dataset 
GROUP BY country_code, state_code, region, city;    

CREATE TABLE funding_stage_summary AS 
SELECT status, SUM(funding_total_usd) AS total_funding 
FROM startups_dataset 
GROUP BY status;
    
  
  
  
 
     
     