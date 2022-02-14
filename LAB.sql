DROP DATABASE `order-DIRECTORY`;
CREATE DATABASE `order-DIRECTORY`;
USE `order-DIRECTORY`;


-- 1.Table Creation Queries
CREATE TABLE IF NOT EXISTS `SUPPLIER`(
`SUPP_ID` INT PRIMARY KEY,
`SUPP_NAME` VARCHAR(50) ,
`SUPP_CITY` VARCHAR(50),
`SUPP_PHONE` VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS `CUSTOMER` (
  `CUS_ID` INT NOT NULL,
  `CUS_NAME` VARCHAR(20) NULL DEFAULT NULL,
  `CUS_PHONE` VARCHAR(10),
  `CUS_CITY` VARCHAR(30) ,
  `CUS_GENDER` CHAR,
  PRIMARY KEY (`CUS_ID`));

CREATE TABLE IF NOT EXISTS `CATEGORY` (
  `CAT_ID` INT NOT NULL,
  `CAT_NAME` VARCHAR(20) NULL DEFAULT NULL,
 
  PRIMARY KEY (`CAT_ID`)
  );

  CREATE TABLE IF NOT EXISTS `PRODUCT` (
  `PRO_ID` INT NOT NULL,
  `PRO_NAME` VARCHAR(20) NULL DEFAULT NULL,
  `PRO_DESC` VARCHAR(60) NULL DEFAULT NULL,
  `CAT_ID` INT NOT NULL,
  PRIMARY KEY (`PRO_ID`),
  FOREIGN KEY (`CAT_ID`) REFERENCES `CATEGORY` (`CAT_ID`)
  );

 CREATE TABLE IF NOT EXISTS `PRODUCT_DETAILS` (
  `PROD_ID` INT NOT NULL,
  `PRO_ID` INT NOT NULL,
  `SUPP_ID` INT NOT NULL,
  `PROD_PRICE` INT NOT NULL,
  PRIMARY KEY (`PROD_ID`),
  FOREIGN KEY (`PRO_ID`) REFERENCES `PRODUCT` (`PRO_ID`),
  FOREIGN KEY (`SUPP_ID`) REFERENCES `SUPPLIER` (`SUPP_ID`)
  );

CREATE TABLE IF NOT EXISTS `ORDER` (
  `ORD_ID` INT NOT NULL,
  `ORD_AMOUNT` INT NOT NULL,
  `ORD_DATE` DATE,
  `CUS_ID` INT NOT NULL,
  `PROD_ID` INT NOT NULL,
  PRIMARY KEY (`ORD_ID`),
  FOREIGN KEY (`CUS_ID`) REFERENCES `CUSTOMER` (`CUS_ID`),
  FOREIGN KEY (`PROD_ID`) REFERENCES `PRODUCT_DETAILS` (`PROD_ID`)
  );

CREATE TABLE IF NOT EXISTS `RATING` (
  `RAT_ID` INT NOT NULL,
  `CUS_ID` INT NOT NULL,
  `SUPP_ID` INT NOT NULL,
  `RAT_RATSTARS` INT NOT NULL,
  PRIMARY KEY (`RAT_ID`),
  FOREIGN KEY (`SUPP_ID`) REFERENCES `SUPPLIER` (`SUPP_ID`),
  FOREIGN KEY (`CUS_ID`) REFERENCES `CUSTOMER` (`CUS_ID`)
  );

-- 2. Insert the following data in the table created above
INSERT INTO `SUPPLIER`(SUPP_ID,SUPP_NAME,SUPP_CITY,SUPP_PHONE) 
values 
    (1,'Rajesh Retails','Delhi','1234567890'),
    (2,'Appario Ltd.','Mumbai','2589631470'),
    (3,'Knome products','Banglore','9785462315'),
    (4,'Bansal Retails','Kochi','8975463285'),
    (5,'Mittal Ltd.','Lucknow','7898456532');

INSERT INTO `CUSTOMER`(CUS_ID,CUS_NAME,CUS_PHONE,CUS_CITY,CUS_GENDER) 
values 
    (1,'AAKASH','9999999999','DELHI','M'),
    (2,'AMAN','9785463215','NOIDA','M'),
    (3,'NEHA','9999999999','MUMBAI','F'),
    (4,'MEGHA','9994562399','KOLKATA','F'),
    (5,'PULKIT','7895999999','LUCKNOW','M');

INSERT INTO `CATEGORY`(CAT_ID,CAT_NAME) 
values 
    (1,'BOOKS'),
    (2,'GAMES'),
    (3,'GROCERIES'),
    (4,'ELECTRONICS'),
    (5,'CLOTHES');

INSERT INTO `PRODUCT`(PRO_ID,PRO_NAME,PRO_DESC,CAT_ID) 
values 
    (1,'GTA V','DFJDJFDJFDJFDJFJF',2),
    (2,'TSHIRT','DFDFJDFJDKFD',5),
    (3,'ROG LAPTOP','DFNTTNTNTERND',4),
    (4,'OATS','REURENTBTOTH',3),
    (5,'HARRY POTTER','NBEMCTHTJTH',1);

INSERT INTO `PRODUCT_DETAILS` (PROD_ID,PRO_ID,SUPP_ID,PROD_PRICE) 
VALUES 
    (1,1,2,1500),
    (2,3,5,30000),
    (3,5,1,3000),
    (4,2,3,2500),
    (5,4,1,1000);

INSERT INTO `ORDER` (ORD_ID,ORD_AMOUNT,ORD_DATE,CUS_ID,PROD_ID) 
VALUES 
    (20,1500,'2021-10-12',3,5),
    (25,30500,'2021-09-16',5,2),
    (26,2000,'2021-10-05',1,1),
    (30,3500,'2021-08-16',4,3),
    (50,2000,'2021-10-06',2,1);

INSERT INTO RATING (RAT_ID,CUS_ID,SUPP_ID,RAT_RATSTARS) 
VALUES 
    (1,2,2,4),
    (2,3,4,3),
    (3,5,1,5),
    (4,1,3,2),
    (5,4,5,4);

-- Queries
-- 3.	Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
SELECT 
`CUSTOMER`.CUS_NAME as customer_name,`CUSTOMER`.CUS_GENDER as customer_gender,`order`.ORD_AMOUNT as order_amount 
from 
`CUSTOMER` INNER JOIN `order` 
on `CUSTOMER`.CUS_ID = `order`.CUS_ID 
WHERE `order`.ORD_AMOUNT>=3000
GROUP BY `CUSTOMER`.CUS_GENDER;

-- 4.	Display all the orders along with the product name ordered by a customer having Customer_Id=2.
SELECT 
`order`.*,`PRODUCT`.PRO_NAME
from `CUSTOMER` 
INNER JOIN `order` 
on `CUSTOMER`.CUS_ID = `order`.CUS_ID 
inner JOIN `PRODUCT`
on `order`.PROD_ID = `PRODUCT`.PRO_ID
WHERE `CUSTOMER`.CUS_ID = 2;

-- 5.	Display the Supplier details who can supply more than one product.
SELECT distinct `SUPPLIER`.SUPP_ID,`SUPPLIER`.SUPP_NAME,`SUPPLIER`.SUPP_CITY,`SUPPLIER`.SUPP_PHONE from `SUPPLIER`,`PRODUCT_DETAILS`
WHERE `SUPPLIER`.SUPP_ID = `PRODUCT_DETAILS`.SUPP_ID
GROUP BY `PRODUCT_DETAILS`.SUPP_ID
having count(`PRODUCT_DETAILS`.SUPP_ID)>1;

-- 6.	Find the category of the product whose order amount is minimum.
select `CATEGORY`.CAT_NAME
from `CATEGORY`
where `CATEGORY`.CAT_ID = (
    select `CATEGORY`.CAT_ID from `CATEGORY`
    inner join `PRODUCT` 
    ON `CATEGORY`.CAT_ID = `PRODUCT`.CAT_ID
    inner join `PRODUCT_DETAILS`
    on `PRODUCT`.PRO_ID = `PRODUCT_DETAILS`.PRO_ID
    inner join `order` 
    on `PRODUCT_DETAILS`.PROD_ID = `order`.PROD_ID
    having min(`order`.ORD_AMOUNT));

-- 7.	Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT `PRODUCT`.PRO_ID,`PRODUCT`.PRO_NAME 
from `PRODUCT` 
INNER join `PRODUCT_DETAILS`
on `PRODUCT`.PRO_ID = `PRODUCT_DETAILS`.PRO_ID
INNER JOIN `order`
on `PRODUCT_DETAILS`.PROD_ID = `order`.PROD_ID
where `order`.ORD_DATE>'2021-10-05';

-- 8.	Display customer name and gender whose names start or end with character 'A'.
SELECT `customer`.CUS_NAME from `CUSTOMER` 
WHERE `customer`.CUS_NAME like 'A%' or `customer`.CUS_NAME like '%A';

-- 9.	Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.
DELIMITER //;
CREATE PROCEDURE supplierVerdict()
BEGIN
SELECT RAT_ID,RAT_RATSTARS,
CASE
when rating.RAT_RATSTARS > 4 then  'Genuine Supplier'
when rating.RAT_RATSTARS > 2 then  'Average Supplier'
else  'Supplier should not be considered'
END as supp_verdict 
FROM `RATING` WHERE RATING.SUPP_ID = supp_id;
END //;