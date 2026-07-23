-- Project : Fraud Detection in Banking Transactions
CREATE DATABASE BankFraud;
USE BankFraud;

-- ==========================
-- Branches
-- ==========================

CREATE TABLE Branches(
BranchID INT AUTO_INCREMENT PRIMARY KEY,
BranchName VARCHAR(100) NOT NULL,
IFSCCode VARCHAR(20) UNIQUE,
Address VARCHAR(200),
City VARCHAR(50),
State VARCHAR(50),
Pincode VARCHAR(10)
);

-- ==========================
-- Customers
-- ==========================

CREATE TABLE Customers(

CustomerID INT AUTO_INCREMENT PRIMARY KEY,

FirstName VARCHAR(50),

LastName VARCHAR(50),

Gender ENUM('Male','Female','Other'),

DOB DATE,

Phone VARCHAR(15) UNIQUE,

Email VARCHAR(100) UNIQUE,

Aadhaar VARCHAR(20) UNIQUE,

PAN VARCHAR(20) UNIQUE,

Address VARCHAR(200),

City VARCHAR(50),

State VARCHAR(50),

Pincode VARCHAR(10),

CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- ==========================
-- Accounts
-- ==========================

CREATE TABLE Accounts(

AccountID INT AUTO_INCREMENT PRIMARY KEY,

CustomerID INT,

BranchID INT,

AccountNumber VARCHAR(20) UNIQUE,

AccountType ENUM('Savings','Current'),

Balance DECIMAL(15,2),

Status ENUM('Active','Blocked','Closed') DEFAULT 'Active',

OpenDate DATE,

FOREIGN KEY(CustomerID)

REFERENCES Customers(CustomerID),

FOREIGN KEY(BranchID)

REFERENCES Branches(BranchID)

);

-- ==========================
-- Employees
-- ==========================

CREATE TABLE Employees(

EmployeeID INT AUTO_INCREMENT PRIMARY KEY,

BranchID INT,

EmployeeName VARCHAR(100),

Designation VARCHAR(100),

Phone VARCHAR(15),

Email VARCHAR(100),

HireDate DATE,

Salary DECIMAL(10,2),

FOREIGN KEY(BranchID)

REFERENCES Branches(BranchID)

);

-- ==========================
-- Cards
-- ==========================

CREATE TABLE Cards(

CardID INT AUTO_INCREMENT PRIMARY KEY,

AccountID INT,

CardNumber VARCHAR(20) UNIQUE,

CardType ENUM('Debit','Credit'),

ExpiryDate DATE,

CVV CHAR(3),

Status ENUM('Active','Blocked') DEFAULT 'Active',

FOREIGN KEY(AccountID)

REFERENCES Accounts(AccountID)

);

-- ==========================
-- Devices
-- ==========================

CREATE TABLE Devices(

DeviceID INT AUTO_INCREMENT PRIMARY KEY,

CustomerID INT,

DeviceType VARCHAR(50),

DeviceName VARCHAR(100),

OperatingSystem VARCHAR(50),

IPAddress VARCHAR(45),

MACAddress VARCHAR(50),

IsTrusted BOOLEAN DEFAULT TRUE,

FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID)

);

-- ==========================
-- Transaction Types
-- ==========================

CREATE TABLE TransactionTypes(

TypeID INT AUTO_INCREMENT PRIMARY KEY,

TypeName VARCHAR(50) UNIQUE

);

-- ==========================
-- Locations
-- ==========================

CREATE TABLE Locations(

LocationID INT AUTO_INCREMENT PRIMARY KEY,

City VARCHAR(50),

State VARCHAR(50),

Country VARCHAR(50)

);

-- ==========================
-- ATM
-- ==========================

CREATE TABLE ATMs(

ATMID INT AUTO_INCREMENT PRIMARY KEY,

BranchID INT,

ATMCode VARCHAR(20) UNIQUE,

LocationID INT,

Status ENUM('Active','Inactive') DEFAULT 'Active',

FOREIGN KEY(BranchID)
REFERENCES Branches(BranchID),

FOREIGN KEY(LocationID)
REFERENCES Locations(LocationID)

);

-- ==========================
-- Transactions (Main Table)
-- ==========================

CREATE TABLE Transactions(

TransactionID BIGINT AUTO_INCREMENT PRIMARY KEY,

AccountID INT NOT NULL,

CustomerID INT NOT NULL,

TypeID INT NOT NULL,

Amount DECIMAL(15,2) NOT NULL,

TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,

DeviceID INT,

ATMID INT,

LocationID INT,

TransactionMode ENUM('UPI','NEFT','RTGS','IMPS','ATM','POS','NETBANKING'),

Status ENUM('Success','Failed','Pending') DEFAULT 'Success',

IsFraud BOOLEAN DEFAULT FALSE,

FraudReason VARCHAR(255),

FOREIGN KEY(AccountID)
REFERENCES Accounts(AccountID),

FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID),

FOREIGN KEY(TypeID)
REFERENCES TransactionTypes(TypeID),

FOREIGN KEY(DeviceID)
REFERENCES Devices(DeviceID),

FOREIGN KEY(ATMID)
REFERENCES ATMs(ATMID),

FOREIGN KEY(LocationID)
REFERENCES Locations(LocationID)

);

show tables;

-- ==========================
-- Login History
-- ==========================

CREATE TABLE LoginHistory(

LoginID BIGINT AUTO_INCREMENT PRIMARY KEY,

CustomerID INT,

DeviceID INT,

LoginTime DATETIME DEFAULT CURRENT_TIMESTAMP,

IPAddress VARCHAR(45),

LoginStatus ENUM('Success','Failed'),

FailureReason VARCHAR(255),

FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID),

FOREIGN KEY(DeviceID)
REFERENCES Devices(DeviceID)

);


-- ==========================
-- Beneficiaries
-- ==========================

CREATE TABLE Beneficiaries(

BeneficiaryID INT AUTO_INCREMENT PRIMARY KEY,

CustomerID INT,

BeneficiaryName VARCHAR(100),

AccountNumber VARCHAR(20),

BankName VARCHAR(100),

IFSCCode VARCHAR(20),

IsBlocked BOOLEAN DEFAULT FALSE,

CreatedDate DATE,

FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID)

);


-- ==========================
-- Fraud Rules
-- ==========================

CREATE TABLE FraudRules(

RuleID INT AUTO_INCREMENT PRIMARY KEY,

RuleName VARCHAR(100),

Description VARCHAR(255),

RiskLevel ENUM('Low','Medium','High','Critical'),

Status ENUM('Active','Inactive') DEFAULT 'Active'

);


-- ==========================
-- Fraud Alerts
-- ==========================

CREATE TABLE FraudAlerts(

AlertID BIGINT AUTO_INCREMENT PRIMARY KEY,

TransactionID BIGINT,

RuleID INT,

AlertDate DATETIME DEFAULT CURRENT_TIMESTAMP,

RiskScore INT,

AlertStatus ENUM('Pending','Investigated','Confirmed','False Alarm')
DEFAULT 'Pending',

Remarks VARCHAR(255),


FOREIGN KEY(TransactionID)
REFERENCES Transactions(TransactionID),


FOREIGN KEY(RuleID)
REFERENCES FraudRules(RuleID)

);


-- ==========================
-- Audit Logs
-- ==========================

CREATE TABLE AuditLogs(

LogID BIGINT AUTO_INCREMENT PRIMARY KEY,

EmployeeID INT,

ActionType VARCHAR(100),

TableName VARCHAR(100),

ActionDate DATETIME DEFAULT CURRENT_TIMESTAMP,

Description VARCHAR(255),


FOREIGN KEY(EmployeeID)
REFERENCES Employees(EmployeeID)

);
show tables;


INSERT INTO Branches
(BranchName, IFSCCode, Address, City, State, Pincode)
VALUES

('Chennai Main Branch','BANK0001','Anna Salai','Chennai','Tamil Nadu','600002'),
('Bangalore City Branch','BANK0002','MG Road','Bangalore','Karnataka','560001'),
('Mumbai Central Branch','BANK0003','Andheri East','Mumbai','Maharashtra','400069'),
('Delhi Corporate Branch','BANK0004','Connaught Place','Delhi','Delhi','110001'),
('Hyderabad Branch','BANK0005','Banjara Hills','Hyderabad','Telangana','500034'),
('Pune Branch','BANK0006','Shivaji Nagar','Pune','Maharashtra','411005'),
('Kochi Branch','BANK0007','Marine Drive','Kochi','Kerala','682031'),
('Coimbatore Branch','BANK0008','RS Puram','Coimbatore','Tamil Nadu','641002'),
('Madurai Branch','BANK0009','Anna Nagar','Madurai','Tamil Nadu','625020'),
('Salem Branch','BANK0010','Fairlands','Salem','Tamil Nadu','636016');


INSERT INTO TransactionTypes(TypeName)
VALUES

('Deposit'),
('Withdrawal'),
('UPI Transfer'),
('NEFT'),
('RTGS'),
('IMPS'),
('ATM Withdrawal'),
('POS Payment'),
('Online Shopping'),
('Bill Payment');

INSERT INTO Locations
(City,State,Country)
VALUES

('Chennai','Tamil Nadu','India'),
('Bangalore','Karnataka','India'),
('Mumbai','Maharashtra','India'),
('Delhi','Delhi','India'),
('Hyderabad','Telangana','India'),
('Pune','Maharashtra','India'),
('Kochi','Kerala','India'),
('Dubai','Dubai','UAE'),
('London','England','UK'),
('Singapore','Singapore','Singapore');

INSERT INTO FraudRules
(RuleName,Description,RiskLevel)
VALUES

('High Amount Transaction',
'Transaction amount greater than 100000',
'High'),

('Multiple Transactions',
'Many transactions within short time',
'Medium'),

('New Device Transaction',
'Transaction from unknown device',
'High'),

('Foreign Location',
'Transaction from foreign country',
'Critical'),

('Night Transaction',
'Transaction between midnight and 4 AM',
'Medium'),

('Blocked Card Usage',
'Transaction using blocked card',
'Critical'),

('Multiple Failed Login',
'Many failed login attempts',
'High'),

('Suspicious ATM Withdrawal',
'Large ATM withdrawal pattern',
'High');

SELECT * FROM Branches;
SELECT * FROM TransactionTypes;
SELECT * FROM Locations;
SELECT * FROM FraudRules;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM accounts;

INSERT INTO accounts
(account_id, customer_id, account_type, balance, opening_date, branch_id, status)

SELECT
CONCAT('ACC', LPAD(id,6,'0')) AS account_id,

id AS customer_id,

CASE
    WHEN id % 4 = 0 THEN 'Salary Account'
    WHEN id % 3 = 0 THEN 'Current'
    WHEN id % 2 = 0 THEN 'Savings'
    ELSE 'NRI Account'
END AS account_type,

CASE
    WHEN id % 5 = 0 THEN ROUND(RAND()*4500000 + 500000,2)
    ELSE ROUND(RAND()*195000 + 5000,2)
END AS balance,

DATE_ADD('2015-01-01', INTERVAL FLOOR(RAND()*3650) DAY) AS opening_date,

CONCAT('BR', LPAD((id % 10)+1,3,'0')) AS branch_id,

CASE
    WHEN id % 50 = 0 THEN 'BLOCKED'
    WHEN id % 30 = 0 THEN 'INACTIVE'
    ELSE 'ACTIVE'
END AS status

FROM customers;

INSERT INTO Employees
(BranchID, EmployeeName, Designation, Phone, Email, HireDate, Salary)
VALUES
(1,'Arun Kumar','Branch Manager','9876500001','arun.kumar1@bank.com','2019-04-15',85000.00),
(1,'Priya Sharma','Assistant Manager','9876500002','priya.sharma1@bank.com','2020-02-10',65000.00),
(1,'Karthik Raj','Cashier','9876500003','karthik.raj1@bank.com','2021-07-18',35000.00),
(1,'Divya Nair','Customer Support Executive','9876500004','divya.nair1@bank.com','2022-05-20',30000.00),
(1,'Rahul Verma','Relationship Officer','9876500005','rahul.verma1@bank.com','2023-01-12',42000.00),

(2,'Sneha Iyer','Branch Manager','9876500006','sneha.iyer2@bank.com','2018-11-01',86000.00),
(2,'Ajay Singh','Assistant Manager','9876500007','ajay.singh2@bank.com','2020-06-15',64000.00),
(2,'Meena Joseph','Cashier','9876500008','meena.joseph2@bank.com','2021-09-01',36000.00),
(2,'Vignesh Kumar','Customer Support Executive','9876500009','vignesh.kumar2@bank.com','2022-03-11',31000.00),
(2,'Anita Rao','Relationship Officer','9876500010','anita.rao2@bank.com','2023-02-18',43000.00),

(3,'Suresh Babu','Branch Manager','9876500011','suresh.babu3@bank.com','2019-08-25',87000.00),
(3,'Lakshmi Devi','Assistant Manager','9876500012','lakshmi.devi3@bank.com','2020-09-14',66000.00),
(3,'Mohan Raj','Cashier','9876500013','mohan.raj3@ba	nk.com','2021-10-05',34000.00),
(3,'Pooja Sharma','Customer Support Executive','9876500014','pooja.sharma3@bank.com','2022-07-09',30000.00),
(3,'Naveen Kumar','Relationship Officer','9876500015','naveen.kumar3@bank.com','2023-01-30',41000.00),

(4,'Rakesh Gupta','Branch Manager','9876500016','rakesh.gupta4@bank.com','2018-05-17',88000.00),
(4,'Keerthana S','Assistant Manager','9876500017','keerthana.s4@bank.com','2020-04-21',65000.00),
(4,'Manoj Das','Cashier','9876500018','manoj.das4@bank.com','2021-08-12',35500.00),
(4,'Aishwarya R','Customer Support Executive','9876500019','aishwarya.r4@bank.com','2022-11-23',30500.00),
(4,'Deepak Jain','Relationship Officer','9876500020','deepak.jain4@bank.com','2023-03-15',42500.00),

(5,'Harish Kumar','Branch Manager','9876500021','harish.kumar5@bank.com','2019-01-10',85500.00),
(5,'Nisha Patel','Assistant Manager','9876500022','nisha.patel5@bank.com','2020-08-18',64500.00),
(5,'Santhosh R','Cashier','9876500023','santhosh.r5@bank.com','2021-04-16',34500.00),
(5,'Riya Kapoor','Customer Support Executive','9876500024','riya.kapoor5@bank.com','2022-02-19',31000.00),
(5,'Prakash M','Relationship Officer','9876500025','prakash.m5@bank.com','2023-06-01',43000.00),

(6,'Anand Krishnan','Branch Manager','9876500026','anand.krishnan6@bank.com','2019-06-11',86500.00),
(6,'Swathi N','Assistant Manager','9876500027','swathi.n6@bank.com','2020-03-22',65500.00),
(6,'Gokul Raj','Cashier','9876500028','gokul.raj6@bank.com','2021-11-09',35000.00),
(6,'Neha S','Customer Support Executive','9876500029','neha.s6@bank.com','2022-09-30',31500.00),
(6,'Arvind P','Relationship Officer','9876500030','arvind.p6@bank.com','2023-05-05',43500.00),

(7,'Bala Murugan','Branch Manager','9876500031','bala.murugan7@bank.com','2018-12-12',87500.00),
(7,'Reshma Ali','Assistant Manager','9876500032','reshma.ali7@bank.com','2020-10-17',65000.00),
(7,'Vinod K','Cashier','9876500033','vinod.k7@bank.com','2021-03-27',35500.00),
(7,'Shalini P','Customer Support Executive','9876500034','shalini.p7@bank.com','2022-01-08',30500.00),
(7,'Imran Khan','Relationship Officer','9876500035','imran.khan7@bank.com','2023-04-14',42500.00),

(8,'Sathish Kumar','Branch Manager','9876500036','sathish.kumar8@bank.com','2019-07-07',86000.00),
(8,'Anjali Menon','Assistant Manager','9876500037','anjali.menon8@bank.com','2020-01-29',64500.00),
(8,'Rohit S','Cashier','9876500038','rohit.s8@bank.com','2021-06-18',34800.00),
(8,'Kavya R','Customer Support Executive','9876500039','kavya.r8@bank.com','2022-12-12',31200.00),
(8,'Sanjay P','Relationship Officer','9876500040','sanjay.p8@bank.com','2023-07-20',43200.00),

(9,'Venkatesh R','Branch Manager','9876500041','venkatesh.r9@bank.com','2019-09-09',87000.00),
(9,'Deepa L','Assistant Manager','9876500042','deepa.l9@bank.com','2020-05-13',65200.00),
(9,'Arun Prasad','Cashier','9876500043','arun.prasad9@bank.com','2021-07-15',35200.00),
(9,'Monika S','Customer Support Executive','9876500044','monika.s9@bank.com','2022-06-24',30800.00),
(9,'Kiran B','Relationship Officer','9876500045','kiran.b9@bank.com','2023-08-01',42800.00),

(10,'Dinesh Kumar','Branch Manager','9876500046','dinesh.kumar10@bank.com','2018-10-10',88500.00),
(10,'Preethi V','Assistant Manager','9876500047','preethi.v10@bank.com','2020-11-11',66000.00),
(10,'Ashok R','Cashier','9876500048','ashok.r10@bank.com','2021-02-14',35000.00),
(10,'Harini K','Customer Support Executive','9876500049','harini.k10@bank.com','2022-04-18',31500.00),
(10,'Surya Narayanan','Relationship Officer','9876500050','surya.n10@bank.com','2023-09-05',43800.00);

select * from devices


INSERT INTO ATMs
(BranchID, ATMCode, LocationID, Status)
VALUES

-- Branch 1
(1,'ATM0001',1,'Active'),
(1,'ATM0002',1,'Active'),
(1,'ATM0003',1,'Inactive'),

-- Branch 2
(2,'ATM0004',2,'Active'),
(2,'ATM0005',2,'Active'),
(2,'ATM0006',2,'Active'),

-- Branch 3
(3,'ATM0007',3,'Active'),
(3,'ATM0008',3,'Active'),
(3,'ATM0009',3,'Inactive'),

-- Branch 4
(4,'ATM0010',4,'Active'),
(4,'ATM0011',4,'Active'),
(4,'ATM0012',4,'Active'),

-- Branch 5
(5,'ATM0013',5,'Active'),
(5,'ATM0014',5,'Active'),
(5,'ATM0015',5,'Inactive'),

-- Branch 6
(6,'ATM0016',6,'Active'),
(6,'ATM0017',6,'Active'),
(6,'ATM0018',6,'Active'),

-- Branch 7
(7,'ATM0019',7,'Active'),
(7,'ATM0020',7,'Active'),
(7,'ATM0021',7,'Active'),

-- Branch 8
(8,'ATM0022',8,'Active'),
(8,'ATM0023',8,'Active'),
(8,'ATM0024',8,'Active'),

-- Branch 9
(9,'ATM0025',9,'Active'),
(9,'ATM0026',9,'Active'),
(9,'ATM0027',9,'Active'),

-- Branch 10
(10,'ATM0028',10,'Active'),
(10,'ATM0029',10,'Active'),
(10,'ATM0030',10,'Active');


select * from accounts;
select * from cards;
select * from beneficiaries;
use fraud_bank
show  databases


-- qureies

select * from customers ;

select * from accounts where status = "active" ;

select * from customers where city = "chennai" ;

select * from transactions where amount>50000;

select * from cards where status = "Blocked";

select * from transactions where status = 'success';

select * from loginhistory where loginstatus = 'failed';

select * from employees where salary > 50000;
select * from beneficiaries where isblocked = 1;
select * from transactions where isfraud = true;
select count(customerid) from customers;
select count(*) from accounts;
select count(*) from transactions;
select sum(balance) from accounts;	
select max(amount) as highest from transactions;
select min(amount) as low from transactions;
select sum(isfraud) from transactions; 
select state,count(state) from customers group by state;
select transactionmode,count(transactionmode) from transactions group by transactionmode;
select * from accounts;
select b.Branchname, count(accountid) as totsl
 from accounts as a
 join branches as b on a.branchid=b.branchid
 group by Branchname;
 select b.Branchname, sum(balance) as totalsum
 from accounts as a
 join branches as b on a.branchid=b.branchid
 group by Branchname;
 select firstname,count(transactionid) as totalbalance 
 from transactions as a 
 join customers as b on a.customerid=b.customerid
 group by firstname;
 select b.customerid,b.firstname ,count(a.transactionid) as total_transactions
 from transactions as a 
 join customers as b on a.customerid=b.customerid
 group by b.customerid, b.firstname;
 select b.typeid,b.typename, avg(a.amount) as avgamount
 from transactions as a 
 join transactiontypes as b on a.typeid=b.typeid
 group by b.typename, b.typeid;
select a.branchid,a.branchname,count(b.accountid) as counts
from branches AS a
join accounts as b on a.branchid=b.branchid
group by a.branchid,a.branchname having counts>50;
select b.customerid,b.firstname ,round(max(a.amount)) as highest_transactions
 from transactions as a 
 join customers as b on a.customerid=b.customerid
 group by b.customerid, b.firstname;
 select city,count(customerid) as total 
 from customers group by city having total >100;
 
 select a.branchid,a.branchname,count(c.isfraud) as total
 from branches as a
 join accounts as b on a.branchid=b.branchid
 join transactions as c on c.accountid=b.accountid
 where c.isfraud = 1 group by a.branchid,a.branchname;
 
 
 select a.branchid,a.branchname,count(c.isfraud) as total
 from branches as a
 join accounts as b on a.branchid=b.branchid
 join transactions as c on c.customerid=b.customerid
 where c.isfraud = 1 and a.branchid=8 ;
 
select status,count(transactionid) as total_transaction
from transactions group by status ;
 
 select accounttype,max(balance) as maxbalance from accounts group by accounttype;
 
 select b.branchid,b.branchname, sum(a.balance) as totalbalance 
 from accounts as a
 join branches as b on a.branchid=b.branchid
 group by b.branchid,b.branchname
 having sum(a.balance)>10000000;
 
 select b.customerid,b.firstname,a.accountid,a.accountnumber,a.accounttype,a.balance 
 from accounts as a 
 join customers as b on a.customerid=b.customerid;
 
 select c.firstname, a.* 
 from cards as a 
 join accounts as b on a.accountid=b.accountid
 join customers as c on c.customerid=b.customerid;
 
 select a.firstname , b.* 
 from customers as  a 
 join transactions as b on a.customerid=b.customerid;
 
 select a.branchid,a.branchname,b.* 
 from branches as a 
 join employees as b on a.branchid=b.branchid;
 
  
 select a.branchid,a.branchname,b.* 
 from branches as a 
 join accounts as b on a.branchid=b.branchid;
 
 
 select a.*, b.branchname
 from atms as a 
 left join branches as b on a.branchid=b.branchid;
 
 select b.typename ,b.* 
 from transactiontypes as a
 join transactions as b on a.typeid=b.typeid;
 
 select c.customerid,c.firstname, a.*
 from locations as a 
 join transactions as b on a.locationid=b.locationid
 join customers as c on c.customerid=b.customerid;
 
 select a.rulename ,b.* 
 from fraudrules as a 
 join fraudalerts as b on a.ruleid=b.ruleid ;
  
 select a.firstname , b.* 
 from customers as a
 join loginhistory as b on a.customerid=b.customerid;
 
 select * from transactions where amount > 100000;
 
 select a.country , b.* 
 from locations as a
 join transactions as b on a.locationid=b.locationid
where not (a.country='india');

select * from transactions where time(transactiondate) between '00:00:00' and '04:00:00';

select a.firstname, count(b.transactionid) as total
FROM customers as a 
JOIN transactions as b on a.customerid=b.customerid
GROUP BY a.customerid having count(b.transactionid) >10 ;

select a.* , c.status 
FROM customers as a 
join accounts as b on a.customerid=b.customerid
join cards as c on b.accountid=c.accountid 
WHERE c.status='blocked';

select a.* , b.istrusted  
FROM transactions as a 
join devices as b on a.deviceid=b.deviceid
WHERE b.istrusted=0 ;

select a.customerid,a.firstname, sum(b.amount) as totaltransactions
from customers as a 
join transactions as b on a.customerid=b.customerid
GROUP BY a.customerid order by totaltransactions desc limit 10;

select  a.branchid,a.branchname ,count(c.transactionid) as highestcount
FROM branches as a
join accounts as b on a.branchid=b.branchid
join transactions as c on c.accountid=b.accountid
WHERE c.isfraud=1
group by  a.branchid order by highestcount desc limit 1;


select a.firstname,c.branchname, d.transactionid,d.amount,d.fraudreason
FROM customers as a 
join accounts as b on a.customerid=b.customerid
join branches as c on b.branchid=c.branchid
join transactions as d on d.accountid=b.accountid 
where d.isfraud=1  ;

 select a.customerid, a.firstname , sum(isfraud)
 from customers as a 
 join transactions as b on a.customerid=b.customerid
 group by a.customerid,a.firstname 
 having sum(case when b.isfraud =1 then 1 else 0 end)>0
 and sum(case when b.isfraud= 0 then 1 else 0 end)>0;
 
 SELECT a.CustomerID,
       a.FirstName,
       b.TransactionID,
       b.Amount,
       MAX(b.Amount) OVER (
           PARTITION BY b.CustomerID
       ) AS HighestTransactionAmount
FROM Customers AS a
JOIN Transactions AS b
ON a.CustomerID = b.CustomerID;

SELECT 
    a.CustomerID,
    a.FirstName,
    a.LastName,
    SUM(b.Amount) AS TotalTransactionAmount
FROM Customers AS a
JOIN Transactions AS b
    ON a.CustomerID = b.CustomerID
GROUP BY 
    a.CustomerID,
    a.FirstName,
    a.LastName
HAVING SUM(b.Amount) > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT 
            CustomerID,
            SUM(Amount) AS CustomerTotal
        FROM Transactions
        GROUP BY CustomerID
    ) AS CustomerTotals
)
ORDER BY TotalTransactionAmount DESC;


SELECT
    CustomerID,
    FirstName,
    FraudTransactionCount,
    DENSE_RANK() OVER (
        ORDER BY FraudTransactionCount DESC
    ) AS RiskRank
FROM
(
    SELECT
        a.CustomerID,
        a.FirstName,
        SUM(CASE
                WHEN b.IsFraud = 1 THEN 1
                ELSE 0
            END) AS FraudTransactionCount
    FROM Customers AS a
    JOIN Transactions AS b
        ON a.CustomerID = b.CustomerID
    GROUP BY
        a.CustomerID,
        a.FirstName
) AS CustomerRisk
ORDER BY RiskRank;


SELECT 
    a.CustomerID,
    CONCAT(a.FirstName, ' ', a.LastName) AS CustomerName,
    c.BranchName,
    d.TransactionID,
    d.TransactionDate,
    d.Amount,
    e.TypeName AS TransactionType,
    d.FraudReason,
    d.DeviceID,
    f.IsTrusted
FROM Customers AS a
JOIN Accounts AS b
    ON a.CustomerID = b.CustomerID
JOIN Branches AS c
    ON b.BranchID = c.BranchID
JOIN Transactions AS d
    ON d.AccountID = b.AccountID
JOIN TransactionTypes AS e
    ON d.TypeID = e.TypeID
JOIN Devices AS f
    ON d.DeviceID = f.DeviceID
WHERE d.IsFraud = 1
ORDER BY d.TransactionDate DESC;