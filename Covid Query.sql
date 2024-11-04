	--Declaring Data to be used


Select date, location, new_cases, new_deaths, total_cases, total_deaths 
FROM PortfolioProjectSQL..CovidCasesLatest
ORDER BY 1,2

Select date, location, total_vaccinations, people_vaccinated, people_fully_vaccinated, total_vaccinations_per_hundred, 
		people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred 
FROM PortfolioProjectSQL..CovidVaxLatest
ORDER BY 1,2

Select location, population
FROM PortfolioProjectSQL..WorldPopulation


Select location 
FROM PortfolioProjectSQL..CovidVaxLatest 
Group BY location






---------------------------------------------------------------------------------------------------
/*  WORLD COVID DATA    */

--Vacinnations
SELECT date, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred 
FROM PortfolioProjectSQL..CovidVaxLatest
WHERE people_vaccinated_per_hundred IS NOT NULL 
	AND people_fully_vaccinated_per_hundred IS NOT NULL
	AND location ='World'
ORDER BY 1

--Effect of Vaccine to Death and Cases
Select cas.date, new_cases, new_deaths, people_vaccinated_per_hundred
FROM PortfolioProjectSQL..CovidCasesLatest cas
JOIN  PortfolioProjectSQL..CovidVaxLatest vax
	ON cas.date = vax.date
WHERE cas.location = 'World'
	AND people_vaccinated_per_hundred IS NOT NULL
ORDER BY date ASC


-- Mortality Rate of Cases
Select date, CAST(total_deaths AS FLOAT)/ CAST(total_cases AS FLOAT) AS [Death Percentage],
	total_deaths,
	total_cases
FROM PortfolioProjectSQL..CovidCasesLatest
WHERE location = 'World'
ORDER BY 1 DESC

--Mortality Rate by Population
Select date, CAST(total_deaths AS FLOAT)/ CAST(population AS FLOAT) AS [Death Percentage],
	total_deaths,
	population
FROM PortfolioProjectSQL..CovidCasesLatest cas
JOIN PortfolioProjectSQL..WorldPopulation pop
	ON cas.location = pop.location
WHERE cas.location = 'World'
ORDER BY 1 DESC

--Select location, date,
--	ISNULL(CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT),0) AS [death percentage],
--	ISNULL(total_deaths,0) AS total_deaths, 
--	ISNULL(total_cases,0) AS total_cases 
--FROM PortfolioProjectSQL..CovidCasesLatest
--ORDER BY [Death Percentage] DESC

--Infection Rates Per Country
Select cas.location, 
	CAST(MAX(total_cases) AS FLOAT)/CAST(MAX(population) AS FLOAT) AS [Infection Rate],
	MAX(total_cases) AS [Cases], 
	MAX(population) AS Population
FROM  PortfolioProjectSQL..CovidCasesLatest cas
JOIN PortfolioProjectSQL..WorldPopulation pop
	ON cas.location = pop.location
WHERE total_cases IS NOt NULL
	AND population IS NOT NULL
GROUP BY cas.location
ORDER BY [Infection Rate] DESC


-- Vaccination and Infection Rate
Select cas.date,
	(CAST(new_cases AS FLOAT)/CAST(population AS FLOAT)* 1000) AS [Infection Rate per Thousand],
	people_vaccinated_per_hundred AS [Vaccination Rate]
FROM  PortfolioProjectSQL..CovidCasesLatest cas
JOIN PortfolioProjectSQL..WorldPopulation pop 
	ON cas.location = pop.location
JOIN PortfolioProjectSQL..CovidVaxLatest vax
	ON cas.location = vax.location
	AND cas.date = vax.date
WHERE cas.location = 'World'
ORDER BY cas.date


-- World Overall Deaths and Cases
Select SUM(CAST([Overall Deaths] AS INT)) AS [World Overall Deaths],
	SUM(CAST([Overall Cases] AS INT)) AS [World Overall Cases],
	SUM(CAST([Overall Deaths] AS FLOAT))/SUM(CAST([Overall Cases] AS FLOAT)) AS [World Death Percentage]
FROM 
	(Select location, MAX(total_deaths) AS [Overall Deaths], 
		MAX(total_cases) AS [Overall Cases], 
		CAST(MAX(total_deaths) AS FLOAT)/CAST(MAX(total_cases) AS FLOAT) AS [Death Percentage]
	FROM PortfolioProjectSQL..CovidDeaths$ 
	WHERE  total_deaths IS NOT NULL
		AND total_cases IS NOT NULL
		AND continent is NULL
		AND location NOt IN ('World', 'European Union', 'International')
	GROUP BY location
	) AS World_Data

SELECt MAX(total_deaths) AS [total deaths], MAX(total_cases) AS [total cases], MAX(CAST(total_deaths AS FLOAT))/MAX(CAST(total_cases AS FLOAT)) AS [death rate]
FROM PortfolioProjectSQL..CovidCasesLatest cas
WHERE location = 'World'


-------------------------------------------------------------------------------------------------------------------
/*  PHILIPPINES COVID DATA    */


--Vacinnations
SELECT date, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred 
FROM PortfolioProjectSQL..CovidVaxLatest
WHERE people_vaccinated_per_hundred IS NOT NULL 
	AND people_fully_vaccinated_per_hundred IS NOT NULL
	AND location ='Philippines'
ORDER BY 1

--Effect of Vaccine to Death and Cases
Select cas.date, new_cases, new_deaths, people_vaccinated_per_hundred
FROM PortfolioProjectSQL..CovidCasesLatest cas
JOIN  PortfolioProjectSQL..CovidVaxLatest vax
	ON cas.date = vax.date
WHERE cas.location = 'Philippines'
	AND people_vaccinated_per_hundred IS NOT NULL
ORDER BY date ASC

-- Mortality Rate of Cases
Select date,
    CAST(total_deaths AS FLOAT)/ CAST(total_cases AS FLOAT) AS [Death Percentage],
	total_deaths,
	total_cases
FROM PortfolioProjectSQL..CovidCasesLatest
WHERE location = 'Philippines'
	AND total_cases <> 0
ORDER BY 1 DESC

--Mortality Rate by Population
Select date, CAST(total_deaths AS FLOAT)/ CAST(population AS FLOAT) AS [Death Percentage],
	total_deaths,
	population
FROM PortfolioProjectSQL..CovidCasesLatest cas
JOIN PortfolioProjectSQL..WorldPopulation pop
	ON cas.location = pop.location
WHERE cas.location = 'Philippines'
ORDER BY 1 DESC


--Infection Rates Per Country
Select cas.location, 
	CAST(MAX(total_cases) AS FLOAT)/CAST(MAX(population) AS FLOAT) AS [Infection Rate],
	MAX(total_cases) AS [Cases], 
	MAX(population) AS Population
FROM  PortfolioProjectSQL..CovidCasesLatest cas
JOIN PortfolioProjectSQL..WorldPopulation pop
	ON cas.location = pop.location
WHERE total_cases IS NOt NULL
	AND population IS NOT NULL
	AND cas.location = 'Philippines'
GROUP BY cas.location
ORDER BY [Infection Rate] DESC


-- Vaccination and Infection Rate
Select cas.date,
	(CAST(new_cases AS FLOAT)/CAST(population AS FLOAT)* 1000) AS [Infection Rate per Thousand],
	people_vaccinated_per_hundred AS [Vaccination Rate]
FROM  PortfolioProjectSQL..CovidCasesLatest cas
JOIN PortfolioProjectSQL..WorldPopulation pop 
	ON cas.location = pop.location
JOIN PortfolioProjectSQL..CovidVaxLatest vax
	ON cas.location = vax.location
	AND cas.date = vax.date
	AND vax.people_vaccinated_per_hundred IS NOT NULL
WHERE cas.location = 'Philippines'
ORDER BY cas.date



