SELECT * FROM portfolioproject.`covid vaccinationss`
ORDER BY 3,4

SELECT * FROM portfolioproject.`coviddeathss`
ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject.`coviddeathss`
ORDER BY 1,2

--Looking at Total cases vs Total Deaths
SELECT Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
FROM portfolioproject.`coviddeathss`
ORDER BY 1,2


--Looking at the Total Cases vs Population
--Shows what percentage of population got Covid

SELECT Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
FROM portfolioproject.`coviddeathss`
WHERE location like '%states%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount,  MAX(Total_deaths/total_cases)*100 as PercentPopulationInfected
FROM portfolioproject.`coviddeathss`
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc

-- Showing Countries with the Highest Death Count per Population

SELECT Location, MAX(CAST(Total_deaths)) as SIGNED TotalDeathCount
FROM portfolioproject.`coviddeathss`
GROUP BY Location
ORDER BY TotalDeathCount  DESC

-- Global numbers

SELECT  date, SUM(new_cases), SUM(new_deaths)  -- total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM portfolioproject.`coviddeathss`
WHERE continent is not null
GROUP BY date
ORDER BY 1,2



-- Looking at Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.Location)
FROM portfolioproject.`covid vaccinationss` dea
JOIN portfolioproject.`coviddeathss` vac
  ON dea.location = vac.location 
  and dea.date = vac date
WHERE dea.continent is not null
ORDER BY 2,3

SELECT 
    dea.continent,
    dea.location,
    dea.date,
    vac.new_vaccinations,
    ,SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS TotalVaccinations
FROM 
    portfolioproject.`covidvaccinationss` dea
JOIN 
    portfolioproject.`coviddeathss` vac
ON 
    dea.location = vac.location 
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
ORDER BY 
    dea.location, dea.date;

SELECT 
    covidvaccinationss.continent,
    covidvaccinationss.location,
    covidvaccinationss.date,
    coviddeathss.new_vaccinations,
    
    SUM(CONVERT(INT, coviddeathss.new_vaccinations)) OVER (PARTITION BY covidvaccinationss.location ORDER BY covidvaccinationss.date) AS TotalVaccinations
FROM 
    portfolioproject.`covidvaccinationss`
JOIN 
    portfolioproject.`coviddeathss`
ON 
    covidvaccinationss.location = coviddeathss.location 
    AND covidvaccinationss.date = coviddeathss.date
WHERE 
    covidvaccinationss.continent IS NOT NULL
ORDER BY 
    covidvaccinationss.location, covidvaccinationss.date
    
-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
SELECT dea.continent, 
       dea.location,
       dea.date,
       vac.new_vaccinations
	,SUM(convert(interval,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated 
    --, (RollingPeopleVaccinated/population)*100
    FROM  portfolioproject.`covidvaccinationss` dea
    JOIN portfolioproject.`coviddeathss` vac
    on dea.location = vac location
    and dea.date = vac.date
    where dea.continent is not null 
    -- order by 2,3
    
    
    
    SELECT *FROM
