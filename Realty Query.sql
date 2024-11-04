Select TOP 10  * FROM PortfolioProjectSQL..Housing

----------------------------------------------------------------
--Standardize Date
Select Format(SaleDate,'MM-dd-yyyy') as SaleDate FROM PortfolioProjectSQL..Housing

ALTER TABLE PortfolioProjectSQL..Housing 
ADD SaleDateNew date

UPDATE PortfolioProjectSQL..HOUSING
SET SaleDateNew = Format(SaleDate,'MM-dd-yyyy')


--Cleaning PropertyAddress

--Cleaning Nulls in PropertyAddress
Select a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress
FROM PortfolioProjectSQL..Housing a
JOIN PortfolioProjectSQL..Housing b
	ON a.parcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjectSQL..Housing a
JOIN PortfolioProjectSQL..Housing b
	ON a.parcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

--Splitting PropertyAddress

SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1), SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+2, LEN(PropertyAddress))
FROM PortfolioProjectSQL..Housing

ALTER TABLE PortfolioProjectSQL..Housing 
ADD Street varchar(255),
    City varchar(255)

UPDATE PortfolioProjectSQL..Housing
SET Street =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


UPDATE PortfolioProjectSQL..Housing
SET City =  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+2, LEN(PropertyAddress))



--Standardize SoldAsVacant 


Select SoldAsVacant, COUNT(SoldAsVacant)
FROM PortfolioProjectSQL..Housing
GROUP BY SoldAsVacant


UPDATE PortfolioProjectSQL..Housing
SET SoldASVacant = CASE
		WHEN SoldAsVacant = 'Yes' THEN 'Y'
		WHEN SoldAsVacant = 'No' THEN 'N'
		ELSE SoldAsVacant
END

--Removing Duplicates

Select * FROM PortfolioProjectSQL..Housing

WITH DuplicateCTE AS (
SELECT *, 
	ROW_NUMBER() OVER( 
	PARTITION BY ParcelID, 
				PropertyAddress, 
				SaleDate, 
				LegalReference, 
				SoldAsVacant 
				ORDER BY [UniqueID ]
				) AS DuplicateNo
FROM  PortfolioProjectSQL..Housing
)

--DELETE 
--FROM DUplicateCTE 
--WHere DuplicateNo > 1
SELECT * FROM DuplicateCTE
WHERE DuplicateNo > 1


--Delete Unused Columns

Select * FROM PortfolioProjectSQL..Housing

ALTER TABLE PortfolioProjectSQL..Housing
DROP COLUMN SaleDate, PropertyAddress 