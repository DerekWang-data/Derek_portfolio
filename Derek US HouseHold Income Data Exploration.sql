# Project 1 Data Exploration


SELECT *
FROM household_income.ushouseholdincome;

SELECT *
FROM household_income.ushouseholdincome_statistics;

# Data Exploration Notes

- Goal: identify trends, patterns, and insights within the dataset.  
- Observation: there are no date fields available, so time series analysis will not be applicable.  
- Alternative focus: explore information at the state level (e.g., state size, average city size).  
- Next step: join with the statistics table to analyze additional variables such as mean and median incomes.  
- Approach: begin with simple descriptive exploration, then progress to table joins for deeper analysis.

#Select only the relevant columns from the dataset to simplify analysis and focus on key variables.
SELECT State_Name, ALand, AWater
FROM household_income.ushouseholdincome;

#Calculate the total size of each state and order the results from smallest to largest.
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM household_income.ushouseholdincome
GROUP BY State_Name
ORDER BY 2;

#Just glancing at these results they look pretty accurate. Texas being the largest

#Display the ten states with the largest total land size.
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM household_income.ushouseholdincome
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

#Display the ten states with the largest total water area, highlighting those with significant lakes, rivers, or coastlines.  
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM household_income.ushouseholdincome
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

#I expected Michigan, florida, minnesota to be in there - also Alaska, but I didn't expect Texas or North Carolina to be in the top 10 - interesting

#Now that's interesting, but this is primrily an income dataset. Let's join the tables together and look at that

SELECT *
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id;
    
#Now filter on the columns we want

SELECT u.State_Name, County, `Type`, `Primary`, Mean, Median
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id;


#Examine the average mean and median values at the state level to understand how they vary across different regions.  
SELECT u.State_Name, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY u.State_Name
order by 3;

#Identify the states with the lowest average and median incomes in the U.S., highlighting regions with comparatively lower earnings.
SELECT u.State_Name, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY u.State_Name
order by 3;

# So far, the focus has been on state-level data. 
# The analysis can also be broken down by type. 
# Include "primary" in the breakdown for comparison, even though its meaning is not yet clear.

SELECT `Type`, `Primary`, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY `Type`, `Primary`
order by 3;

# Keep "Type" in the analysis to compare across different categories, 

SELECT `Type`, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY `Type`
order by 3;

#Woah, whatever a CDP is their median is dramatically higher.

#Do a count of Type because that context matters...

SELECT `Type`,COUNT(`Type`), AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY `Type`
order by 4;

#Now this makes a huge difference. Honestly. Municipality is high, but only has 1 row in the entire dataset so that's super skewed.

# Apply a filter to remove categories with limited data. 
# Only keep groups that have more than 100 rows for analysis.

SELECT `Type`,COUNT(`Type`), AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY `Type`
HAVING COUNT(`Type`) > 100
order by 4;


#Review the dataset after filtering to see the current state of the data

SELECT *
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id;

#The last thing I'm interested in is finding the cities with the highest and lowest median salary.
SELECT u.State_Name, City, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
HAVING AVG(Mean) IS NOT NULL
ORDER BY 3 ASC
LIMIT 10;


#In these cities the avg salary is only like 10k, 14k - that's super low

#Highest
SELECT u.State_Name, City, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY 3 DESC
LIMIT 10;

#One thing I'm noticing is some of the Medians are 300,000 which is odd. This is something I would dig into more in the data



