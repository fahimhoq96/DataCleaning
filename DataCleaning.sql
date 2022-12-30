/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Housing].[dbo].[Nashville]

  -- standarize date format
  
  Select SaleDate
  From Housing.dbo.Nashville

  Select Convert(Date, SaleDate) as SaleDates
  From Housing.dbo.Nashville

 Alter Table Nashville
 Add SaleDates Date 
 
Update Nashville
Set SaleDates = Convert(Date, SaleDate)
  
Select SaleDates
From Housing.dbo.Nashville

  -- populate address

  Select *
  From Housing.dbo.Nashville
  where PropertyAddress is Null

  Select *
  From Housing.dbo.Nashville
  order by ParcelID

  Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress
  From Housing.dbo.Nashville as A
  Join Housing.dbo.Nashville as B
  on A.ParcelID = B.ParcelID
  And A.[UniqueID ] <> B.[UniqueID ]
  where B.PropertyAddress is Null 

  Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, isnull(B.PropertyAddress,A.PropertyAddress)
  From Housing.dbo.Nashville as A
  Join Housing.dbo.Nashville as B
  on A.ParcelID = B.ParcelID
  And A.[UniqueID ] <> B.[UniqueID ]
  where B.PropertyAddress is Null 

  Update B
  Set PropertyAddress = isnull(B.PropertyAddress,A.PropertyAddress)
  From Housing.dbo.Nashville as A
  Join Housing.dbo.Nashville as B
  on A.ParcelID = B.ParcelID
  And A.[UniqueID ] <> B.[UniqueID ]
  where B.PropertyAddress is Null

  -- Breakingout address into individual columns
  
    Select *
  From Housing.dbo.Nashville

  Select OwnerAddress
  From Housing.dbo.Nashville

  Select
  PARSENAME(REPLACE(OwnerAddress,',','.'),3) as OwnerAddress,
  PARSENAME(REPLACE(OwnerAddress,',','.'),2) as city,
  PARSENAME(REPLACE(OwnerAddress,',','.'),1) as ST 
  From Housing.dbo.Nashville

  Alter Table Nashville
  Add Owner_Address Nvarchar(512);

  Alter Table Nashville
  Add OwnerCity Nvarchar(512);

  Alter Table Nashville
  Add OwnerState Nvarchar(512);

  Update Nashville
  Set Owner_Address = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

  Update Nashville
  Set OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

  Update Nashville
  Set OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

  Select *
  From Housing.dbo.Nashville



  Select PropertyAddress
  From Housing.dbo.Nashville

  Select PropertyAddress,
  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
  From Housing.dbo.Nashville

  Alter Table Nashville
  Add Property_Address Nvarchar(512);
  Alter Table Nashville
  Add Property_City Nvarchar(512);


  Update Nashville
  Set Property_Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
  Update Nashville
  Set Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

  Select *
  From Housing.dbo.Nashville

  


  -- Change 'Y' & 'N' to 'Yes' & 'No' respectively in "Sold as Vacant" field

  Select Distinct (SoldAsVacant) 
  From Housing.dbo.Nashville

  Select Distinct (SoldAsVacant), Count(SoldAsVacant) as C0unt
  From Housing.dbo.Nashville
  group by SoldAsVacant
  order by 2

  Select SoldAsVacant,
  Case When SoldAsVacant = 'Y' Then 'Yes'
  When SoldAsVacant = 'N' Then 'No'
  Else SoldAsVacant
  End
  From Housing.dbo.Nashville

  Update Nashville
  Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
  When SoldAsVacant = 'N' Then 'No'
  Else SoldAsVacant
  End


  --deleting unused columns

  Select *
  From Housing.dbo.Nashville

  Alter Table Housing.dbo.Nashville
  drop column SaleDate, OwnerAddress, PropertyAddress

   Select *
  From Housing.dbo.Nashville
