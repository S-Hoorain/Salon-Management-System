CREATE TABLE Slots (
    SlotID INT PRIMARY KEY,
    SlotTime TIME NOT NULL
);

CREATE TABLE Client (
    ClientID INT PRIMARY KEY,
    ClientName VARCHAR(100) NOT NULL,
    ClientUsername VARCHAR(100) NOT NULL,
    ClientPassword VARCHAR(100) NOT NULL,
    ClientCNIC BIGINT NOT NULL,
	CLientAddress VARCHAR(100) NOT NULL,
	ClientEmail VARCHAR(100) NOT NULL,
    ClientPhoneNumber BIGINT NOT NULL
);

CREATE TABLE Manager (
    ManagerID INT PRIMARY KEY,
    ManagerName VARCHAR(100) NOT NULL,
    ManagerUsername VARCHAR(100) NOT NULL,
    ManagerPassword VARCHAR(100) NOT NULL,
    ManagerCNIC BIGINT NOT NULL,
    ManagerPhone BIGINT NOT NULL
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    PhoneNumber BIGINT NOT NULL
);


CREATE TABLE ServiceData (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL
);


CREATE TABLE Appointments (
    AppID INT PRIMARY KEY,
    AppDate DATETIME NOT NULL,
    ManagerID INT,
    ClientID INT,
    FOREIGN KEY (ManagerID) REFERENCES Manager(ManagerID),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

CREATE TABLE App_Employees (
    AppID INT,
    EmployeeID INT,
    PRIMARY KEY (AppID, EmployeeID),
    FOREIGN KEY (AppID) REFERENCES Appointments(AppID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
	);


CREATE TABLE App_Service (
    AppID INT,
    ServiceID INT,
    PRIMARY KEY (AppID, ServiceID),
    FOREIGN KEY (AppID) REFERENCES Appointments(AppID),
    FOREIGN KEY (ServiceID) REFERENCES ServiceData(ServiceID)
);


CREATE TABLE Employee_Service (
    EmployeeID INT,
    ServiceID INT,
    PRIMARY KEY (EmployeeID, ServiceID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ServiceID) REFERENCES ServiceData(ServiceID)
);


INSERT INTO Slots (SlotID, SlotTime) VALUES (1, '09:00:00');
INSERT INTO Slots (SlotID, SlotTime) VALUES (2, '11:00:00');
INSERT INTO Slots (SlotID, SlotTime) VALUES (3, '13:00:00');
INSERT INTO Slots (SlotID, SlotTime) VALUES (4, '15:00:00');
INSERT INTO Slots (SlotID, SlotTime) VALUES (5, '17:00:00');
INSERT INTO Slots (SlotID, SlotTime) VALUES (6, '19:00:00');
INSERT INTO Slots (SlotID, SlotTime) VALUES (7, '21:00:00');


INSERT INTO Client (ClientID, ClientName, ClientUsername, ClientPassword, ClientCNIC, ClientAddress, ClientEmail, ClientPhoneNumber)
VALUES 
(1, 'Ali Khan', 'alikhan', 'password123', 123456789,'123 Maple Lane, Springfield, IL 62704, United States', 'ali.khan123@example.com',03001234567),
(2, 'Ayesha Siddiqui', 'ayeshaz', 'securepass456', 123987456, '456 Oak Street, Riverside, CA 92501, United States', 'ayesh.az456@email.net', 03121234567),
(3, 'Omer Farooq', 'omerf', 'pass789', 234567891,'789 Pine Avenue, Austin, TX 73301, United States','omer.f789@domain.org', 03004567891),
(4, 'Fatima Ali', 'fatimaA', 'mypassword', 345678912,'101 Birch Road, Denver, CO 80202, United States', 'fati.ali321@company.edu',03213456789);

INSERT INTO Manager (ManagerID, ManagerName, ManagerUsername, ManagerPassword, ManagerCNIC, ManagerPhone)
VALUES 
(1, 'Sarah Ahmed', 'sarahahmed', 'admin123', 987654321, 03219876543),
(2, 'Bilal Khan', 'bilalk', 'manager123', 678901234, 03331234567),
(3, 'Zara Shah', 'zarash', 'zpassword', 567890123, 03459876543);

INSERT INTO Employees (EmployeeID, FirstName, LastName, PhoneNumber)
VALUES 
(1, 'John', 'Doe', 03111234567),
(2, 'Jane', 'Smith', 03021234567),
(3, 'Ahmed', 'Khan', 03137894567),
(4, 'Sara', 'Yousaf', 03452345678),
(5, 'Ali', 'Raza', 03551237891);

INSERT INTO ServiceData (ServiceID, ServiceName)
VALUES 
(1, 'Hair Cut'),
(2, 'Manicure'),
(3, 'Pedicure'),
(4, 'Facial'),
(5, 'Mehendi'),
(6, 'Wax'),
(7, 'Massage'),
(8, 'Hair Wash'),
(9, 'Hair treatment'),
(10, 'Make Up');

INSERT INTO Appointments (AppID, AppDate, ManagerID, ClientID)
VALUES 
(1, '2024-12-01 09:00:00', 1, 1),
(2, '2024-12-01 13:00:00', 2, 2),
(3, '2024-12-01 11:00:00', 3, 3),
(4, '2024-12-02 09:00:00', 1, 4),
(5, '2024-12-02 11:00:00', 2, 1),
(6, '2024-12-03 09:00:00', 1, 1),
(7, '2024-12-04 11:00:00', 2, 1),
(8, '2024-12-07 09:00:00', 1, 1),
(9, '2024-12-09 11:00:00', 1, 1),
(10, '2024-12-10 09:00:00', 1, 1),
(11, '2024-12-11 11:00:00', 1, 1),
(12, '2024-12-12 11:00:00', 1, 1),
(13, '2024-12-13 09:00:00', 1, 1),
(14, '2024-12-14 11:00:00', 1, 1),
(15, '2024-12-15 11:00:00', 1, 1),
(16, '2024-12-16 09:00:00', 1, 1);


INSERT INTO App_Employees (AppID, EmployeeID)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 3);


INSERT INTO App_Service (AppID, ServiceID)
VALUES 
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(2,3),
(6,2),
(7,3);


INSERT INTO Employee_Service (EmployeeID, ServiceID)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(3, 1),
(4, 2),
(8, 2),
(9, 3),
(10,5),
(11,4),
(12,3),
(13,2),
(14,1),
(15,2),
(16,3);
