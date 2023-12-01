Select *
From [Project Portfolio].dbo.[NashvilleHousing]

-- Standardize Date Format

Select SaleDate, CONVERT(Date,SaleDate)
From [Project Portfolio].dbo.[NashvilleHousing]


-------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [Project Portfolio].dbo.NashvilleHousing
--WHERE PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Project Portfolio].dbo.NashvilleHousing a
JOIN [Project Portfolio].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Project Portfolio].dbo.NashvilleHousing a
JOIN [Project Portfolio].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


---------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Project Portfolio].dbo.NashvilleHousing
--WHERE PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address

From [Project Portfolio].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
From [Project Portfolio].dbo.NashvilleHousing



SELECT OwnerAddress
From [Project Portfolio].dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From [Project Portfolio].dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)



------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

/*
SELECT DISTINCT SoldAsVacant
FROM [Project Portfolio].dbo.NashvilleHousing

SELECT SoldAsVacant,
  CASE
    WHEN SoldAsVacant = 0 THEN 'No'
    WHEN SoldAsVacant = 1 THEN 'Yes'
    ELSE NULL
  END 
FROM [Project Portfolio].dbo.NashvilleHousing;


----UPDATE [Project Portfolio].dbo.NashvilleHousing
SET SoldAsVacant = 
  CASE
    WHEN SoldAsVacant = 0 THEN 'No'
    WHEN SoldAsVacant = 1 THEN 'Yes'
    ELSE SoldAsVacant
  END;
#Conversion failed when converting the varchar value 'No' to data type bit.*/


------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

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

From [Project Portfolio].dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
From RowNumCTE
Where row_num >1
Order by PropertyAddress


-----------------------------------------------------------------------------------------------------------------

-- Delete Unusued Columns



Select *
From [Project Portfolio].dbo.NashvilleHousing

ALTER TABLE [Project Portfolio].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
