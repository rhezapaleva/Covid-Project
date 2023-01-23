-- Looking at total cases vs total Deaths

-- Shows likelihood of dying if you contract covid in Indonesia

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
From PortofolioProject..CovidDeath
 Where location = 'Indonesia'
Order by 1,2
	
----Looking at Total cases vs Population
----Shows what percentage of population in Indonesia got Covid
Select Location, date, total_cases, population, (total_cases/population) *100 as PopulationPercentage
From PortofolioProject..CovidDeath
Where location = 'Indonesia' 
Order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max ((total_cases/population)) *100 as PercentPopulationInfected
From PortofolioProject..CovidDeath
Group by Location, Population
Order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select Location, Population, Max(cast(total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeath
where continent is not null
Group by Location, Population
Order by TotalDeathCount desc

-- Let's break things down by continent

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeath
where continent is not null
Group by continent
Order by TotalDeathCount desc

--Breaking things by continnent

-- Showing continents with the highest death count per population

--Global Numbers
Select SUM(new_cases) as totalCase, SUM(cast(new_deaths as float)) as newDeath, SUM(cast(new_deaths as float))/SUM(new_cases) *100 as Death
From PortofolioProject..CovidDeath 
Where continent is not null
Order by 1,2


	--Looking at total population vs vaccinations
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeath dea
Join PortofolioProject..CovidVaccinations vac
		On dea.location = vac.location
		and dea.date=vac.date
where dea.continent is not null


-- USE CTE

With PopvsVac (Continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeath dea
Join PortofolioProject..CovidVaccinations vac
		On dea.location = vac.location
		and dea.date=vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated /Population)*100
From popvsvac

-- Temp Table
DROP TABLE I
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)


Insert into #PercentPopulationVaccinated 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeath dea
Join PortofolioProject..CovidVaccinations vac
		On dea.location = vac.location
		and dea.date=vac.date
where dea.continent is not null

Select *, (RollingPeopleVaccinated /Population)*100
from #PercentPopulationVaccinated 

--Create view to store data for later visualizations


Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeath dea
Join PortofolioProject..CovidVaccinations vac
		On dea.location = vac.location
		and dea.date=vac.date
where dea.continent is not null

--a
Select * from PercentPopulationVaccinated