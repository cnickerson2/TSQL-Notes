IF (DB_NAME() <> 'car_transactions')
BEGIN
	DROP DATABASE IF EXISTS car_transactions;

	CREATE DATABASE car_transactions;

	USE car_transactions;
END
GO

DROP TABLE IF EXISTS Transactions_facts_table;
DROP TABLE IF EXISTS Cars;
DROP TABLE IF EXISTS Company;
DROP TABLE IF EXISTS Salesmen;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Cities;
DROP TABLE IF EXISTS Countries;
DROP TABLE IF EXISTS Categories;
GO

CREATE TABLE Categories
(
	CatId		INT			IDENTITY(1,1)		PRIMARY KEY,
	Category	VARCHAR(50)
);

CREATE TABLE Countries
(
	CountryId		INT			IDENTITY(1,1)		PRIMARY KEY,
	Country			VARCHAR(55)
);

CREATE TABLE Cities
(
	CityId			INT			IDENTITY(1,1)		PRIMARY KEY,
	CountryId		INT			FOREIGN KEY REFERENCES Countries(CountryId),
	City			VARCHAR(33)
);

CREATE TABLE Customers
(
	CustId			INT			IDENTITY(1,1)		PRIMARY KEY,
	CityId			INT			FOREIGN KEY REFERENCES Cities(CityId),
	Surname			VARCHAR(15),
	Name			VARCHAR(15)
);

CREATE TABLE Salesmen
(
	SalesmanID		INT			IDENTITY(1,1)		PRIMARY KEY,
	Surname			VARCHAR(15),
	Name			VARCHAR(15),
	EmpDate			DATETIME,
	BossId			INT
);

CREATE TABLE Company
(
	CompanyID		INT			IDENTITY(1,1)		PRIMARY KEY,
	CityId			INT			FOREIGN KEY REFERENCES Cities(CityId),
	Company			VARCHAR(33)
);

CREATE TABLE Cars
(
	CarId			INT			IDENTITY(1,1)		PRIMARY KEY,
	CategoryId		INT			FOREIGN KEY REFERENCES Categories(CatId),
	CompanyId		INT			FOREIGN KEY REFERENCES Company(CompanyId),
	Car				VARCHAR(50),
	Model			VARCHAR(50)
);

CREATE TABLE Transactions_facts_table
(
	CarId			INT			FOREIGN KEY REFERENCES Cars(CarId),
	CustomerId		INT			FOREIGN KEY REFERENCES Customers(CustId),
	SalesmanId		INT			FOREIGN KEY REFERENCES Salesmen(SalesmanId),
	SalesDate		DATETIME,
	Price			MONEY,
	Amount			INT,
	Value			MONEY
);
GO

INSERT INTO Categories (Category) VALUES ('Hatchback') ;
INSERT INTO Categories (Category) VALUES ('Sedan');
INSERT INTO Categories (Category) VALUES (' Coupe');
INSERT INTO Categories (Category) VALUES ('Convertible');
INSERT INTO Categories (Category) VALUES ('Wagon');
INSERT INTO Categories (Category) VALUES ('SUV');

INSERT INTO Countries (Country) VALUES ('Germany');
INSERT INTO Countries (Country) VALUES ('USA');
INSERT INTO Countries (Country) VALUES ('Japan');
INSERT INTO Countries (Country) VALUES ('UK');
INSERT INTO Countries (Country) VALUES ('South Korea');
INSERT INTO Countries (Country) VALUES ('Italy');

INSERT INTO Cities (CountryId, City) VALUES (1, 'Stuttgart');
INSERT INTO Cities (CountryId, City) VALUES (1, 'Munich');
INSERT INTO Cities (CountryId, City) VALUES (2, 'Dearborn');
INSERT INTO Cities (CountryId, City) VALUES (2, 'Warren');
INSERT INTO Cities (CountryId, City) VALUES (3, 'Toyota');
INSERT INTO Cities (CountryId, City) VALUES (3, 'Fuchu');
INSERT INTO Cities (CountryId, City) VALUES (4, 'Gaydon');
INSERT INTO Cities (CountryId, City) VALUES (4, 'Crevel');
INSERT INTO Cities (CountryId, City) VALUES (4, 'Whitley');
INSERT INTO Cities (CountryId, City) VALUES (5, 'Seoul');
INSERT INTO Cities (CountryId, City) VALUES (6, 'Maranello');
INSERT INTO Cities (CountryId, City) VALUES (6, 'Modena');

INSERT INTO Company (CityId, Company) VALUES (1, 'Mercedes-Benz');
INSERT INTO Company (CityId, Company) VALUES (2, 'Bayerische Motoren Were AG');
INSERT INTO Company (CityId, Company) VALUES (3, 'Lincoln');
INSERT INTO Company (CityId, Company) VALUES (4, 'Cadillac');
INSERT INTO Company (CityId, Company) VALUES (5, 'Toyota Motor Corporation');
INSERT INTO Company (CityId, Company) VALUES (6, 'Mazda Motor Corporation');
INSERT INTO Company (CityId, Company) VALUES (7, 'Aston Martin Lagonda Limited');
INSERT INTO Company (CityId, Company) VALUES (8, 'Bentley Motors Limited');
INSERT INTO Company (CityId, Company) VALUES (9, 'Jaguar Cars Ltd');
INSERT INTO Company (CityId, Company) VALUES (10, 'Kia Motors');
INSERT INTO Company (CityId, Company) VALUES (10, 'Hyundai Motor Company');
INSERT INTO Company (CityId, Company) VALUES (11, 'Ferrari S.p.A.');
INSERT INTO Company (CityId, Company) VALUES (12, 'Maserati');

INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (1, 1, 'Mercedes-Benz', 'A-Class');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (1, 1,'Mercedes-Benz','B-Class');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 1,'Mercedes-Benz','C-Class');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 1, 'Mercedes-Benz','TE-Class');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 1, 'Mercedes-Benz','CL-Class');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 1,'Mercedeg-Benz','SLS');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (4, 1,'Mercedes-Benz','SL');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (5, 1,'Mercedes-Benz','C-Class Wagon');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (6, 1,'Mercedes-Benz','GLK');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (1, 2, 'BMU','Seriest')
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 2, ' BMU','3 series');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 2, ' BHUI','5 series');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 2, 'BMU','3 Series Coupe');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 2, 'BMU', 'M3 Coupe');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (4, 2, 'BMU','3 Serie Convertible');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (4, 2, 'BMU','M3 Convertible');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (5, 2, 'BMU','3 Series Touring');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (6, 3, 'Lincoln','Navigator');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 4, 'Cadillac','CTS');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 4, 'Cadillac','STS');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 4, 'Cadillac', 'IDTS');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (5, 4,'Cadillacl','CTS-V Wagon');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (5, 4,'Cadillac','CTS Sport Wagon');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (6, 4,'Cadillac','Escalade');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (6, 4, 'Cadillac','Escalade Hybrid');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (1, 5,'Toyota','Yaris');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (1, 5, 'Toyota','Matrix');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 5, 'Toyota','Camry');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 5, 'Toyota','Avalon');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (6, 5, 'Toyota','RAV4');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (6, 5, 'Toyota','4Runner');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (6, 5, 'Toyota','Land Cruiser');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (1, 6,'Mazda','Mazda2 ');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (1, 6,'Mazda','Mazda3')
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 6,'Mazda','Mazda6');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (4, 6,'Mazda','NX-5') ;
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (6, 6,'Mazda','Mazdas');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (6, 6,'Mazda', 'CX7');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 7,'Aston Martin','DBS Coupe');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (4, 7,'Aston Martin','DBS Volante');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 7,'Aston Martin','Virage Coupe');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (4, 7,'Aston Martin','Virage Volante');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 7,'Aston Martin','IV8 Coupe');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (4, 7,'Aston Martin','V8 Roadster');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (1, 7, 'Aston Martin','Cygnet');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 7, 'Aston Martin','Rapide');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 8,' Bentley', 'Mulsanne');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 8,' Bentley','Continental Flying Spur');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 8, 'Bentley','Continental GT');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (4, 8, 'Bentley','Continental GTC');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 9,'Jaguar','XK' );
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 9, 'Jaguar','XJ') ;
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2, 9,'Jaguar','XF');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 9,'Jaguar','R');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (1, 10, 'Kia','Picanto');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (6, 10,'Kia' ,'Soul');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (2,11,'Hyundai','Azera');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 11,'Hyundai','Genesig Coupe');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (3, 12,'Ferrari','1599 GTO');
INSERT INTO Cars (CategoryId, CompanyId, Car, Model) VALUES (4, 12,'Ferrari','California');

INSERT INTO Salesmen (Surname, Name, EmpDate, BossId) VALUES ('Smith','John', '2002-05-04', NULL);
INSERT INTO Salesmen (Surname, Name, EmpDate, BossId) VALUES ('Johnson','Mark', '2002-06-01', -1);
INSERT INTO Salesmen (Surname, Name, EmpDate, BossId) VALUES ('Kolarov','Steve', '2002-06-10', 1);
INSERT INTO Salesmen (Surname, Name, EmpDate, BossId) VALUES ('Cronenberg','Michael', '2003-10-01', 1);

INSERT INTO Customers (CityId, Name, Surname) VALUES (12, 'Daniel','Sanchez');
INSERT INTO Customers (CityId, Name, Surname) VALUES (2, 'Alexander', 'Ramrez');
INSERT INTO Customers (CityId, Name, Surname) VALUES (1, 'Jayden','Flores');
INSERT INTO Customers (CityId, Name, Surname) VALUES (2,'Aiden','Garca');
INSERT INTO Customers (CityId, Name, Surname) VALUES (3,'Jackson','Mason');
INSERT INTO Customers (CityId, Name, Surname) VALUES (4, 'Liam' ,'Clark');
INSERT INTO Customers (CityId, Name, Surname) VALUES (5, 'Jacob','Jones');
INSERT INTO Customers (CityId, Name, Surname) VALUES (6, 'Jayden' ,'White');
INSERT INTO Customers (CityId, Name, Surname) VALUES (7, 'Ethan','Lee');
INSERT INTO Customers (CityId, Name, Surname) VALUES (8,'Daniel','Campbell');
INSERT INTO Customers (CityId, Name, Surname) VALUES (9,'Jayden','Anderson');
INSERT INTO Customers (CityId, Name, Surname) VALUES (10, 'Ethan', 'Chan');
INSERT INTO Customers (CityId, Name, Surname) VALUES (11, 'Alexander' , 'Jones')
INSERT INTO Customers (CityId, Name, Surname) VALUES (12, 'Daniel' ,'Hernandez')
INSERT INTO Customers (CityId, Name, Surname) VALUES (3, 'Jayden','Garca');
INSERT INTO Customers (CityId, Name, Surname) VALUES (1, 'Daniel','Martinez');
INSERT INTO Customers (CityId, Name, Surname) VALUES (2,'Ethan','Gonzalez');
INSERT INTO Customers (CityId, Name, Surname) VALUES (3,'Alexander', 'Lopez');
INSERT INTO Customers (CityId, Name, Surname) VALUES (4,'Jayden','Rodriguez') ;
INSERT INTO Customers (CityId, Name, Surname) VALUES (5,'Alexander','Taylor');
INSERT INTO Customers (CityId, Name, Surname) VALUES (6,'Ethan','Cote');
INSERT INTO Customers (CityId, Name, Surname) VALUES (7,'Daniel','Williams');
INSERT INTO Customers (CityId, Name, Surname) VALUES (8,'Jayden','White');
INSERT INTO Customers (CityId, Name, Surname) VALUES (9,'Daniel','Johnson');
INSERT INTO Customers (CityId, Name, Surname) VALUES (10, 'Alexander','Clark')
INSERT INTO Customers (CityId, Name, Surname) VALUES (11, 'Daniel','Wilson')
INSERT INTO Customers (CityId, Name, Surname) VALUES (12,'Ethan','Gagnon');
INSERT INTO Customers (CityId, Name, Surname) VALUES (4, 'Alexander','Lee');
INSERT INTO Customers (CityId, Name, Surname) VALUES (1,' Echan','Tremblay')
INSERT INTO Customers (CityId, Name, Surname) VALUES (2,'Alen','Roy');
INSERT INTO Customers (CityId, Name, Surname) VALUES (3,'Hayk','Brown');
INSERT INTO Customers (CityId, Name, Surname) VALUES (4,'Arman','Martin');
INSERT INTO Customers (Cityid, Name, Surname) VALUES (1, 'Joshua', 'Brown');
INSERT INTO Customers (CityId, Name, Surname) VALUES (2, 'Jan', 'Davis');
INSERT INTO Customers (CityId, Name, Surname) VALUES (3, 'villam', 'Novicki');
INSERT INTO Customers (CityId, Name, Surname) VALUES (4, 'Era', 'Miller');
INSERT INTO Customers (CityId, Name, Surname) VALUES (5,'Laurence', 'Moore');
INSERT INTO Customers (CityId, Name, Surname) VALUES (6, 'Ethan', 'Johnson');
INSERT INTO Customers (CityId, Name, Surname) VALUES (7, 'Isabella', 'Biliams');
INSERT INTO Customers (CityId, Name, Surname) VALUES (8, 'Jurgen' , 'Taylor');
INSERT INTO Customers (CityId, Name, Surname) VALUES (9, 'Robert','Jackson');
INSERT INTO Customers (CityId, Name, Surname) VALUES (10,'Isabella', 'Jacov');
INSERT INTO Customers (CityId, Name, Surname) VALUES (11,'Daniel', 'Perez');
INSERT INTO Customers (CityId, Name, Surname) VALUES (12,'Daniel','Sanchez');
INSERT INTO Customers (CityId, Name, Surname) VALUES (2, 'Alexander', 'Ramrez');
INSERT INTO Customers (CityId, Name, Surname) VALUES (1,'Jayden', 'Flores');
INSERT INTO Customers (CityId, Name, Surname) VALUES (2,'Aiden', 'Garca')

INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (1, 1, 1, '2010-05-29', 30000, 1, 30000);
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (2, 2, 2, '2010-05-29', 35000, 1, 35000);
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (3, 3, 2, '2010-05-30', 40000, 1, 40000);
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (4, 4, 3, '2010-06-04', 50000, 1, 50000) ;
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (5, 5, 4, '2010-06-05', 65000, 1, 65000);
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (7, 7, 2, '2010-06-12', 700000, 1, 70000);
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (8, 8, 3, '2010-06-15', 42000, 1, 42000);
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (9, 9, 3, '2010-06-16', 60000, 1, 60000);
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (10, 10, 4,'2010-06-18', 40000, 1, 40000) ;
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (11, 11, 2, '2010-06-22', 45000, 2, 90000);
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (57, 24, 4, '2011-09-20', 285000, 1, 285000) ;
INSERT INTO Transactions_facts_table (CarId, CustomerId, SalesmanId, SalesDate, Price, Amount, Value)VALUES (59, 12, 2, '2011-09-30', 52000, 1, 52000) ;
GO