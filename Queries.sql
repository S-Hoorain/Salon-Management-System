
SELECT * FROM Slots;
SELECT * FROM Appointments;
SELECT * FROM Manager;
SELECT * FROM Client;
SELECT * FROM App_Employees;
SELECT * FROM App_Service;
SELECT * FROM Employees;
SELECT * FROM ServiceData;
SELECT * FROM Employee_Service;

--signup
CREATE PROCEDURE SignupClient
    @ClientName VARCHAR(50),
    @ClientUserName VARCHAR(50),
    @ClientPassword VARCHAR(50),
    @ClientCNIC VARCHAR(50),
	@ClientAddress VARCHAR(100),
	@ClientEmail VARCHAR(100),
    @ClientPhoneNumber VARCHAR(50)
AS
BEGIN
    -- Check if the username already exists
    IF EXISTS (
        SELECT 1 
        FROM Client 
        WHERE ClientUserName = @ClientUserName
    )
    BEGIN
        SELECT 'Username already exists. Please choose a different username.' AS Message;
        RETURN;
    END

	-- Calculate the next ClientID by counting existing clients
    DECLARE @NextClientID INT;
    SELECT @NextClientID = ISNULL(MAX(ClientID), 0) + 1 FROM Client;

    -- Insert new client details into the Client table
    INSERT INTO Client (ClientID, ClientName, ClientUserName, ClientPassword, ClientCNIC, ClientAddress, ClientEmail, ClientPhoneNumber)
    VALUES (@NextClientID, @ClientName, @ClientUserName, @ClientPassword, @ClientCNIC, @ClientAddress, @ClientEmail, @ClientPhoneNumber);



    SELECT 'Signup successful. Welcome to the team!' AS Message;
END;


--Past appointments
CREATE PROCEDURE PastAppointments
    @ClientID INT
AS
BEGIN
	SELECT A.AppID,CONVERT(DATE, AppDate) AS AppointmentDate,
	CONVERT(DATE, AppDate) AS AppointmentTime
	FROM Appointments A
	WHERE ClientID= @ClientID AND CONVERT(DATE, AppDate)<GetDate();
END;
DROP PROCEDURE PastAppointments;


--Future Appointments
CREATE PROCEDURE FutureAppointments
    @ClientID INT
AS
BEGIN
	SELECT A.AppID,CONVERT(DATE, AppDate) AS AppointmentDate,
	CONVERT(TIME, AppDate) AS AppointmentTime
	FROM Appointments A
	WHERE ClientID= @ClientID AND CONVERT(DATE, AppDate)>GetDate();
END;
DROP PROCEDURE FutureAppointments;

Select * from Appointments Where ClientID=1 AND CONVERT(DATE, AppDate)>GetDate();

--Viewing details of an appointment (for client and manager)
CREATE PROCEDURE AppointmentDetails
    @AppID INT
AS
BEGIN
    SELECT 
        SD.ServiceName,
        E.FirstName + ' ' + E.LastName AS EmployeeName  -- Concatenate FirstName and LastName to get EmployeeName
    FROM Appointments A
    JOIN App_Employees AE ON AE.AppID = A.AppID
    JOIN App_Service ASe ON ASe.AppID = A.AppID
    JOIN Employees E ON E.EmployeeID = AE.EmployeeID
    JOIN ServiceData SD ON SD.ServiceID = ASe.ServiceID
    WHERE A.AppID = @AppID;
END;
DROP PROCEDURE AppointmentDetails;

--Assigning Employees (for manager)
CREATE PROCEDURE AssignEmployee
    @EmployeeID INT,
    @AppID INT,
    @ServiceName VARCHAR(100),
    @ScheduledDate DATE,
    @Slot TIME
AS
BEGIN
    -- Update employee assignment
    UPDATE AE
    SET AE.EmployeeID = @EmployeeID
    FROM App_Employees AE
    JOIN Employee_Service ES ON ES.EmployeeID = AE.EmployeeID
    JOIN Appointments A ON A.AppID = AE.AppID
    WHERE AE.AppID = @AppID
    AND ES.ServiceID = (SELECT ServiceID
                         FROM ServiceData
                         WHERE ServiceName = @ServiceName)
    AND NOT EXISTS (
        SELECT 1
        FROM Appointments A
        JOIN App_Employees AE ON AE.AppID = A.AppID
        WHERE AE.EmployeeID = @EmployeeID
          AND A.AppDate = CAST(CONCAT(CAST(@ScheduledDate AS VARCHAR), ' ', CAST(@Slot AS VARCHAR)) AS DATETIME)
    );
END;

DROP PROCEDURE AssignEmployee;

--View  all appointments (for manager)
CREATE VIEW ViewAppointments AS
SELECT 
    ClientID,
    A.AppID,
    CONVERT(DATE, AppDate) AS AppointmentDate,
    CONVERT(TIME, AppDate) AS AppointmentTime
FROM Appointments A
JOIN App_Employees AE ON AE.AppID = A.AppID
JOIN App_Service ASe ON ASe.AppID = A.AppID
JOIN Employees E ON E.EmployeeID = AE.EmployeeID
JOIN ServiceData SD ON SD.ServiceID = ASe.ServiceID;

--Book appointments
CREATE PROCEDURE BookAppointment
    @ClientID INT,
    @ManagerID INT,
    @AppDate DATETIME, 
    @ServiceID INT
AS
BEGIN
    -- Check if the selected slot already has 7 appointments
    DECLARE @CurrentCapacity INT;
    SELECT @CurrentCapacity = COUNT(*)
    FROM Appointments
    WHERE AppDate = @AppDate;

    -- If the capacity is full
    IF @CurrentCapacity >= 7
    BEGIN
        PRINT 'This slot is fully booked. Please choose another slot.';
        RETURN;
    END

    -- Calculate the next AppID by counting existing Appointments
    DECLARE @NewAppID INT;
    SELECT @NewAppID = ISNULL(MAX(AppID), 0) + 1 FROM Appointments;

	INSERT INTO Appointments (AppID, AppDate, ClientID, ManagerID)
    VALUES (
		@NewAppID,
        @AppDate,
        @ClientID,
        @ManagerID
    );

    

    -- Insert into App_Service table to link the service to the appointment
    INSERT INTO App_Service (AppID, ServiceID)
    VALUES (@NewAppID, @ServiceID);

    PRINT 'Appointment successfully booked.';
END;


EXEC BookAppointment @ClientID=1,
    @ManagerID=1,
    @AppDate= '2024-12-17 09:00:00', 
    @ServiceID=1;
DROP PROCEDURE BookAppointment;