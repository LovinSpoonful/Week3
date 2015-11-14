-- SQL WEEK 3 HANDS ON LAB
-- Rob Hodde  11/11/2015

-- NOTE: for fun I decided to use all the current business units, not just the highlighted ones
-- Also, I took the liberty of adding a SortKey column (derived from LevelNo, ParentID)
--  which indicates the multi-tier relationship between entities


-- DROP DATABASE Company;
CREATE DATABASE Company;

CREATE TABLE `Company`.`tbl_Company` (
  `CompanyID` INT NOT NULL,
  `Name` VARCHAR(100) NOT NULL,
  `LevelNo` INT NOT NULL,
  `ParentID` INT NULL,
  `SortKey` VARCHAR(100) NOT NULL
 );


INSERT INTO Company.tbl_Company (CompanyID, Name, LevelNo, ParentID, SortKey)
VALUES
(0, 'GE', 0, -1, '00.00.00'),
(1, 'GE Capital', 1, 0, '01.00.00'),
(2, 'GE Capital Aviation Services', 2, 1, '01.02.00'),
(3, 'GE Energy Financial Services', 2, 1, '01.03.00'),
(4, 'GE Real Estate', 2, 1, '01.04.00'),
(5, 'GE Americas', 2, 1, '01.05.00'),
(6, 'GE Asia', 2, 1, '01.06.00'),
(7, 'GE Europe, Middle East & Africa', 2, 1, '01.07.00'),
(8, 'GE Energy Management', 1, 0, '08.00.00'),
(9, 'Industrial Solutions', 2, 8, '08.09.00'),
(10, 'GE Power Electronics', 3, 9, '08.09.10'),
(11, 'GE Power Components', 3, 9, '08.09.11'),
(12, 'GE Critical Power', 3, 9, '08.09.12'),
(13, 'GE Intelligent Platforms', 3, 9, '08.09.13'),
(14, 'Power Conversion', 2, 8, '08.14.00'),
(15, 'Digital Energy', 2, 8, '08.15.00'),
(16, 'GE Oil & Gas', 1, 0, '16.00.00'),
(17, 'GE Power & Water', 1, 0, '17.00.00'),
(18, 'GE Home & Business Solutions', 1, 0, '18.00.00'),
(19, 'GE Appliances', 2, 18, '18.19.00'),
(20, 'Consumer Electronics', 2, 18, '18.20.00'),
(21, 'GE Lighting', 2, 18, '18.21.00'),
(22, 'GE Intelligent Platforms', 2, 18, '18.22.00'),
(23, 'Electric Insurance Company', 1, 0, '23.00.00'),
(24, 'GE Technology Infrastructure', 1, 0, '24.00.00'),
(25, 'GE Aviation', 2, 24, '24.25.00'),
(26, 'GE Transportation', 2, 24, '24.26.00'),
(27, 'GE Healthcare', 1, 0, '27.00.00'),
(28, 'Amersham plc', 2, 27, '27.28.00'),
(29, 'API Healthcare', 2, 27, '27.29.00'),
(30, 'Datex Ohmeda', 2, 27, '27.30.00'),
(31, 'Whatman', 2, 27, '27.31.00');


SELECT c1.Name CoDivision, IFNULL(c2.Name,'') ValueCenter, IFNULL(c3.Name,'') Operation  -- THREE TIER ORG STRUCTURE
FROM company.tbl_Company c0
LEFT JOIN company.tbl_Company c1 ON  c1.ParentID = c0.CompanyID
LEFT JOIN company.tbl_Company c2 ON  c2.ParentID = c1.CompanyID 
LEFT JOIN company.tbl_Company c3 ON  c3.ParentID = c2.CompanyID 
WHERE c0.SortKey = '00.00.00'  -- suppress duplicates
ORDER BY c1.Sortkey, c2.SortKey, c3.SortKey  -- show organization structure

-- If the output were sent to a Report, the report developer would set SUPPRESS DUPLICATES to TRUE

