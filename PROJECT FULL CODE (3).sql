use project

create table Users (
UserID int primary key,
FirstName varchar(50),
LastName varchar(50),
Email varchar(100) UNIQUE,
RegistrationDate date,
DateOfBirth date,
Address_Street varchar(100),
Address_City varchar(50),
Address_ZipCode varchar(10),
UserType varchar(20),
CHECK (UserType IN ('citizen', 'collector', 'admin')))
create table UserPhoneNumbers (
UserID int,
PhoneNumber varchar(20),
PRIMARY KEY (UserID, PhoneNumber),
foreign key (UserID) references Users(UserID))
create table Citizens (
CitizenID int primary key,
UserID int UNIQUE,
PreferredPickupTime TIME,
NumberOfRequestsMade int,
Location_Latitude decimal(9,6),
Location_Longitude decimal(9,6),
LastRequestDate date,
foreign key (UserID) references Users(UserID))
create table CitizenFeedbacks (
CitizenID int,
Feedback varchar(100),
PRIMARY KEY (CitizenID, Feedback),
foreign key (CitizenID) references Citizens(CitizenID))
create table Collectors (
CollectorID int primary key,
UserID int UNIQUE,
LicenseNumber varchar(50),
CurrentVehicleID int,
TotalCollections int,
Shift_Start TIME,
Shift_End TIME,
EmploymentDate date,
ActiveStatus bit,
AreaAssigned varchar(100),
foreign key (UserID) references Users(UserID))
create table CollectorAssignedRequests (
CollectorID int,
RequestID int,
PRIMARY KEY (CollectorID, RequestID),
foreign key (CollectorID) references Collectors(CollectorID))
create table Admins (
AdminID int primary key,
UserID int UNIQUE,
ReportsGenerated int,
LastLoginDate date,
WorkShift varchar(50),
ApprovalCount int,
foreign key (UserID) references Users(UserID))
create table AdminManagedZones (
AdminID int,
ZoneName varchar(100),
PRIMARY KEY (AdminID, ZoneName),
foreign key (AdminID) references Admins(AdminID))
create table PickupRequests (
RequestID int primary key,
CitizenID int,
AdminID int,
CollectorID int,
RequestDate date,
ApprovalStatus varchar(20),
TotalWeight decimal(6,2),
Pickup_Street varchar(100),
Pickup_City varchar(50),
Pickup_ZipCode varchar(10),
PickupStatus varchar(20),
foreign key (CitizenID) references Citizens(CitizenID),
foreign key(AdminID) references Admins(AdminID),
foreign key (CollectorID) references Collectors(CollectorID),
CHECK (ApprovalStatus IN ('Pending', 'Approved', 'Rejected')),
CHECK (PickupStatus IN ('Scheduled', 'Collected', 'Missed')))
create table PickupRequest_WasteItems (
RequestID int,
WasteItem varchar(100),
PRIMARY KEY (RequestID, WasteItem),
foreign key (RequestID) references PickupRequests(RequestID))
create table Vehicles (
VehicleID int primary key,
VehicleType varchar(50),
Capacity decimal(6,2),
AssignedCollectorID int UNIQUE,
Location_Latitude decimal(9,6),
Location_Longitude decimal(9,6),
Status varchar(20),
FuelType varchar(30),
OdometerReading int,
foreign key (AssignedCollectorID) references Collectors(CollectorID),
CHECK (Status IN ('Available', 'Assigned', 'Maintenance')))
create table RecycleCenters (
CenterID int primary key,
CenterName varchar(100),
Address_Street varchar(100),
Address_City varchar(50),
Address_ZipCode varchar(10),
ContactNumber varchar(20),
AdminID int,
TotalWasteReceived decimal(10,2),
CenterCapacity decimal(10,2),
InventoryID int UNIQUE,
EstablishedDate date,
foreign key (AdminID) references Admins(AdminID),
foreign key (InventoryID) references Inventory(InventoryID))
create table RecycleCenter_WasteCategories (
CenterID int,
WasteCategory varchar(50),
PRIMARY KEY (CenterID, WasteCategory),
foreign key (CenterID) references RecycleCenters(CenterID))
create table Recyclers (
RecyclerID int primary key,
CenterID int,
FirstName varchar(50),
LastName varchar(50),
Email varchar(100),
Phone varchar(20),
Specialization varchar(100),
Shift varchar(50),
foreign key (CenterID) references RecycleCenters(CenterID))
create table Recycler_RecycledItemsLog (
RecyclerID int,
Item varchar(100),
PRIMARY KEY (RecyclerID, Item),
foreign key (RecyclerID) references Recyclers(RecyclerID))
create table Inventory (
InventoryID int primary key,
CenterID int UNIQUE,
MaxCapacity decimal(10,2),
LastUpdatedDate date,
TotalWeightStored decimal(10,2),
InventoryManagerID int)
CREATE TABLE Inventory_ItemTypes (
InventoryID int,
ItemType varchar(50),
PRIMARY KEY (InventoryID, ItemType),
foreign key (InventoryID) references Inventory(InventoryID))
create table Inventory_StockLevels (
InventoryID int,
ItemType varchar(50),
Quantity decimal(8,2),
PRIMARY KEY (InventoryID, ItemType),
foreign key (InventoryID, ItemType) references Inventory_ItemTypes(InventoryID, ItemType))
create table Reports (
ReportID int primary key,
AdminID int,
GeneratedDate date,
TimePeriodCovered varchar(50),
TotalPickups int,
TotalRecycled int,
IssuesFound text,
WasteTypeBreakdown text,
ReviewedBy varchar(100),
LocationStats_Latitude DECIMAL(9,6),
LocationStats_Longitude DECIMAL(9,6),
foreign key (AdminID) references Admins(AdminID))
create table Report_TopCollectors (
ReportID int,
CollectorID int,
PRIMARY KEY (ReportID, CollectorID),
foreign key (ReportID) references Reports(ReportID),
foreign key (CollectorID) references Collectors(CollectorID))
create table Collector_Deliveries (
CollectorID int,
CenterID int,
DeliveryDate date,
PRIMARY KEY (CollectorID, CenterID, DeliveryDate),
foreign key (CollectorID) references Collectors(CollectorID),
foreign key (CenterID) references RecycleCenters(CenterID))

INSERT INTO Users
VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '2022-01-15', '1985-05-10', '123 Main St', 'Springfield', '12345', 'citizen'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '2022-02-20', '1990-08-25', '456 Oak Ave', 'Shelbyville', '23456', 'citizen'),
(3, 'Robert', 'Brown', 'robert.brown@example.com', '2022-03-05', '1978-11-30', '789 Pine Rd', 'Capital City', '34567', 'citizen'),
(4, 'Emily', 'Davis', 'emily.davis@example.com', '2022-04-10', '1995-04-15', '101 Elm Blvd', 'Ogdenville', '45678', 'citizen'),
(5, 'Michael', 'Wilson', 'michael.wilson@example.com', '2022-05-25', '1982-07-20', '202 Maple Dr', 'North Haverbrook', '56789', 'citizen'),
(6, 'Sarah', 'Taylor', 'sarah.taylor@example.com', '2022-06-30', '1993-09-12', '303 Cedar Ln', 'Brockway', '67890', 'citizen'),
(7, 'David', 'Anderson', 'david.anderson@example.com', '2022-07-15', '1975-12-05', '404 Birch St', 'Springfield', '78901', 'citizen'),
(8, 'Jessica', 'Thomas', 'jessica.thomas@example.com', '2022-08-20', '1988-03-18', '505 Spruce Ave', 'Shelbyville', '89012', 'citizen'),
(9, 'Daniel', 'Jackson', 'daniel.jackson@example.com', '2022-09-25', '1991-06-22', '606 Willow Rd', 'Capital City', '90123', 'citizen'),
(10, 'Lisa', 'White', 'lisa.white@example.com', '2022-10-30', '1980-01-08', '707 Aspen Blvd', 'Ogdenville', '01234', 'citizen'),
(11, 'Matthew', 'Harris', 'matthew.harris@example.com', '2022-11-05', '1972-10-14', '808 Redwood Dr', 'North Haverbrook', '12340', 'citizen'),
(12, 'Amanda', 'Martin', 'amanda.martin@example.com', '2022-12-10', '1994-02-28', '909 Sequoia Ln', 'Brockway', '23451', 'citizen'),
(13, 'Christopher', 'Garcia', 'christopher.garcia@example.com', '2023-01-15', '1987-07-03', '111 Fir St', 'Springfield', '34562', 'citizen'),
(14, 'Ashley', 'Lee', 'ashley.lee@example.com', '2023-02-20', '1996-04-17', '222 Juniper Ave', 'Shelbyville', '45673', 'citizen'),
(15, 'James', 'Clark', 'james.clark@example.com', '2023-03-25', '1979-08-09', '333 Magnolia Rd', 'Capital City', '56784', 'citizen');
INSERT INTO Users
VALUES
(16, 'Kevin', 'Adams', 'kevin.adams@example.com', '2021-05-10', '1983-09-15', '444 Oak St', 'Ogdenville', '67895', 'collector'),
(17, 'Nicole', 'Baker', 'nicole.baker@example.com', '2021-06-15', '1990-12-20', '555 Pine Ave', 'North Haverbrook', '78906', 'collector'),
(18, 'Brian', 'Carter', 'brian.carter@example.com', '2021-07-20', '1976-03-25', '666 Maple Rd', 'Brockway', '89017', 'collector'),
(19, 'Rachel', 'Evans', 'rachel.evans@example.com', '2021-08-25', '1985-06-30', '777 Cedar Blvd', 'Springfield', '90128', 'collector'),
(20, 'Steven', 'Foster', 'steven.foster@example.com', '2021-09-30', '1992-01-05', '888 Birch Dr', 'Shelbyville', '01239', 'collector'),
(21, 'Melissa', 'Green', 'melissa.green@example.com', '2021-10-05', '1988-04-10', '999 Spruce Ln', 'Capital City', '12350', 'collector'),
(22, 'Timothy', 'Hill', 'timothy.hill@example.com', '2021-11-10', '1974-07-15', '1010 Willow St', 'Ogdenville', '23461', 'collector'),
(23, 'Laura', 'Ingram', 'laura.ingram@example.com', '2021-12-15', '1993-10-20', '1111 Aspen Ave', 'North Haverbrook', '34572', 'collector'),
(24, 'Jason', 'King', 'jason.king@example.com', '2022-01-20', '1981-02-25', '1212 Redwood Rd', 'Brockway', '45683', 'collector'),
(25, 'Stephanie', 'Lopez', 'stephanie.lopez@example.com', '2022-02-25', '1995-05-30', '1313 Sequoia Blvd', 'Springfield', '56794', 'collector'),
(26, 'Ryan', 'Mitchell', 'ryan.mitchell@example.com', '2022-03-30', '1978-08-05', '1414 Fir Dr', 'Shelbyville', '67805', 'collector'),
(27, 'Kimberly', 'Nelson', 'kimberly.nelson@example.com', '2022-04-05', '1986-11-10', '1515 Juniper Ln', 'Capital City', '78916', 'collector'),
(28, 'Eric', 'Owens', 'eric.owens@example.com', '2022-05-10', '1991-01-15', '1616 Magnolia St', 'Ogdenville', '89027', 'collector'),
(29, 'Angela', 'Perez', 'angela.perez@example.com', '2022-06-15', '1973-04-20', '1717 Oak Ave', 'North Haverbrook', '90138', 'collector'),
(30, 'Justin', 'Roberts', 'justin.roberts@example.com', '2022-07-20', '1989-07-25', '1818 Pine Rd', 'Brockway', '01249', 'collector');

INSERT INTO Users
VALUES
(31, 'Brandon', 'Scott', 'brandon.scott@example.com', '2020-01-05', '1980-10-12', '1919 Cedar Blvd', 'Springfield', '12350', 'admin'),
(32, 'Megan', 'Turner', 'megan.turner@example.com', '2020-02-10', '1994-03-17', '2020 Birch Dr', 'Shelbyville', '23461', 'admin'),
(33, 'Nathan', 'Walker', 'nathan.walker@example.com', '2020-03-15', '1977-06-22', '2121 Spruce Ln', 'Capital City', '34572', 'admin'),
(34, 'Olivia', 'Young', 'olivia.young@example.com', '2020-04-20', '1984-09-27', '2222 Willow St', 'Ogdenville', '45683', 'admin'),
(35, 'Patrick', 'Zimmerman', 'patrick.zimmerman@example.com', '2020-05-25', '1997-12-02', '2323 Aspen Ave', 'North Haverbrook', '56794', 'admin'),
(36, 'Hannah', 'Allen', 'hannah.allen@example.com', '2020-06-30', '1982-02-07', '2424 Redwood Rd', 'Brockway', '67805', 'admin'),
(37, 'Alexander', 'Bennett', 'alexander.bennett@example.com', '2020-07-05', '1975-05-12', '2525 Sequoia Blvd', 'Springfield', '78916', 'admin'),
(38, 'Victoria', 'Coleman', 'victoria.coleman@example.com', '2020-08-10', '1990-08-17', '2626 Fir Dr', 'Shelbyville', '89027', 'admin'),
(39, 'Samuel', 'Dixon', 'samuel.dixon@example.com', '2020-09-15', '1987-11-22', '2727 Juniper Ln', 'Capital City', '90138', 'admin'),
(40, 'Christina', 'Edwards', 'christina.edwards@example.com', '2020-10-20', '1979-01-27', '2828 Magnolia St', 'Ogdenville', '01249', 'admin'),
(41, 'Benjamin', 'Flores', 'benjamin.flores@example.com', '2020-11-25', '1993-04-02', '2929 Oak Ave', 'North Haverbrook', '12350', 'admin'),
(42, 'Samantha', 'Gonzalez', 'samantha.gonzalez@example.com', '2020-12-30', '1986-07-07', '3030 Pine Rd', 'Brockway', '23461', 'admin'),
(43, 'Dylan', 'Hughes', 'dylan.hughes@example.com', '2021-01-05', '1972-10-12', '3131 Cedar Blvd', 'Springfield', '34572', 'admin'),
(44, 'Natalie', 'Irwin', 'natalie.irwin@example.com', '2021-02-10', '1995-01-17', '3232 Birch Dr', 'Shelbyville', '45683', 'admin'),
(45, 'Caleb', 'Jenkins', 'caleb.jenkins@example.com', '2021-03-15', '1981-04-22', '3333 Spruce Ln', 'Capital City', '56794', 'admin');
select * from users
 


INSERT INTO Citizens (CitizenID, UserID, PreferredPickupTime, NumberOfRequestsMade, Location_Latitude, Location_Longitude, LastRequestDate)
VALUES
(1, 1, '08:00:00', 5, 34.052235, -118.243683, '2023-05-10'),
(2, 2, '09:30:00', 3, 34.052236, -118.243684, '2023-05-12'),
(3, 3, '10:00:00', 7, 34.052237, -118.243685, '2023-05-15'),
(4, 4, '11:00:00', 2, 34.052238, -118.243686, '2023-05-18'),
(5, 5, '13:00:00', 4, 34.052239, -118.243687, '2023-05-20'),
(6, 6, '14:00:00', 6, 34.052240, -118.243688, '2023-05-22'),
(7, 7, '15:30:00', 1, 34.052241, -118.243689, '2023-05-25'),
(8, 8, '16:00:00', 8, 34.052242, -118.243690, '2023-05-28'),
(9, 9, '07:30:00', 5, 34.052243, -118.243691, '2023-06-01'),
(10, 10, '12:00:00', 3, 34.052244, -118.243692, '2023-06-05'),
(11, 11, '08:30:00', 9, 34.052245, -118.243693, '2023-06-10'),
(12, 12, '10:30:00', 2, 34.052246, -118.243694, '2023-06-15'),
(13, 13, '09:00:00', 4, 34.052247, -118.243695, '2023-06-20'),
(14, 14, '11:30:00', 7, 34.052248, -118.243696, '2023-06-25'),
(15, 15, '14:30:00', 6, 34.052249, -118.243697, '2023-06-30');
select* from citizens
 

INSERT INTO Collectors (CollectorID, UserID, LicenseNumber, CurrentVehicleID, TotalCollections, Shift_Start, Shift_End, EmploymentDate, ActiveStatus, AreaAssigned)
VALUES
(1, 16, 'LIC-1001', 1, 120, '07:00:00', '15:00:00', '2021-05-10', 1, 'Springfield'),
(2, 17, 'LIC-1002', 2, 95, '08:00:00', '16:00:00', '2021-06-15', 1, 'Shelbyville'),
(3, 18, 'LIC-1003', 3, 80, '09:00:00', '17:00:00', '2021-07-20', 1, 'Capital City'),
(4, 19, 'LIC-1004', 4, 110, '10:00:00', '18:00:00', '2021-08-25', 1, 'Ogdenville'),
(5, 20, 'LIC-1005', 5, 65, '11:00:00', '19:00:00', '2021-09-30', 1, 'North Haverbrook'),
(6, 21, 'LIC-1006', 6, 150, '06:00:00', '14:00:00', '2021-10-05', 1, 'Brockway'),
(7, 22, 'LIC-1007', 7, 70, '12:00:00', '20:00:00', '2021-11-10', 1, 'Springfield'),
(8, 23, 'LIC-1008', 8, 85, '07:30:00', '15:30:00', '2021-12-15', 1, 'Shelbyville'),
(9, 24, 'LIC-1009', 9, 100, '08:30:00', '16:30:00', '2022-01-20', 1, 'Capital City'),
(10, 25, 'LIC-1010', 10, 55, '09:30:00', '17:30:00', '2022-02-25', 1, 'Ogdenville'),
(11, 26, 'LIC-1011', 11, 130, '10:30:00', '18:30:00', '2022-03-30', 1, 'North Haverbrook'),
(12, 27, 'LIC-1012', 12, 75, '11:30:00', '19:30:00', '2022-04-05', 1, 'Brockway'),
(13, 28, 'LIC-1013', 13, 90, '06:30:00', '14:30:00', '2022-05-10', 1, 'Springfield'),
(14, 29, 'LIC-1014', 14, 60, '07:00:00', '15:00:00', '2022-06-15', 1, 'Shelbyville'),
(15, 30, 'LIC-1015', 15, 105, '08:00:00', '16:00:00', '2022-07-20', 1, 'Capital City');
select* from collectors
 
INSERT INTO Admins (AdminID, UserID, ReportsGenerated, LastLoginDate, WorkShift, ApprovalCount)
VALUES
(1, 31, 25, '2023-07-01', 'Morning (8AM-4PM)', 150),
(2, 32, 18, '2023-07-02', 'Afternoon (12PM-8PM)', 120),
(3, 33, 30, '2023-07-03', 'Evening (4PM-12AM)', 200),
(4, 34, 12, '2023-07-04', 'Morning (8AM-4PM)', 80),
(5, 35, 22, '2023-07-05', 'Night (12AM-8AM)', 90),
(6, 36, 15, '2023-07-06', 'Afternoon (12PM-8PM)', 110),
(7, 37, 28, '2023-07-07', 'Morning (8AM-4PM)', 170),
(8, 38, 10, '2023-07-08', 'Evening (4PM-12AM)', 60),
(9, 39, 20, '2023-07-09', 'Night (12AM-8AM)', 130),
(10, 40, 35, '2023-07-10', 'Morning (8AM-4PM)', 190),
(11, 41, 14, '2023-07-11', 'Afternoon (12PM-8PM)', 70),
(12, 42, 26, '2023-07-12', 'Evening (4PM-12AM)', 160),
(13, 43, 19, '2023-07-13', 'Night (12AM-8AM)', 100),
(14, 44, 23, '2023-07-14', 'Morning (8AM-4PM)', 140),
(15, 45, 17, '2023-07-15', 'Afternoon (12PM-8PM)', 85);
select* from Admins
 
INSERT INTO UserPhoneNumbers (UserID, PhoneNumber)
VALUES
(1, '+1555123456'), (2, '+1555234567'), (3, '+1555345678'),
(4, '+1555456789'), (5, '+1555567890'), (6, '+1555678901'),
(7, '+1555789012'), (8, '+1555890123'), (9, '+1555901234'),
(10, '+1555012345'), (11, '+1555112233'), (12, '+1555223344'),
(13, '+1555334455'), (14, '+1555445566'), (15, '+1555556677'),
(16, '+1555667788'), (17, '+1555778899'), (18, '+1555889900'),
(19, '+1555990011'), (20, '+1555001122'), (21, '+1555113344'),
(22, '+1555224455'), (23, '+1555335566'), (24, '+1555446677'),
(25, '+1555557788'), (26, '+1555668899'), (27, '+1555779900'),
(28, '+1555880011'), (29, '+1555991122'), (30, '+1555002233'),
(31, '+1555114455'), (32, '+1555225566'), (33, '+1555336677'),
(34, '+1555447788'), (35, '+1555558899'), (36, '+1555669900'),
(37, '+1555770011'), (38, '+1555881122'), (39, '+1555992233'),
(40, '+1555003344'), (41, '+1555115566'), (42, '+1555226677'),
(43, '+1555337788'), (44, '+1555448899'), (45, '+1555559900');
select * from UserPhoneNumbers
 
INSERT INTO CitizenFeedbacks (CitizenID, Feedback)
VALUES
(1, 'Excellent service, very punctual!'),
(2, 'The collector was polite but late.'),
(3, 'Quick and efficient pickup.'),
(4, 'Need more frequent collections in my area.'),
(5, 'Great communication from the team.'),
(6, 'Missed my pickup last week.'),
(7, 'Very satisfied with the service.'),
(8, 'The app makes scheduling easy.'),
(9, 'Sometimes the truck is noisy early in the morning.'),
(10, 'The staff is always friendly.'),
(11, 'Had an issue with a missed pickup, but it was resolved.'),
(12, 'More recycling options would be great.'),
(13, 'Always on time!'),
(14, 'The collector damaged my bin once.'),
(15, 'Overall a good service.');
select * from CitizenFeedbacks
 
INSERT INTO Vehicles (VehicleID, VehicleType, Capacity, AssignedCollectorID, Location_Latitude, Location_Longitude, Status, FuelType, OdometerReading)
VALUES
(1, 'Garbage Truck', 5000.00, 1, 34.052235, -118.243683, 'Available', 'Diesel', 12500),
(2, 'Recycling Van', 3000.00, 2, 34.052236, -118.243684, 'Assigned', 'Electric', 8700),
(3, 'Compactor Truck', 6000.00, 3, 34.052237, -118.243685, 'Maintenance', 'CNG', 15400),
(4, 'Pickup Truck', 2000.00, 4, 34.052238, -118.243686, 'Available', 'Gasoline', 9200),
(5, 'Dump Truck', 4500.00, 5, 34.052239, -118.243687, 'Assigned', 'Diesel', 11200),
(6, 'Electric Cart', 1000.00, 6, 34.052240, -118.243688, 'Available', 'Electric', 5600),
(7, 'Waste Hauler', 5500.00, 7, 34.052241, -118.243689, 'Assigned', 'Diesel', 14300),
(8, 'Recycling Truck', 3500.00, 8, 34.052242, -118.243690, 'Available', 'CNG', 7800),
(9, 'Garbage Truck', 5000.00, 9, 34.052243, -118.243691, 'Maintenance', 'Diesel', 16500),
(10, 'Mini Loader', 1500.00, 10, 34.052244, -118.243692, 'Available', 'Gasoline', 6400),
(11, 'Compactor Truck', 6000.00, 11, 34.052245, -118.243693, 'Assigned', 'Diesel', 13200),
(12, 'Recycling Van', 3000.00, 12, 34.052246, -118.243694, 'Available', 'Electric', 7100),
(13, 'Dump Truck', 4500.00, 13, 34.052247, -118.243695, 'Assigned', 'Diesel', 9800),
(14, 'Electric Cart', 1000.00, 14, 34.052248, -118.243696, 'Available', 'Electric', 5200),
(15, 'Waste Hauler', 5500.00, 15, 34.052249, -118.243697, 'Maintenance', 'Diesel', 14700);
select * from Vehicles
 
INSERT INTO RecycleCenters
(CenterID, CenterName, Address_Street, Address_City, Address_ZipCode,
 ContactNumber, AdminID, TotalWasteReceived, CenterCapacity, InventoryID, EstablishedDate)
VALUES
(1, 'Green Earth Recycling', '100 Eco Drive', 'Springfield', '12345', '+1555666777', 1, 50000.50, 100000.00, 1, '2015-05-10'),
(2, 'Eco-Friendly Hub', '200 Green Lane', 'Shelbyville', '23456', '+1555777888', 2, 45000.75, 95000.00, 2, '2016-06-15'),
(3, 'Sustainable Waste Solutions', '300 Clean Ave', 'Capital City', '34567', '+1555888999', 3, 60000.25, 110000.00, 3, '2017-07-20'),
(4, 'Planet Saver Center', '400 Recycle Blvd', 'Ogdenville', '45678', '+1555999000', 4, 35000.00, 80000.00, 4, '2018-08-25'),
(5, 'Earth First Recycling', '500 Renew Rd', 'North Haverbrook', '56789', '+1555000111', 5, 40000.50, 90000.00, 5, '2019-09-30'),
(6, 'Green Valley Recyclers', '600 Eco Park', 'Brockway', '67890', '+1555111222', 6, 55000.75, 105000.00, 6, '2020-10-05'),
(7, 'Pure Earth Facility', '700 Sustain St', 'Springfield', '78901', '+1555222333', 7, 48000.25, 97000.00, 7, '2021-11-10'),
(8, 'EcoCycle Depot', '800 Green Way', 'Shelbyville', '89012', '+1555333444', 8, 52000.00, 102000.00, 8, '2022-12-15'),
(9, 'Clean Future Center', '900 Reuse Lane', 'Capital City', '90123', '+1555444555', 9, 47000.50, 99000.00, 9, '2023-01-20'),
(10, 'Nature’s Recyclers', '1000 Earth Rd', 'Ogdenville', '01234', '+1555555666', 10, 43000.75, 88000.00, 10, '2020-02-25'),
(11, 'GreenTech Recycling', '1100 Bio Ave', 'North Haverbrook', '12340', '+1555666777', 11, 51000.25, 101000.00, 11, '2021-03-30'),
(12, 'EcoSave Station', '1200 Pure Blvd', 'Brockway', '23451', '+1555777888', 12, 39000.00, 85000.00, 12, '2022-04-05'),
(13, 'EverGreen Recyclers', '1300 Eco Drive', 'Springfield', '34562', '+1555888999', 13, 54000.50, 107000.00, 13, '2023-05-10'),
(14, 'EarthCare Facility', '1400 Green Lane', 'Shelbyville', '45673', '+1555999000', 14, 46000.75, 96000.00, 14, '2020-06-15'),
(15, 'ReNew Solutions', '1500 Clean Ave', 'Capital City', '56784', '+1555000111', 15, 49000.25, 98000.00, 15, '2021-07-20');
select * from RecycleCenters
 

INSERT INTO PickupRequests (
RequestID, CitizenID, AdminID, CollectorID,
RequestDate, ApprovalStatus, TotalWeight,
Pickup_Street, Pickup_City, Pickup_ZipCode, PickupStatus
)
VALUES
(1, 1, 1, 1, '2023-05-01', 'Approved', 12.50, '123 Main St', 'Springfield', '12345', 'Collected'),
(2, 2, 2, 2, '2023-05-02', 'Approved', 8.75, '456 Oak Ave', 'Shelbyville', '23456', 'Scheduled'),
(3, 3, 3, 3, '2023-05-03', 'Pending', 15.00, '789 Pine Rd', 'Capital City', '34567', 'Scheduled'),
(4, 4, 4, 4, '2023-05-04', 'Rejected', 5.50, '101 Elm Blvd', 'Ogdenville', '45678', 'Missed'),
(5, 5, 5, 5, '2023-05-05', 'Approved', 20.25, '202 Maple Dr', 'North Haverbrook', '56789', 'Collected'),
(6, 6, 6, 6, '2023-05-06', 'Approved', 10.75, '303 Cedar Ln', 'Brockway', '67890', 'Scheduled'),
(7, 7, 7, 7, '2023-05-07', 'Pending', 18.50, '404 Birch St', 'Springfield', '78901', 'Scheduled'),
(8, 8, 8, 8, '2023-05-08', 'Approved', 7.25, '505 Spruce Ave', 'Shelbyville', '89012', 'Collected'),
(9, 9, 9, 9, '2023-05-09', 'Rejected', 9.00, '606 Willow Rd', 'Capital City', '90123', 'Missed'),
(10, 10, 10, 10, '2023-05-10', 'Approved', 14.75, '707 Aspen Blvd', 'Ogdenville', '01234', 'Collected'),
(11, 11, 11, 11, '2023-05-11', 'Approved', 11.50, '808 Redwood Dr', 'North Haverbrook', '12340', 'Scheduled'),
(12, 12, 12, 12, '2023-05-12', 'Pending', 16.25, '909 Sequoia Ln', 'Brockway', '23451', 'Scheduled'),
(13, 13, 13, 13, '2023-05-13', 'Approved', 6.75, '111 Fir St', 'Springfield', '34562', 'Collected'),
(14, 14, 14, 14, '2023-05-14', 'Rejected', 13.00, '222 Juniper Ave', 'Shelbyville', '45673', 'Missed'),
(15, 15, 15, 15, '2023-05-15', 'Approved', 17.50, '333 Magnolia Rd', 'Capital City', '56784', 'Collected');
select * from PickupRequests
 
INSERT INTO Inventory_ItemTypes (InventoryID, ItemType)
VALUES
-- Inventory 1
(1, 'Plastic'), (1, 'Paper'), (1, 'Glass'), (1, 'Metal'),
-- Inventory 2
(2, 'Plastic'), (2, 'Paper'), (2, 'Electronics'),
-- Inventory 3
(3, 'Organic'), (3, 'Wood'), (3, 'Rubber'),
-- Inventory 4
(4, 'Hazardous'), (4, 'Construction Debris'), (4, 'E-Waste'),
-- Inventory 5
(5, 'Plastic'), (5, 'Glass'), (5, 'Metal'),
-- Inventory 6
(6, 'Textiles'), (6, 'Paper'), (6, 'Plastic'),
-- Inventory 7
(7, 'Metal'), (7, 'Glass'), (7, 'Plastic'),
-- Inventory 8
(8, 'Organic'), (8, 'Paper'), (8, 'Wood'),
-- Inventory 9
(9, 'Plastic'), (9, 'Metal'), (9, 'Rubber'),
-- Inventory 10
(10, 'Glass'), (10, 'Paper'), (10, 'Textiles'),
-- Inventory 11
(11, 'Plastic'), (11, 'Metal'), (11, 'Electronics'),
-- Inventory 12
(12, 'Organic'), (12, 'Wood'), (12, 'Paper'),
-- Inventory 13
(13, 'Plastic'), (13, 'Glass'), (13, 'Metal'),
-- Inventory 14
(14, 'Textiles'), (14, 'Paper'), (14, 'Plastic'),
-- Inventory 15
(15, 'Metal'), (15, 'Glass'), (15, 'Plastic');
select* from Inventory_ItemTypes
 

INSERT INTO Inventory_StockLevels (InventoryID, ItemType, Quantity)
VALUES
-- Inventory 1
(1, 'Plastic', 20000.00), (1, 'Paper', 15000.00), (1, 'Glass', 10000.00), (1, 'Metal', 5000.50),
-- Inventory 2
(2, 'Plastic', 18000.00), (2, 'Paper', 12000.75), (2, 'Electronics', 15000.00),
-- Inventory 3
(3, 'Organic', 25000.00), (3, 'Wood', 20000.25), (3, 'Rubber', 15000.00),
-- Inventory 4
(4, 'Hazardous', 10000.00), (4, 'Construction Debris', 15000.00), (4, 'E-Waste', 10000.00),
-- Inventory 5
(5, 'Plastic', 15000.00), (5, 'Glass', 12000.50), (5, 'Metal', 13000.00),
-- Inventory 6
(6, 'Textiles', 18000.00), (6, 'Paper', 22000.75), (6, 'Plastic', 15000.00),
-- Inventory 7
(7, 'Metal', 20000.00), (7, 'Glass', 15000.25), (7, 'Plastic', 13000.00),
-- Inventory 8
(8, 'Organic', 22000.00), (8, 'Paper', 18000.00), (8, 'Wood', 12000.00),
-- Inventory 9
(9, 'Plastic', 17000.00), (9, 'Metal', 15000.50), (9, 'Rubber', 15000.00),
-- Inventory 10
(10, 'Glass', 16000.00), (10, 'Paper', 14000.75), (10, 'Textiles', 13000.00),
-- Inventory 11
(11, 'Plastic', 19000.00), (11, 'Metal', 17000.00), (11, 'Electronics', 15000.25),
-- Inventory 12
(12, 'Organic', 15000.00), (12, 'Wood', 12000.00), (12, 'Paper', 12000.00),
-- Inventory 13
(13, 'Plastic', 21000.00), (13, 'Glass', 18000.50), (13, 'Metal', 15000.00),
-- Inventory 14
(14, 'Textiles', 16000.00), (14, 'Paper', 15000.75), (14, 'Plastic', 15000.00),
-- Inventory 15
(15, 'Metal', 18000.00), (15, 'Glass', 16000.00), (15, 'Plastic', 15000.00);
select* from Inventory_StockLevels
 

INSERT INTO CollectorAssignedRequests (CollectorID, RequestID)
VALUES
(1, 1), (1, 2),  
(2, 3), (2, 4),  
(3, 5),        
(4, 6), (4, 7),  
(5, 8),          
(6, 9), (6, 10),
(7, 11),         
(8, 12), (8, 13),
(9, 14),         
(10, 15),         
(11, 1),          
(12, 3),         
(13, 5), (13, 7),
(14, 9), (14, 11),
(15, 13);        
select*from CollectorAssignedRequests
 

INSERT INTO AdminManagedZones (AdminID, ZoneName)
VALUES
(1, 'Downtown Core'),
(1, 'Financial District'),
(2, 'Northside Residential'),
(3, 'East River Zone'),
(4, 'West End Commercial'),
(5, 'Southside Industrial'),
(6, 'Central Park Area'),
(7, 'Riverside Communities'),
(8, 'Hillside Estates'),
(9, 'Uptown District'),
(10, 'Midtown Arts Quarter'),
(11, 'Lakeview Neighborhood'),
(12, 'Green Valley'),
(12, 'Green Valley West'),
(13, 'Sunset Boulevard'),
(14, 'Oceanfront Properties'),
(15, 'Mountain Ridge'),
(15, 'Mountain Ridge East'),
(15, 'Mountain Ridge West'),
(9, 'Uptown Historical District');
select*from AdminManagedZones
 

INSERT INTO PickupRequest_WasteItems (RequestID, WasteItem)
VALUES
(1, 'Plastic Bottles'),
(1, 'Cardboard Boxes'),
(1, 'Aluminum Cans'),
(2, 'Old Computers'),
(2, 'Broken Monitors'),
(3, 'Furniture'),
(3, 'Mattress'),
(4, 'Wood Planks'),
(4, 'Drywall'),
(5, 'Yard Trimmings'),
(5, 'Food Waste'),
(6, 'Paint Cans'),
(6, 'Batteries'),
(7, 'Glass Bottles'),
(7, 'Plastic Containers'),
(8, 'Refrigerator'),
(8, 'Washing Machine'),
(9, 'Old Clothing'),
(9, 'Bedding'),
(10, 'Plastic Bags'),
(10, 'Paper Products'),
(11, 'Printers'),
(11, 'Cell Phones'),
(12, 'Tree Branches'),
(12, 'Grass Clippings'),
(13, 'Concrete Blocks'),
(13, 'Bricks'),
(14, 'Cleaning Chemicals'),
(14, 'Pesticides'),
(15, 'Newspapers'),
(15, 'Magazines');
select* from PickupRequest_WasteItems
 

INSERT INTO RecycleCenter_WasteCategories (CenterID, WasteCategory)
VALUES
(1, 'Plastic'),
(1, 'Paper'),
(1, 'Glass'),
(1, 'Metal'),
(2, 'Electronics'),
(2, 'Batteries'),
(2, 'Light Bulbs'),
(3, 'Organic Waste'),
(3, 'Compost'),
(3, 'Yard Waste'),
(4, 'Wood'),
(4, 'Concrete'),
(4, 'Drywall'),
(5, 'Chemicals'),
(5, 'Paint'),
(5, 'Medical Waste'),
(6, 'Clothing'),
(6, 'Fabric'),
(6, 'Shoes'),
(7, 'Aluminum'),
(7, 'Copper'),
(7, 'Steel'),
(8, 'PET Plastic'),
(8, 'HDPE Plastic'),
(8, 'PVC Plastic'),
(9, 'Clear Glass'),
(9, 'Brown Glass'),
(9, 'Green Glass'),
(10, 'Cardboard'),
(10, 'Newspaper'),
(10, 'Office Paper'),
(11, 'Plastic'),
(11, 'Metal'),
(11, 'Glass'),

(12, 'Furniture'),
(12, 'Appliances'),
(12, 'Mattresses'),
(13, 'Motor Oil'),
(13, 'Tires'),
(13, 'Car Batteries'),
(14, 'Plastic Bags'),
(14, 'Plastic Film'),
(14, 'Bubble Wrap'),
(15, 'Plastic'),
(15, 'Paper'),
(15, 'Glass'),
(15, 'Metal'),
(15, 'Electronics');
select*from RecycleCenter_WasteCategories
INSERT INTO Recycler_RecycledItemsLog (RecyclerID, Item)
VALUES
(1, 'PET Bottles'),
(1, 'HDPE Containers'),
(2, 'Computer Motherboards'),
(2, 'LCD Screens'),
(3, 'Food Waste'),
(3, 'Yard Trimmings'),
(4, 'Aluminum Cans'),
(4, 'Copper Wiring'),
(5, 'Clear Glass Bottles'),
(5, 'Brown Glass Jars'),
(6, 'Cardboard Boxes'),
(6, 'Office Paper'),

(7, 'Cotton Clothing'),
(7, 'Polyester Fabric'),
(8, 'Lead-Acid Batteries'),
(8, 'Fluorescent Tubes'),
(9, 'Concrete Rubble'),
(9, 'Wood Planks'),
(10, 'Mixed Plastics'),
(10, 'Aluminum Foil'),
(11, 'Plastic Bags'),
(11, 'Bubble Wrap'),
(12, 'Smartphones'),
(12, 'Tablets'),
(13, 'Motor Oil'),
(13, 'Tires'),
(14, 'Waxed Cardboard'),
(14, 'Thermal Receipts'),
(15, 'Mixed Recycling'),
(15, 'E-Waste');
select* from Recycler_RecycledItemsLog

 

INSERT INTO Recyclers (
RecyclerID, CenterID, FirstName, LastName, Email,
Phone, Specialization, Shift
)
VALUES
-- Center 1 (General Recycling)
(1, 1, 'James', 'Wilson', 'james.wilson@recycle1.com', '+15551112222', 'Plastic Sorting', 'Morning (6AM-2PM)'),
(2, 1, 'Sarah', 'Johnson', 'sarah.johnson@recycle1.com', '+15552223333', 'Glass Processing', 'Afternoon (2PM-10PM)'),

-- Center 2 (E-Waste)
(3, 2, 'Michael', 'Brown', 'michael.brown@ewaste.com', '+15553334444', 'Electronics Dismantling', 'Morning (7AM-3PM)'),
(4, 2, 'Emily', 'Davis', 'emily.davis@ewaste.com', '+15554445555', 'Battery Recycling', 'Evening (3PM-11PM)'),

-- Center 3 (Organic)
(5, 3, 'David', 'Miller', 'david.miller@organic.com', '+15555556666', 'Composting', 'Day (8AM-4PM)'),
(6, 3, 'Jessica', 'Taylor', 'jessica.taylor@organic.com', '+15556667777', 'Biowaste Processing', 'Swing (12PM-8PM)'),

-- Center 4 (Construction)
(7, 4, 'Robert', 'Anderson', 'robert.anderson@constr.com', '+15557778888', 'Wood Recycling', 'Morning (6AM-2PM)'),
(8, 4, 'Amanda', 'Thomas', 'amanda.thomas@constr.com', '+15558889999', 'Concrete Crushing', 'Afternoon (2PM-10PM)'),

-- Center 5 (Hazardous)
(9, 5, 'Daniel', 'Jackson', 'daniel.jackson@hazard.com', '+15559990000', 'Chemical Neutralization', 'Day (9AM-5PM)'),
(10, 5, 'Jennifer', 'White', 'jennifer.white@hazard.com', '+15550001111', 'Paint Processing', 'Evening (4PM-12AM)'),

-- Center 6 (Textile)
(11, 6, 'Christopher', 'Harris', 'christopher.harris@textile.com', '+15551112222', 'Fabric Sorting', 'Morning (7AM-3PM)'),
(12, 6, 'Elizabeth', 'Martin', 'elizabeth.martin@textile.com', '+15552223333', 'Clothing Repair', 'Afternoon (3PM-11PM)'),

-- Center 7 (Metal)
(13, 7, 'Matthew', 'Garcia', 'matthew.garcia@metal.com', '+15553334444', 'Aluminum Smelting', 'Night (10PM-6AM)'),
(14, 7, 'Ashley', 'Martinez', 'ashley.martinez@metal.com', '+15554445555', 'Copper Extraction', 'Day (8AM-4PM)'),

-- Center 8 (Plastic Specialty)
(15, 8, 'Andrew', 'Robinson', 'andrew.robinson@plastic.com', '+15555556666', 'PET Processing', 'Swing (12PM-8PM)');
select*from Recyclers

 

INSERT INTO Reports (
ReportID, AdminID, GeneratedDate, TimePeriodCovered,
TotalPickups, TotalRecycled, IssuesFound,
WasteTypeBreakdown, ReviewedBy,
LocationStats_Latitude, LocationStats_Longitude
)
VALUES
-- Monthly Reports (Admin 31-35)
(1, 1, '2023-06-30', 'June 2023', 450, 320,
'Increased plastic contamination in recycling stream',
'Plastic: 42%, Paper: 28%, Glass: 18%, Metal: 12%',
'John Smith', 34.052235, -118.243683),

(2, 2, '2023-06-30', 'June 2023', 380, 275,
'Vehicle maintenance delays in Northside',
'Plastic: 38%, Paper: 31%, Glass: 15%, Metal: 16%',
'Jane Doe', 34.052236, -118.243684),

(3, 3, '2023-06-30', 'June 2023', 520, 410,
'High e-waste volume requires additional processing',
'Electronics: 22%, Plastic: 35%, Other: 43%',
'Robert Brown', 34.052237, -118.243685),

(4, 4, '2023-06-30', 'June 2023', 290, 190,
'Low participation in Ogdenville recycling program',
'Plastic: 45%, Paper: 30%, Glass: 15%, Metal: 10%',
'Emily Davis', 34.052238, -118.243686),

(5, 5, '2023-06-30', 'June 2023', 410, 350,
'Successful hazardous waste collection event',
'Hazardous: 18%, Plastic: 32%, Paper: 25%, Other: 25%',
'Michael Wilson', 34.052239, -118.243687),

-- Quarterly Reports (Admin 36-40)
(6, 6, '2023-06-30', 'Q2 2023', 1250, 950,
'Need more cardboard compactors in downtown area',
'Cardboard: 28%, Plastic: 30%, Glass: 20%, Other: 22%',
'Sarah Taylor', 34.052240, -118.243688),

(7, 7, '2023-06-30', 'Q2 2023', 1420, 1100,
'Increased glass recycling after new bins installed',
'Glass: 25%, Plastic: 35%, Paper: 25%, Metal: 15%',
'David Anderson', 34.052241, -118.243689),

(8, 8, '2023-06-30', 'Q2 2023', 980, 720,
'Staff shortages affecting collection times',
'Plastic: 40%, Paper: 30%, Glass: 15%, Other: 15%',
'Jessica Thomas', 34.052242, -118.243690),

(9, 9, '2023-06-30', 'Q2 2023', 1100, 850,
'New recycling education program showing results',
'Plastic: 38%, Paper: 28%, Glass: 22%, Metal: 12%',
'Daniel Jackson', 34.052243, -118.243691),

(10, 10, '2023-06-30', 'Q2 2023', 1350, 1050,
'Improved sorting at material recovery facility',
'Plastic: 33%, Paper: 30%, Glass: 20%, Metal: 17%',
'Lisa White', 34.052244, -118.243692),

-- Special Reports (Admin 41-45)
(11, 11, '2023-06-15', 'E-Waste Initiative', 180, 150,
'Successful pilot program for small electronics',
'Electronics: 65%, Plastic: 20%, Other: 15%',
'Matthew Harris', 34.052245, -118.243693),

(12, 12, '2023-06-20', 'Organic Waste Audit', 320, 280,
'Contamination from plastic bags in compost',
'Food Waste: 60%, Yard Waste: 35%, Contaminants: 5%',
'Amanda Martin', 34.052246, -118.243694),

(13, 13, '2023-06-25', 'Hazardous Materials', 95, 80,
'Need better household hazardous waste education',
'Paint: 40%, Chemicals: 30%, Batteries: 20%, Other: 10%',
'Christopher Garcia', 34.052247, -118.243695),

(14, 14, '2023-06-10', 'Textile Recycling', 210, 175,
'Growing demand for clothing recycling bins',
'Clothing: 70%, Shoes: 15%, Other Textiles: 15%',
'Ashley Lee', 34.052248, -118.243696),

(15, 15, '2023-06-05', 'Construction Recycling', 150, 120,
'Challenges with mixed construction materials',
'Wood: 40%, Drywall: 30%, Concrete: 20%, Other: 10%',
'James Clark', 34.052249, -118.243697);
select*from Reports

 

INSERT INTO Report_TopCollectors (ReportID, CollectorID)
VALUES
-- Monthly Reports (ReportID 1-5)
(1, 1),  -- Top collector for June 2023 report (Springfield)
(1, 2),  -- Second best collector
(2, 3),  -- Top collector for Northside June report
(2, 4),
(3, 5),  -- E-waste collection leader
(3, 6),
(4, 7),  -- Ogdenville top performer
(5, 8),  -- Hazardous waste collection star

-- Quarterly Reports (ReportID 6-10)
(6, 9),   -- Q2 top cardboard collector
(6, 10),
(7, 11),  -- Glass recycling champion
(7, 12),
(8, 13),  -- High-volume collector
(9, 14),  -- Education program standout
(10, 15), -- Most improved collector

-- Special Reports (ReportID 11-15)
(11, 1),  -- E-waste initiative leader
(12, 3),  -- Organic waste top collector
(13, 5),  -- Hazardous materials specialist
(14, 7),  -- Textile recycling star
(15, 9);  -- Construction waste leader
select * from Report_TopCollectors
INSERT INTO Collector_Deliveries (CollectorID, CenterID, DeliveryDate)
VALUES
-- Week 1 Deliveries (Collectors 1-5)
(1, 1, '2023-06-05'),  -- Collector 1 to General Recycling Center
(2, 2, '2023-06-06'),  -- Collector 2 to E-Waste Center
(3, 3, '2023-06-07'),  -- Collector 3 to Organic Center
(4, 4, '2023-06-08'),  -- Collector 4 to Construction Center
(5, 5, '2023-06-09'),  -- Collector 5 to Hazardous Center

-- Week 2 Deliveries (Collectors 6-10)
(6, 6, '2023-06-12'), -- Collector 6 to Textile Center
(7, 7, '2023-06-13'), -- Collector 7 to Metal Center
(8, 8, '2023-06-14'), -- Collector 8 to Plastic Center
(9, 1, '2023-06-15'), -- Collector 9 to General Recycling (mixed load)
(10, 2, '2023-06-16'), -- Collector 10 to E-Waste Center

-- Week 3 Deliveries (Collectors 11-15)
(11, 3, '2023-06-19'), -- Collector 11 to Organic Center
(12, 4, '2023-06-20'), -- Collector 12 to Construction Center
(13, 5, '2023-06-21'), -- Collector 13 to Hazardous Center
(14, 6, '2023-06-22'), -- Collector 14 to Textile Center
(15, 7, '2023-06-23'); -- Collector 15 to Metal Center
select*from Collector_Deliveries

ALTER TABLE Users
ADD LastLogin DATETIME;
ALTER TABLE Users
ADD AccountStatus VARCHAR(20) DEFAULT 'Active';
select*from Users
ALTER TABLE Citizens
DROP COLUMN PreferredPickupTime;
select*from Citizens
ALTER TABLE PickupRequests
MODIFY TotalWeight DECIMAL(10,3);

ALTER TABLE PickupRequests
DROP COLUMN Pickup_ZipCode;

select*from PickupRequests
ALTER TABLE Collectors
ADD SafetyTrainingDate DATE
select*from Collectors
ALTER TABLE RecycleCenters
ADD OperatingHours VARCHAR(50) DEFAULT '8AM-5PM'
select*from RecycleCenters
ALTER TABLE Inventory
DROP COLUMN InventoryManagerID
select*from Inventory

ALTER TABLE Admins
DROP COLUMN LastLoginDate
ALTER TABLE Admins
DROP COLUMN WorkShift
select*from Admins
ALTER TABLE Vehicles
DROP COLUMN FuelType
select*from Vehicles
ALTER TABLE RecycleCenters
DROP COLUMN EstablishedDate
select*from RecycleCenters
ALTER TABLE Citizens
DROP COLUMN Location_Latitude
select*from Citizens

UPDATE Collectors
SET CurrentVehicleID = 7,
    AreaAssigned = 'Downtown Core'
WHERE CollectorID = 4;

DELETE FROM Collectors
WHERE ActiveStatus = 0;

select *from Collectors
UPDATE PickupRequests
SET PickupStatus = 'Collected',
ApprovalStatus = 'Approved'
WHERE RequestID IN (5, 8, 12)
AND PickupStatus = 'Scheduled'
select * from PickupRequests
UPDATE Vehicles
SET Status = 'Maintenance'
WHERE VehicleID = 4
select *from Vehicles

SELECT RequestID, Pickup_City, PickupStatus
FROM PickupRequests
WHERE ApprovalStatus = 'Pending'

SELECT FirstName, LastName
FROM Users
SELECT ItemType, Quantity
FROM Inventory_StockLevels
WHERE Quantity < 50
UPDATE Collectors
SET TotalCollections = TotalCollections + 1
WHERE CollectorID = 7
select * from Collectors


SELECT * FROM Collectors
WHERE TotalCollections > 100
SELECT * FROM Vehicles
WHERE Capacity < 3000
SELECT * FROM Citizens
WHERE NumberOfRequestsMade = 5
SELECT * FROM PickupRequests
WHERE TotalWeight != 10.00
SELECT * FROM Collectors
WHERE ActiveStatus = 1 AND AreaAssigned = 'Northside'
SELECT * FROM PickupRequests
WHERE Pickup_City = 'Springfield' OR Pickup_City = 'Shelbyville'
SELECT * FROM Users
WHERE UserType = 'citizen' AND Address_City != 'Capital City'
SELECT * FROM Users
WHERE Email LIKE '%@gmail.com'
SELECT * FROM RecycleCenters
WHERE CenterName LIKE 'Green%'
SELECT * FROM UserPhoneNumbers
WHERE PhoneNumber LIKE '%555%'
SELECT * FROM PickupRequests
WHERE Pickup_City IN ('Springfield', 'Shelbyville', 'Capital City')
SELECT * FROM PickupRequests
WHERE RequestDate BETWEEN '2023-06-01' AND '2023-06-30'
SELECT * FROM PickupRequests
WHERE TotalWeight > 15 AND Pickup_City = 'Springfield'
SELECT * FROM PickupRequests
WHERE PickupStatus = 'Scheduled' AND ApprovalStatus = 'Approved'

drop table Collector_Deliveries
drop table Report_TopCollectors
drop table Reports
drop table UserPhoneNumbers
drop table CitizenFeedbacks
