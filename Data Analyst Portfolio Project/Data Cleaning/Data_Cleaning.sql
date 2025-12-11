/*

Cleaning Data in SQL Queries

*/

USE Portfolio
Go

Select *
From NashvilleHousing


---------------------------------------------------------------------------------------------------

-- Standardize Date Format 

Select SaleDateConverted, CONVERT(Date, SaleDate)
From Portfolio.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate= CONVERT(Date, SaleDate)
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted= CONVERT(Date, SaleDate)



---------------------------------------------------------------------------------------------------

-- Populate Property Addres data

Select *
From Portfolio.dbo.NashvilleHousing
-- Where PropertyAddress is null
order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a 
JOIN Portfolio.dbo.NashvilleHousing b
     ON a.ParcelID= b.ParcelID
     and a.[UniqueID]<> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a 
JOIN Portfolio.dbo.NashvilleHousing b
     ON a.ParcelID= b.ParcelID
     and a.[UniqueID]<> b.[UniqueID]
Where a.PropertyAddress is null



---------------------------------------------------------------------------------------------------

-- Breaking out Addres Individual Colums (Address, City, State)

Select PropertyAddress
From Portfolio.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From Portfolio.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255)


Update NashvilleHousing
SET PropertySplitAddress= SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 


Select *

From Portfolio.dbo.NashvilleHousing




Select
PARSENAME(REPLACE(OwnerAddress, ',' , '.' ),3)
,PARSENAME(REPLACE(OwnerAddress, ',' , '.' ),2)
,PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) ,1)
From Portfolio.dbo.NashvilleHousing





ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress, ',' , '.' ),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress, ',' , '.' ),2) 


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) ,1)


Select *
From Portfolio.dbo.NashvilleHousing













select *
from Portfolio.dbo.NashvilleHousing



---------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From Portfolio.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant ,
CASE When SoldAsVacant = '1' THEN 'YES'
     WHEN SoldASVacant = '0' THEN 'NO'
     ELSE CONVERT(varchar, SoldAsVacant)
     END 
From Portfolio.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ALTER COLUMN SoldAsVacant VARCHAR(255);

Update NashvilleHousing
Set SoldAsVacant= 
CASE When SoldAsVacant = '1' THEN 'YES'
     WHEN SoldASVacant = '0' THEN 'NO'
     ELSE CONVERT(varchar, SoldAsVacant)
     END 


---------------------------------------------------------------------------------------------------


--Remove Duplicates
WITH RowNumCTE AS(

SELECT *,
    ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
                 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
                 ORDER BY
                       UniqueID
                       ) row_num

FROM Portfolio.dbo.NashvilleHousing
--Order by ParcelID
)
   Select *
    From RowNumCTE
Where row_num > 1
Order by PropertyAddress
---------------------------------------------------------------------------------------------------

-- Delete Unused Column

Select *
FROM Portfolio.dbo.NashvilleHousing


ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN SaleDate
--DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress



---------------------------------------------------------------------------------------------------

















---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
