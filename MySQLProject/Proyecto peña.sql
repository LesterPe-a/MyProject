SELECT*
FROM porftfolioproject.coviddeaths
Where continent is not null
order by 3, 4;

-- SELECT*
 -- FROM porftfolioproject.covidvaccinations
 -- order by 3, 4
-- Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM porftfolioproject.coviddeaths
Where continent is not null
order by 1, 2;

-- Looking at total cases vs Total Deaths
-- Show likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM porftfolioproject.coviddeaths
WHERE location like '%Colombia%' and continent is not null
order by 1, 2;

-- Looking at Total cases vs population
-- Shows what percentage of population got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 AS PercentPopulationInfected
FROM porftfolioproject.coviddeaths
WHERE location like '%Colombia%' and continent is not null
order by 1, 2;

-- Looking at countries with highest Infection rate compared to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 AS PercentPopulantionInfected
FROM porftfolioproject.coviddeaths
Where continent is not null
Group by location, population 
order by PercentPopulantionInfected desc;

-- Showing countries with Highest Death count per population

SELECT location, MAX(cast(total_deaths as float)) as TotalDeathCount
FROM porftfolioproject.coviddeaths
Where continent is not null
Group by location  
order by TotalDeathCount desc;

-- Let's break thing down by continent

-- Showing the continents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as float)) as TotalDeathCount
FROM porftfolioproject.coviddeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc;



-- Global numbers
SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as float)) as total_deaths , 
SUM(cast(new_deaths as float))/SUM(new_cases)*100 as DeathPercentage
FROM porftfolioproject.coviddeaths
WHERE continent is not null
Group by date
order by 1, 2;
 
 -- USE CTE (COMMON TABLE EXPRESION)
 -- Looking at Total population vs caccinations
 With PopvsVac (continent, location, date, population, new_vaccionations, RollingPeopleVaccinated)
 as
 (
 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast( vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location, dea.date) as
RollingPeopleVaccinated -- , (RollingPeopleVaccinated/population)*100 as 
FROM porftfolioproject.coviddeaths dea
JOIN porftfolioproject.covidvaccinations vac
     ON dea.location= vac.location
     and dea.date= vac.date
where dea.continent is not null
order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac;

-- Temp TABLE
DROP TEMPORARY TABLE IF EXISTS PercentPopulationVaccinated;

Create temporary table PercentPopulationVaccinated
(
continent varchar(255), 
location varchar(255), 
date DATE, 
population numeric, 
new_vaccinations numeric,
RollingPeopleVaccinated numeric);


Insert into PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast( vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location, dea.date) as
RollingPeopleVaccinated -- , (RollingPeopleVaccinated/population)*100 as 
FROM porftfolioproject.coviddeaths dea
JOIN porftfolioproject.covidvaccinations vac
     ON dea.location= vac.location
     and dea.date= vac.date;
-- where dea.continent is not null;
-- order by 2,3

Select * , (RollingPeopleVaccinated/population)*100
From PercentPopulationVaccinated;
-- Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast( vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location, dea.date) as
RollingPeopleVaccinated -- , (RollingPeopleVaccinated/population)*100 as 
FROM porftfolioproject.coviddeaths dea
JOIN porftfolioproject.covidvaccinations vac
     ON dea.location= vac.location
     and dea.date= vac.date
where dea.continent is not null;
-- order by 2,3