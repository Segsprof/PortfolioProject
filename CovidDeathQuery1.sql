
select *
from PortfolioProject..CovidDeaths$
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

