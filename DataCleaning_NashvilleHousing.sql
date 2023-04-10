

SELECT *
FROM PortfolioProject..NashvilleHousing

-- CLEANING SQL QUERIES 


-- STANDARDISE DATE FORMAT 

SELECT SaleDate
FROM PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing 
add SaleDateConverted Date;

Update PortfolioProject..NashvilleHousing
set SaleDateConverted =  Convert(Date,saledate)

SELECT SaleDateConverted
FROM PortfolioProject..NashvilleHousing

------------------------------------------------------------------------------------------------------------
-- Populate Property Address Data

SELECT *
FROM PortfolioProject..NashvilleHousing

-- Null values in PropertyAddress

SELECT *
FROM PortfolioProject..NashvilleHousing
where PropertyAddress is null
order by ParcelID




SELECT a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress ,isnull(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress =isnull(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-- now there is no null value in PropertyAddress 

----------------------------------------------------------------------------------------------------

-- Breaking  out Address Into Individual Columns ( Address,City,state)

-- property address

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

Select 
substring(propertyAddress,1,charindex(',', propertyaddress)-1) as Address ,
substring(propertyAddress,charindex(',', propertyaddress)+1, Len(propertyAddress)) as Address 
from PortfolioProject..NashvilleHousing


alter table PortfolioProject..NashvilleHousing 
add PropertySplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
set PropertySplitAddress =  substring(propertyAddress,1,charindex(',', propertyaddress)-1) 


alter table PortfolioProject..NashvilleHousing 
add PropertySplitcity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
set PropertySplitcity =  substring(propertyAddress,charindex(',', propertyaddress)+1, Len(propertyAddress)) 

select *
from PortfolioProject..NashvilleHousing



select OwnerAddress
from PortfolioProject..NashvilleHousing



-- owner address 

select
parsename(replace(OwnerAddress ,',','.') ,3 ),
parsename(replace(OwnerAddress ,',','.') ,2 ),
parsename(replace(OwnerAddress ,',','.') ,1 )
from PortfolioProject..NashvilleHousing
--where OwnerAddress is not null





alter table PortfolioProject..NashvilleHousing 
add ownerSplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
set ownerSplitAddress =  parsename(replace(OwnerAddress ,',','.') ,3 )


alter table PortfolioProject..NashvilleHousing 
add ownerSplitcity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
set ownerSplitcity =  parsename(replace(OwnerAddress ,',','.') ,2 )

alter table PortfolioProject..NashvilleHousing 
add ownerSplitState Nvarchar(255);

Update PortfolioProject..NashvilleHousing
set ownerSplitState =  parsename(replace(OwnerAddress ,',','.') ,1 )


select *
from PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------------------------
-- changing Y & N to Yes & No in "Solid as Vacant" field 

select distinct(SoldAsVacant) , count(SoldAsVacant)
from PortfolioProject..NashvilleHousing

group by SoldAsVacant
order by 2




select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
set SoldAsVacant  = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

------------------------------------------------------------------------
-- Remove duplicates

with RowNumCTE As(
select *,
row_number() over(
partition by parcelID,
	         propertyAddress,
			 saleprice,
			 saleDate,
			 legalreference
			 order by
			 uniqueID) row_num 

from PortfolioProject..NashvilleHousing
--order by ParcelId
)
 select *
from RowNumCTE
where Row_num>1
--order by PropertyAddress

----------------------------------------------------------------------------------------------
-- Delete unused columns

select *
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress, taxDistrict ,PropertyAddress

alter table PortfolioProject..NashvilleHousing
drop column saleDate