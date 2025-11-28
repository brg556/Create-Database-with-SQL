--Creating the Region table
CREATE TABLE Region
(RegionID TEXT CHECK (length(RegionID) <= 2) PRIMARY KEY,
RegionName TEXT);

--Creating the Store table
CREATE TABLE Store
(StoreID VARCHAR(2) PRIMARY KEY,
StoreZip INTEGER NOT NULL,
RegionID TEXT CHECK (length(RegionID) <= 2),
FOREIGN KEY (RegionID) REFERENCES Region(RegionID));

--Creating the Product table
CREATE TABLE Product
(ProductID VARCHAR(3) PRIMARY KEY,
ProductName Text NOT NULL,
ProductPrice REAL NOT NULL);

--Creating the Vendor table
CREATE TABLE Vendor
(VendorID TEXT CHECK (length(VendorID) <= 2) PRIMARY KEY,
VendorName TEXT NOT NULL);

--Add Foreign Key - VendorID
ALTER TABLE product
ADD VendorID INTEGER
REFERENCES vendor(VendorID)
ON DELETE SET NULL;

--Creating the Category table
CREATE TABLE Category
(CategoryID TEXT CHECK (length(CategoryID) <= 2) PRIMARY KEY,
CategoryName TEXT NOT NULL);

--Add CategoryID - VendorID
ALTER TABLE product
ADD CategoryID INTEGER
REFERENCES Category(CategoryID)
ON DELETE SET NULL;

--Creating the Customer table
CREATE TABLE Customer
(CustomerID VARCHAR(15) PRIMARY KEY,
CustomerName TEXT NOT NULL,
CustomerZIP INTEGER NOT NULL);

--Creating the SalesTransaction table
CREATE TABLE SalesTransaction
(TID VARCHAR(5) PRIMARY KEY,
CustomerID VARCHAR(15) NOT NULL,
StoreID VARCHAR(2) NOT NULL,
TDate DATE NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY (StoreID) REFERENCES Store(StoreID));

--Creating the Includes table
CREATE TABLE Includes
(ProductID VARCHAR(3) NOT NULL,
TID VARCHAR(5) NOT NULL,
Quantity INTEGER NOT NULL,
FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
FOREIGN KEY (TID) REFERENCES SalesTransaction(TID));

--Insert content in Region table
INSERT INTO Region (RegionID, RegionName)
VALUES
    ('MR', 'Mountain Region'),
    ('CR', 'Coastal Region'),
    ('FR', 'Forest Region');
    
--Insert content in Store table
INSERT INTO Store (StoreID, StoreZIP, RegionID)
VALUES
    ('S1', 80202, 'MR'),
    ('S2', 94105, 'MR'),
    ('S3', 30303, 'CR'),
    ('S4', 65709, 'FR');
    
--Insert content in Product table
INSERT INTO Product (ProductID, ProductName, ProductPrice, VendorID, CategoryID)
VALUES
    ('1A1' , 'Trail Backpack', 120, 'GS', 'CG'),
    ('2B2', 'Hiking Boots',	85, 'TM', 'FW'),
    ('3C3', 'Cozy Socks', 20, 'TM', 'FW'),
    ('4D4', 'Rainproof Jacket', 95, 'GS', 'FW'),
    ('5E5', 'Compact Tent', 180, 'TM', 'CG'),
    ('6F6', 'Explorer Tent', 300, 'TM', 'CG'),
    ('7G7', 'Sunglasses', 115, 'GS', 'EW');
    
--Insert content in Vendor table
INSERT INTO Vendor (VendorID, VendorName)
VALUES
    ('GS' , 'Gear Supplies Co.'),
    ('TM', 'Trail Master Equipment');
    
--Insert content in Category table
INSERT INTO Category (CategoryID, CategoryName)
VALUES
    ('CG' , 'Camping Gear'),
    ('FW', 'Footwear'),
    ('EW', 'Eyeswear');
    
--Insert content in Customer table
INSERT INTO Customer (CustomerID, CustomerName, CustomerZip)
VALUES
    ('1-1-111', 'Alex',	80202),
    ('2-2-222', 'Jordan', 94105),
    ('3-3-333', 'Taylor', 30303);

--Insert content in SalesTransaction table    
INSERT INTO SalesTransaction (TID,CustomerID,StoreID,TDate)
VALUES
    ('T101', '1-1-111',	'S1', '2022-01-01'),
    ('T202', '2-2-222',	'S2', '2022-01-01'),
    ('T303', '1-1-111',	'S3', '2022-01-02'),
    ('T404', '3-3-333',	'S3', '2022-01-02'),
    ('T505', '2-2-222',	'S3', '2022-01-02'),
    ('T606', '3-3-333',	'S4', '2022-01-03');
    
--Insert content in Includes table
INSERT INTO Includes (ProductID,TID,Quantity)
VALUES
    ('1A1', 'T101', 1),
    ('2B2', 'T202', 1),
    ('3C3', 'T303', 3),
    ('1A1', 'T303', 1),
    ('4D4', 'T404', 2),
    ('2B2', 'T404', 1),
    ('4D4', 'T505', 4),
    ('5E5', 'T505', 2),
    ('6F6', 'T505', 1),
    ('7G7',	'T606',	5);
    
--What are the 3 Best-Sellers Products ?
Select Product.ProductID, Product.ProductName, Product.ProductPrice,
SUM(Includes.Quantity) AS TotalQuantity,
SUM(Product.ProductPrice*Includes.Quantity) AS TotalSales
FROM Product
INNER JOIN Includes
ON Product.ProductID = Includes.ProductID
GROUP BY Product.ProductID, Product.ProductName
ORDER BY TotalSales DESC
LIMIT 3;

--What is the ranking of regions by turnover ?
SELECT Region.RegionID, Region.RegionName,
SUM(Product.ProductPrice * Includes.Quantity) AS Turnover
FROM Region
INNER JOIN Store ON Region.RegionID = Store.RegionID
INNER JOIN SalesTransaction ON SalesTransaction.StoreID = Store.StoreID
INNER JOIN Includes ON Includes.TID = SalesTransaction.TID
INNER JOIN Product ON Product.ProductID = Includes.ProductID
GROUP BY Region.RegionID, Region.RegionName
ORDER BY Turnover DESC;