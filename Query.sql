--Drop Tables If  Exist To stop Issues in  TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- User Table Creating

CREATE TABLE Users(
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50) CHECK(role IN('Ticket Manager', 'Football Fan')),
    phone_number VARCHAR(20)
);

-- Matches Table Creating

CREATE TABLE Matches(
    match_id INT PRIMARY KEY,
    fixture VARCHAR(255) NOT NULL,
    tournament_category VARCHAR(100) NOT NULL,
    base_ticket_price NUMERIC(10, 2) CHECK(base_ticket_price >= 0),
    match_status VARCHAR(50) CHECK(match_status IN('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);

-- Bookings Table Creating

CREATE TABLE Bookings(
    booking_id INT PRIMARY KEY,
    user_id INT,
    match_id INT,
    seat_number VARCHAR(20),
    payment_status VARCHAR(50) CHECK(payment_status IN('Pending', 'Confirmed', 'Cancelled', 'Refunded')),
    total_cost NUMERIC(10, 2) CHECK(total_cost >= 0),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id)
);

-- Inserting  Users Data in Users Table

INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- Inserting  Matches Data in Matches Table

INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- Inserting  Bookings Data in Bookings Table

INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);


--Query No: 1

SELECT 
    match_id,
    fixture,
    base_ticket_price
FROM
    Matches
WHERE
    tournament_category = 'Champions League' AND
    match_status = 'Available';



--Query No: 2

SELECT 
    user_id, 
    full_name, 
    email
FROM 
    Users
WHERE 
    full_name ILIKE 'Tanvir%' 
    OR full_name ILIKE '%Haque%';


--Query NO: 3

SELECT 
    booking_id, 
    user_id, 
    match_id, 
    COALESCE(payment_status, 'Action Required') AS systematic_status
FROM 
    Bookings
WHERE 
    payment_status IS NULL;    


--Query No:4

SELECT 
    b.booking_id, 
    u.full_name, 
    m.fixture, 
    b.total_cost
FROM 
    Bookings b
INNER JOIN 
    Users u ON b.user_id = u.user_id
INNER JOIN 
    Matches m ON b.match_id = m.match_id;




--Query No: 5

SELECT 
    u.user_id, 
    u.full_name, 
    b.booking_id
FROM 
    Users u
LEFT JOIN 
    Bookings b ON u.user_id = b.user_id;




--Query No: 6

SELECT 
    booking_id, 
    match_id, 
    total_cost
FROM 
    Bookings
WHERE 
    total_cost > (SELECT AVG(total_cost) FROM Bookings);




--Query No: 7

SELECT 
    match_id, 
    fixture, 
    base_ticket_price
FROM 
    Matches
ORDER BY 
    base_ticket_price DESC
LIMIT 2 OFFSET 1;    