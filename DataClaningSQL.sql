select * from NashvileHousingData;

--formatting date table 
select saledate from NashvileHousingData;

alter table nashvilehousingdata
add FormattedDate date;

update NashvileHousingData
set FormattedDate = CONVERT(date,saledate);


---- 
SELECT a.ParcelID AS a_ParcelID, 
       a.PropertyAddress AS a_PropertyAddress, 
       b.ParcelID AS b_ParcelID, 
       b.PropertyAddress AS b_PropertyAddress, 
       isnull(a.PropertyAddress, b.PropertyAddress) AS CorrectedPropertyAddress
FROM NashvileHousingData a
JOIN NashvileHousingData b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvileHousingData a
JOIN NashvileHousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;

select PropertyAddress from NashvileHousingData;

SELECT
    ParcelID,
    MAX(PropertyAddress) AS CorrectedPropertyAddress
FROM
    NashvileHousingData
GROUP BY
    ParcelID

select count(PropertyAddress) as Countingnull
from NashvileHousingData
where PropertyAddress is null;

SELECT COUNT(*) AS NullPropertyAddressCount
FROM NashvileHousingData
WHERE PropertyAddress IS not NULL



-- Breaking out Address into Individual Columns (Address, City, State)

SELECT 
    LEFT(PropertyAddress, CHARINDEX(',', PropertyAddress) - 1) AS Address,
    LTRIM(RTRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress)))) AS City
    
FROM 
    NashvileHousingData

---different query
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
From NashvileHousingData;


alter table nashvilehousingdata
add Address nvarchar(255);

update NashvileHousingData
set Address= SUBSTRING(propertyaddress, 1, charindex(',',propertyaddress)-1);


select address from NashvileHousingData;


alter table nashvilehousingdata
add City nvarchar(255);

update NashvileHousingData
set City= SUBSTRING(propertyaddress, charindex(',',propertyaddress)+1,len(propertyaddress));


select city from NashvileHousingData;

--- 
select owneraddress from NashvileHousingData;

SELECT
SUBSTRING(owneraddress, 1, CHARINDEX(',', owneraddress) -1 ) as LandlordAddress
, SUBSTRING(owneraddress, CHARINDEX(',', owneraddress) + 1 , LEN(owneraddress)) as LandlordCity,
SUBSTRING(owneraddress, CHARINDEX(',', owneraddress) +1 , LEN(owneraddress)) as LandlordStreet
From NashvileHousingData;

SELECT
    SUBSTRING(owneraddress, 1, CHARINDEX(',', owneraddress) - 1) AS StreetAddress,
    LTRIM(RTRIM(SUBSTRING(owneraddress, CHARINDEX(',', owneraddress) + 1, CHARINDEX(',', owneraddress, CHARINDEX(',', owneraddress) + 1) - CHARINDEX(',', owneraddress) - 1))) AS City,
    RIGHT(owneraddress, LEN(owneraddress) - CHARINDEX(',', owneraddress, CHARINDEX(',', owneraddress) + 1)) AS State
FROM
    NashvileHousingData;


--------
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvileHousingData;

ALTER TABLE NashvileHousingData
Add LandlordAddress Nvarchar(255);

Update NashvileHousingData
SET LandlordAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvileHousingData
Add LandlordCity Nvarchar(255);

Update NashvileHousingData
SET LandlordCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvileHousingData
Add LandlordState Nvarchar(255);

Update NashvileHousingData
SET LandlordState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select * from NashvileHousingData;


-- Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvileHousingData
Group by SoldAsVacant
order by 2

select SoldAsVacant,
       Case  when soldasvacant='Y' then 'Yes'
	   when soldasvacant='N' then 'No'
	   else soldasvacant
	   End as FormattedSoldCol
from NashvileHousingData;

update nashvilehousingdata
set  SoldAsVacant= Case  when soldasvacant='Y' then 'Yes'
	   when soldasvacant='N' then 'No'
	   else soldasvacant
	   End;

-- Remove Duplicates
with duplirows 
as
( select * , 
ROW_NUMBER() over ( partition by 
ParcelID, PropertyAddress, SalePrice,SaleDate,LegalReference ORDER BY UniqueID) Row_num
from NashvileHousingData;

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvileHousingData
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

-- Delete Unused Columns



Select *
From NashvileHousingData;


ALTER TABLE nashvilehousingdata
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


Select *
From NashvileHousingData;
