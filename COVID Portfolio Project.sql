
select *
from PortfolioProject..CovidDeaths$
Where continent is not null
order by 3,4

--select *
--from PortfolioProject..Vaccination$
--order by 3,4

-- Select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelyhood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location like 'Nigeria'
order by 1,2

-- Looking at the total Cases vs Population

select location, date, population, total_cases, (total_deaths/population)*100 as PopulationPercentage
from PortfolioProject..CovidDeaths$
where location like 'Nigeria'
order by 1,2

-- Looking at country with highest infection rate

select location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as 
	PercentPopulationInfected
from PortfolioProject..CovidDeaths$
--where location like 'Nigeria'
where continent is not null
group by location, population
order by PercentPopulationInfected desc

-- Showing countries with the highest Death Count per Population

select continent, max(Cast(Total_deaths as int)) as TotalDeathCount
	from PortfolioProject..CovidDeaths$
--where location like 'Nigeria'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Lets Break down by continents

select continent, max(Cast(Total_deaths as int)) as TotalDeathCount
	from PortfolioProject..CovidDeaths$
--where location like 'Nigeria'
where continent is not null
group by continent
order by TotalDeathCount desc


-- looking at Global Numbers

select sum(new_cases) as Total_NewCases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast
(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

-- Looking at Total Populatin vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..Vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
  dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..Vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--USE CTE
with PopvsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
  dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..Vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac