--select *
--from PortfolioProject..CovidDeaths
--order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

--select Location, date, total_cases, new_cases, total_deaths, population
--from PortfolioProject..CovidDeaths
--order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Show likelihood of dying if you contract covid in your country
--select Location, date, total_cases,  total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where continent is not null
--order by 1,2

--select Location, date, total_cases,  total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
--order by 1,2

-- Looking at Total Cases vs Population 
--select Location, date, total_cases,  population,(total_cases/population)*100 as PercentPopulationInfected
--from PortfolioProject..CovidDeaths
--where location like '%states%'
--order by 1,2

-- Looking at countries with Highest Infection Rate compared to Population
--select Location, population, max(total_cases) as HighestInfectionCount,  max(total_cases/population)*100 as PercentPopulationInfected
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by location, population
--order by PercentPopulationInfected desc

-- Showing Countries with highest Death Count per Population

--select Location, max(convert(int, Total_deaths)) as TotalDeathCount
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by location
--order by TotalDeathCount desc

--select Location, max(cast(Total_deaths as int )) as TotalDeathCount
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by location
--order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

--select Location, max(cast(Total_deaths as int )) as TotalDeathCount
--from PortfolioProject..CovidDeaths
--where continent is null
--group by location
--order by TotalDeathCount desc


--select location, continent
--from CovidDeaths

--select location
--from CovidDeaths
--where location is not null

 --Showing Continents with highest Death Count per Population
--select continent, max(cast(Total_deaths as int )) as TotalDeathCount
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by continent
--order by TotalDeathCount desc

--GLOBAL NUMBERS
--total cases accross the world on each day 
--select date, SUM(new_cases) as SumOfNewCases
--from PortfolioProject..CovidDeaths
--where continent IS NOT NULL
--group by date
--order by 1,2

--total deaths accross the world on each day 
--select date, SUM(new_cases) as SumOfNewCases, sum(cast(new_deaths as int))  as SumOfNewDeaths
--from PortfolioProject..CovidDeaths
--where continent IS NOT NULL
--group by date
--order by 1,2

--Death percentage accross the globe by dates
--select date, SUM(new_cases)  as total_cases, sum (cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where continent IS NOT NULL
--group by date
--order by 1,2

--Death percentage accross the globe in general
--select  SUM(new_cases)  as total_cases, sum (cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where continent IS NOT NULL
----group by date
--order by 1,2

--select *
--from CovidDeaths

--select *
--from CovidVaccinations

--Join two files coviddeaths and covidvaccinations on location and date
--select *
--from CovidDeaths dea
--join CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date

-- Looking at Total Population vs vaccinations(total people in the world that has been vaccinated)
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--from CovidDeaths dea
--join CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent IS NOT NULL
--order by 2,3

--Rolling Count
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, sum (convert(int,vac.new_vaccinations)) over (partition by dea.location)
--from CovidDeaths dea
--join CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent IS NOT NULL
--order by 2,3

--Adding-up no. of vaccinated by location and date i.e cumunative
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, sum (convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--from CovidDeaths dea
--join CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent IS NOT NULL
--order by 2,3

--USING CTE OR TEMP TABLE WILL GIVE SAME RESULT
-- USE CTE  -- Using CTE, Looking at Total Population vs vaccinations(how many are vaccinated)
--with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
--as
--(
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, sum (convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--from CovidDeaths dea
--join CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent IS NOT NULL
----order by 2,3
--)
--select *, (RollingPeopleVaccinated/population)*100 as PopVasPercentage
--from PopvsVac

-- you can try max percentage, diffent counts or one for each without date

--TEMP TABLE
--drop table if exists #PercentPopulationVaccinated
--create table #PercentPopulationVaccinated
--( continent nvarchar(255),
-- location nvarchar (255),
-- Date datetime,
-- Population numeric,
-- new_vaccinations numeric, 
-- RollingPeopleVaccinated numeric)

--insert into #PercentPopulationVaccinated
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, sum (convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) 
--as RollingPeopleVaccinated
--from CovidDeaths dea
--join CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent IS NOT NULL
----order by 2,3

--select *, (RollingPeopleVaccinated/population)*100 as PercentageofRollingPoepleVaccinated
--from #PercentPopulationVaccinated

--creating View to Store Data for later Visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum (convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent IS NOT NULL
--order by 2,3

Select *
From PercentPopulationVaccinated