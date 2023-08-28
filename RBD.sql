DROP TABLE Transactions;
DROP TABLE Property;
DROP TABLE Client;
DROP TABLE Category_of_property;
DROP TABLE Appointment;
DROP TABLE Agent;


-- Table: Agent
CREATE TABLE Agent (
    First_name varchar(20)  NOT NULL,
    Last_name varchar(20)  NOT NULL,
    AgentID int  NOT NULL,
    Boss int  NOT NULL,
    CONSTRAINT Agent_pk PRIMARY KEY (AgentID)
);

-- Table: Appointment
CREATE TABLE Appointment  (
    Client_ClientID int  NOT NULL,
    Agent_AgentID int  NOT NULL,
    AppointmentID  int  NOT NULL,
    Property_PropertyID int  NOT NULL,
    CONSTRAINT Appointment_pk PRIMARY KEY (AppointmentID )
);

-- Table: Category_of_property
CREATE TABLE Category_of_property (
    Name varchar(20)  NOT NULL,
    Minimal_Space int  NOT NULL,
    Max_Space int  NOT NULL,
    CONSTRAINT Category_of_property_pk PRIMARY KEY (Name)
);

-- Table: Client
CREATE TABLE Client  (
    C_First_name varchar(20)  NOT NULL,
    C_Last_name varchar(20)  NOT NULL,
    ClientID int  NOT NULL,
    CONSTRAINT Client_pk PRIMARY KEY (ClientID)
);

-- Table: Property
CREATE TABLE Property  (
    PropertyID int  NOT NULL,
    Size_Property int  NOT NULL,
    Type_Property int  NOT NULL,
    Address_Property int  NOT NULL,
    Bedrooms int  NOT NULL,
    CONSTRAINT Property_pk PRIMARY KEY (PropertyID)
);

-- Table: Transactions
CREATE TABLE Transactions (
    Transaction_ID int  NOT NULL,
    Client_ClientID int  NOT NULL,
    Agent_AgentID int  NOT NULL,
    Date_of_Transactions int  NOT NULL,
    Property_PropertyID int  NOT NULL,
    CONSTRAINT Transactions_pk PRIMARY KEY (Transaction_ID)
);





INSERT INTO Agent (First_name, Last_name, AgentID, Boss)
VALUES ('Eric', 'Cold', 1, 0);
INSERT INTO Agent (First_name, Last_name, AgentID, Boss)
VALUES ('Dmytro', 'Horod', 1, 0);

-- Inserting the first appointment
INSERT INTO Appointment(Client_ClientID, Agent_AgentID, AppointmentID, Property_PropertyID)
VALUES (1, 1, 1, 1);

INSERT INTO Appointment(Client_ClientID, Agent_AgentID, AppointmentID, Property_PropertyID)
VALUES (2, 2, 2, 2);


INSERT INTO Category_of_property(Name, Minimal_Space, Max_Space)
VALUES ('Category1', 100, 200);

INSERT INTO Category_of_property(Name, Minimal_Space, Max_Space)
VALUES ('Category2', 200, 300);

INSERT INTO Category_of_property(Name, Minimal_Space, Max_Space)
VALUES ('Category3', 300, 400);


INSERT INTO Client(C_First_name, C_Last_name, ClientID)
VALUES ('John', 'Doe', 1);

INSERT INTO Client(C_First_name, C_Last_name, ClientID)
VALUES ('Jane', 'Smith', 2);

INSERT INTO Client(C_First_name, C_Last_name, ClientID)
VALUES ('Bob', 'Johnson', 3);


INSERT INTO Property(PropertyID, Size_Property, Type_Property, Address_Property, Bedrooms)
VALUES (1, 100, 2, 101, 3);

INSERT INTO Property(PropertyID, Size_Property, Type_Property, Address_Property, Bedrooms)
VALUES (2, 200, 3, 102, 2);

INSERT INTO Property(PropertyID, Size_Property, Type_Property, Address_Property, Bedrooms)
VALUES (3, 150, 2, 103, 4);

INSERT INTO Transactions(Transaction_ID, Client_ClientID, Agent_AgentID, Date_of_Transactions, Property_PropertyID)
VALUES (1, 1, 1, 20230630, 1);

INSERT INTO Transactions(Transaction_ID, Client_ClientID, Agent_AgentID, Date_of_Transactions, Property_PropertyID)
VALUES (2, 2, 2, 20230701, 2);


--All properties from the Property database whose Size_Property is bigger than the average Size_Property of properties with the same Type_Property will be returned by the linked subquery.
SELECT *
FROM Property p
WHERE p.Size_Property > (SELECT AVG(Size_Property) FROM Property WHERE p.Type_Property = Type_Property);

--All properties from the Property table whose Size_Property is higher than the average Size_Property for all properties in the table will be returned via an uncorrelated subquery.
SELECT *
FROM Property
WHERE Size_Property > (SELECT AVG(Size_Property) FROM Property);

--First_name, Last_name, and Boss (with null values replaced by 'No Boss') will be returned from the Agent table by a query using the NVL function.
SELECT First_name, Last_name, NVL(Boss, 'No Boss') AS Boss
FROM Agent;

--Name starts from J
SELECT *
FROM Agent
WHERE First_name LIKE 'J%';

--All properties from the Property table where the Size_Property is bigger than each Minimal_Space value in the Category_of_Property table will be returned
SELECT *
FROM Property
WHERE Size_Property > ALL (SELECT Minimal_Space FROM Category_of_property);


-- "ANY" operator will retrieve all properties from the Property table where the Size_Property is greater than at least one Max_Space value in the Category_of_property table.
SELECT *
FROM Property
WHERE Size_Property > ANY (SELECT Max_Space FROM Category_of_property);

--"EXISTS" operator will retrieve all agents from the Agent table for whom at least one matching appointment exists in the Appointment table.
SELECT *
FROM Agent
WHERE EXISTS (SELECT * FROM Appointment WHERE Appointment.Agent_AgentID = Agent.AgentID);


--checking property where 2-3 bedrooms
SELECT *
FROM Property
WHERE Bedrooms IN (2, 3);

--sort agents  
SELECT *
FROM Agent
ORDER BY Last_name ASC, First_name ASC;

-- GROUP BY function will retrieve the distinct Type_Property values from the Property table and the count of properties for each type.
SELECT Type_Property, COUNT(*) AS Property_Count
FROM Property
GROUP BY Type_Property;


--who has more that 0 appointments
SELECT   Agent_AgentID, COUNT(*) AS AppointmentCount
FROM Appointment
GROUP BY   Agent_AgentID
HAVING COUNT(*) > 0;

--vertical join
SELECT First_name, Last_name, AgentID as ID, 'Agent' as Type
FROM Agent
UNION ALL
SELECT C_First_name, C_Last_name, ClientID, 'Client'
FROM Client;

-- retrive the ID of each property and the corresponding category name based on the property's size, 
SELECT p.PropertyID, c.Name AS CategoryName
FROM Property p, Category_of_property c
WHERE p.Size_Property BETWEEN c.Minimal_Space AND c.Max_Space;


--joining Agent table to itself comparin
SELECT a1.First_name AS AgentName, a2.First_name AS BossName
FROM Agent a1
JOIN Agent a2 ON a1.Boss = a2.AgentID;
