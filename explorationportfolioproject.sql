Select *
from portfolio_schema.coviddeaths
order by 3,4;

-- Select *
-- From portfolio_schema.covidvaccinations
-- order by 3,4

-- Looking at total cases vs. total deaths. 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portfolio_schema.coviddeaths
Order by 1,2;

-- Focusing on United States
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portfolio_schema.coviddeaths
Where location like '%states%'
Order by 1,2;

-- Looking at total cases vs population.
-- Shows what percentage of the United States population got covid
Select location, date, total_cases, population, (total_deaths/population)*100 as PopulationInfected
From portfolio_schema.coviddeaths
Where location like '%states%'
Order by 1,2;

-- Now not looking at just the United States.
Select location, date, total_cases, population, (total_deaths/population)*100 as PopulationInfected
From portfolio_schema.coviddeaths
-- Where location like '%states%'
Order by 1,2;

-- Looking at countries with highest infection rate compared to population
Select location, population, max(total_cases) as HighestInfectionRate, max((total_deaths/population))*100 as PopulationInfected
From portfolio_schema.coviddeaths
Group By location, population
-- Where location like '%states%'
Order by PopulationInfected desc;

-- Showing countries with highest death count per population.
Select location, max(cast(total_deaths as unsigned)) as TotalDeathCount
From portfolio_schema.coviddeaths
Where continent is not null
Group By location
-- Where location like '%states%'
order by totaldeathcount desc;
 
 -- Breaking it down by continent. 
 -- Showing continents with the highest death count per population
 Select continent, max(cast(total_deaths as unsigned)) as TotalDeathCount
From portfolio_schema.coviddeaths
Where continent is not null
Group By continent
order by totaldeathcount desc;

-- Global Numbers
Select sum(new_cases) as total_cases, sum(cast(new_deaths as unsigned)) as total_deaths, sum(cast(new_deaths as unsigned))/sum(new_cases)*100 as DeathPercentage
From portfolio_schema.coviddeaths
where continent is not null
order by 1, 2;

-- Joining the two tables. 
select *
from portfolio_schema.coviddeaths dea
join portfolio_schema.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date;

-- Using CTE
with PopvsVAC (Continent, Location, Date, Population, New_vaccinations, RollingVaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingVaccinations
from portfolio_schema.coviddeaths dea
join portfolio_schema.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingVaccinations/Population)*100
from PopvsVac;

-- Creating a temp table 
Use portfolio_schema;
Drop Table if exists PercentPopulationVaccinated;
Create Table PercentPopulationVaccinated (
Continent char(255) not null,
Location char(225) not null,
Date datetime,
Population int unsigned,
New_Vaccinations int unsigned,
RollingPeopleVaccinated int unsigned
);
Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, cast(dea.population as unsigned), cast(vac.new_vaccinations as unsigned)
, sum(cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingVaccinations
from portfolio_schema.coviddeaths dea
join portfolio_schema.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null;
select *, (RollingVaccinations/Population)*100
from PopvsVac;

-- Creating view for later data visualizations. 
use portfolio_schema;
create view PercentPopulationVacc as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingVaccinations
from portfolio_schema.coviddeaths dea
join portfolio_schema.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date;

select *
from percentpopulationvacc;

-- Queries used for Tableu Visualizations

-- Table 1
SELECT sum(new_cases) as total_cases, sum(cast(new_deaths as signed)) as total_deaths, sum(cast(new_deaths as signed))/sum(new_cases)*100 as DeathPercentage
from portfolio_schema.coviddeaths
where continent is not null
order by 1,2;

-- Table 2
select location, sum(cast(new_deaths as signed)) as TotalDeathCount
from portfolio_schema.coviddeaths
where continent = ''
and location not in ('European Union', 'International', 'World')
Group by location
Order by TotalDeathCount desc;

-- Table 3
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population)*100) as PercentPopulationInfected
from portfolio_schema.coviddeaths
group by location, population
order by PercentPopulationInfected desc;

-- Table 4
Select location, population, date, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from portfolio_schema.coviddeaths
group by location, population, date
order by PercentPopulationInfected desc;

Select *
from portfolio_schema.coviddeaths
where location = 'Asia
';

-- this guided project is incredibly outdated, I'm having a ton of problems with it, I'm going to drop it. 