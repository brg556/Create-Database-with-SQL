# GearZone Retail - SQL Data Analyse

## Project Description
This project involves the design, modelling and analysis of a relational database for **GearZone**, a fictional company selling sports and outdoor equipment.

The objective was to transform raw data into actionable information for decision-making (Business Intelligence), covering the entire data lifecycle: from table creation to complex sales analysis.

## Demonstrated Technical Skills
* **Data Modelling (DDL):**
* Creation of structured tables with precise typing (`VARCHAR`, `DATE`, `INTEGER`).
* Integrity constraint management: Primary Keys (PK) and Foreign Keys (FK).
    * Data security with `ON DELETE RESTRICT` to prevent accidental deletion of history.
* **Data Manipulation (DML):**
* Data insertion and cleaning (management of heterogeneous formats such as `“S1”`, `“1-1-111”`).
    * Correction of insertion errors (resolution of foreign key constraint violations).
* **Advanced Analysis (DQL):**
* **Complex joins:** Queries involving up to 5 interconnected tables (`INNER JOIN`).
    * **Aggregation functions:** KPI calculations with `SUM()`, `COUNT()`, and `GROUP BY`.
* **Reporting:** Sorting and filtering results (`ORDER BY`, `LIMIT`).

## Database Structure
The project is structured around interconnected relational tables:
* `Region` & `Store`: Geographical management of points of sale.
* `Product`, `Category` & `Vendor`: Product and supplier catalogue.
* `SalesTransaction` & `Includes`: Fact table recording transactions and details of items sold.

## Analysis Examples (Business Queries)

### 1. Analysis of Turnover by Region
**Problem:** Identify the most financially successful geographical areas.
**Technical challenge:** Linking the `Region` table to the `Product` price requires traversing five tables via cascading joins.

```SQL
SELECT 
    Region.RegionName, 
    SUM(Product.ProductPrice * Includes.Quantity) AS ChiffreAffaires
FROM Region
INNER JOIN Store ON Region.RegionID = Store.RegionID
INNER JOIN SalesTransaction ON Store.StoreID = SalesTransaction.StoreID
INNER JOIN Includes ON SalesTransaction.TransactionID = Includes.TransactionID
INNER JOIN Product ON Includes.ProductID = Product.ProductID
GROUP BY Region.RegionName
ORDER BY ChiffreAffaires DESC;
```

### 2. Top 3 Best Sellers
**Problem:**
Identifying the most successful products is crucial for inventory management. The goal is to identify the products that generate the most financial value, not just those that are sold most often (distinction between volume and value).

**Technical solution:**
This query uses a double aggregation:
1.  `SUM(Quantity)` for total volume.
2.  `SUM(Price * Quantity)` for total revenue.
Sorting is performed on revenue (`ORDER BY ... DESC`) and restricted to the first 3 results (`LIMIT 3`) for immediate reporting.

```sql
SELECT 
    Product.ProductName, 
    SUM(Includes.Quantity) AS TotalQuantitySold,
    SUM(Product.ProductPrice * Includes.Quantity) AS TotalSalesAmount
FROM Product
INNER JOIN Includes ON Product.ProductID = Includes.ProductID
GROUP BY Product.ProductName
ORDER BY TotalSalesAmount DESC
LIMIT 3;
```
