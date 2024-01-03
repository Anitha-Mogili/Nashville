
-- Cleaning data using SQL Queries


select * 
from PortfolioProject..NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------

-- Date Column


select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProject..NashvilleHousing


Alter table NashvilleHousing
Add SaleDateConverted Date;


update NashvilleHousing
set SaleDateConverted = Convert(Date, SaleDate)


select SaleDateConverted
from PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data where Null


select PropertyAddress
from NashvilleHousing
where PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set a.PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

---------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into individual Columns (Address, City, State)

select PropertyAddress
from NashvilleHousing

select PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from NashvilleHousing

Alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

Alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));


select OwnerAddress
from NashvilleHousing


select OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3) as OwnerSplitAddress,
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2) as OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1) as OwnerSplitState
from NashvilleHousing

Alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3);

Alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2);

Alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

Update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1);


----------------------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in 'SoldasVacant' field

select SoldasVacant
from NashvilleHousing


SELECT DISTINCT(SoldasVacant), Count(SoldasVacant)
from NashvilleHousing
Group by SoldAsVacant
order by 2

SELECT SoldasVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldasVacant = 'N' THEN 'No'
	ELSE SoldasVacant
	END
from NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldasVacant = 'N' THEN 'No'
	ELSE SoldasVacant
	END


----------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE as(
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				  LandUse,
				  PropertyAddress,
				  SaleDate,
				  SalePrice,
				  OwnerName,
				  OwnerAddress
				  order by UniqueID) as row_num
from PortfolioProject..NashvilleHousing
)
select *  
from RowNumCTE
where row_num > 1
--order by PropertyAddress


------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select * 
from PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate