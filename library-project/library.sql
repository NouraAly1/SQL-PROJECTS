/* =========================================================
   Library Management System - SQL Script
   Tables: Books, Members, Loans
   Loans connects Members and Books (who borrowed what, when)
   ========================================================= */

-- SQLite has foreign keys switched off by default.
-- This line turns them on so the links between tables are enforced.
PRAGMA foreign_keys = ON;

-- Remove old copies of the tables so the script can be run again cleanly.
-- Loans goes first because it depends on the other two tables.
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Members;

-- Books table: stores one row for each book title in the library.
CREATE TABLE Books (
    ISBN      VARCHAR(13)  PRIMARY KEY,   -- unique book number; text because ISBNs can have leading zeros or an X
    Title     VARCHAR(200) NOT NULL,      -- every book must have a title
    Author    VARCHAR(100) NOT NULL,      -- author's name
    Genre     VARCHAR(50),                -- e.g. Fiction, Science; can be left empty
    Quantity  INT NOT NULL CHECK (Quantity >= 0)  -- copies on the shelf; can't go below zero
);

-- Members table: stores one row for each library member.
CREATE TABLE Members (
    MemberID  INT PRIMARY KEY,            -- unique number for each member
    Name      VARCHAR(100) NOT NULL,      -- member's full name
    Email     VARCHAR(100) NOT NULL UNIQUE,  -- no two members can share an email
    Phone     VARCHAR(20)                 -- text, not a number, because phones can start with 0 or +
);

-- Loans table: records each time a member borrows a book.
CREATE TABLE Loans (
    LoanID     INT PRIMARY KEY,           -- unique number for each loan
    MemberID   INT NOT NULL,              -- who borrowed the book
    ISBN       VARCHAR(13) NOT NULL,      -- which book was borrowed
    LoanDate   DATE NOT NULL,             -- the day it was borrowed
    ReturnDate DATE,                      -- empty (NULL) until the book comes back
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),  -- must be a real member
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN),            -- must be a real book
    CHECK (ReturnDate IS NULL OR ReturnDate >= LoanDate)  -- can't return before borrowing
);

-- Check that all three tables were created.
SELECT name FROM sqlite_master WHERE type = 'table';

/* =========================================================
   INSERT: add sample records to each table
   Parent tables (Books, Members) are filled first,
   because Loans can only point to rows that already exist.
   ========================================================= */

-- Add five books. Column names are listed so each value
-- clearly goes into the right column.
INSERT INTO Books (ISBN, Title, Author, Genre, Quantity) VALUES
('9780061120084', 'To Kill a Mockingbird',   'Harper Lee',          'Fiction',     4),
('9780451524935', '1984',                    'George Orwell',       'Dystopian',   3),
('9780743273565', 'The Great Gatsby',        'F. Scott Fitzgerald', 'Classic',     2),
('9780134685991', 'Effective Java',          'Joshua Bloch',        'Programming', 5),
('9780553380163', 'A Brief History of Time', 'Stephen Hawking',     'Science',     1);

-- Add four library members.
INSERT INTO Members (MemberID, Name, Email, Phone) VALUES
(101, 'Sara Ahmed',  'sara.ahmed@email.com',  '555-0101'),
(102, 'John Miller', 'john.miller@email.com', '555-0102'),
(103, 'Maria Lopez', 'maria.lopez@email.com', '555-0103'),
(104, 'Omar Khalid', 'omar.khalid@email.com', '555-0104');

-- Add five loans. Dates use the YYYY-MM-DD format.
-- A NULL ReturnDate means the book hasn't come back yet.
INSERT INTO Loans (LoanID, MemberID, ISBN, LoanDate, ReturnDate) VALUES
(1, 101, '9780061120084', '2026-09-01', '2026-09-15'),  -- Sara returned this one
(2, 101, '9780134685991', '2026-09-10', NULL),          -- Sara still has this one
(3, 102, '9780451524935', '2026-09-05', '2026-09-20'),
(4, 103, '9780743273565', '2026-09-12', NULL),
(5, 104, '9780553380163', '2026-09-18', NULL);

-- Show all records in each table (for the screenshots).
SELECT * FROM Books;
SELECT * FROM Members;
SELECT * FROM Loans;

/* =========================================================
   RETRIEVE: all books borrowed by a specific member
   Joins Loans with Books (to get the book details)
   and Members (to show who borrowed them).
   ========================================================= */

-- Show every book Sara Ahmed (MemberID 101) has borrowed,
-- with the full book details and the loan dates.
SELECT Members.Name,
       Books.ISBN, Books.Title, Books.Author, Books.Genre, Books.Quantity,
       Loans.LoanDate, Loans.ReturnDate
FROM Loans
JOIN Books   ON Loans.ISBN = Books.ISBN              -- match each loan to its book
JOIN Members ON Loans.MemberID = Members.MemberID    -- match each loan to its member
WHERE Loans.MemberID = 101;   

/* =========================================================
   UPDATE: change the quantity of a particular book
   ========================================================= */

-- The library bought 2 more copies of "A Brief History of Time",
-- so its quantity goes from 1 to 3.
-- WHERE picks the book by its ISBN (the primary key), so only
-- this one row changes. Without WHERE, every book would get 3.
UPDATE Books
SET Quantity = 3
WHERE ISBN = '9780553380163';

-- Show all books again to confirm the change.
SELECT * FROM Books; 

/* =========================================================
   DELETE: remove a member from the Members table
    ========================================================= */

-- Step 1: remove Omar Khalid's (MemberID 104) loan records first.
-- The foreign key blocks deleting a member who still has loans,
-- because the loan would point to a member who no longer exists.
DELETE FROM Loans
WHERE MemberID = 104;

-- Step 2: now the member can be deleted safely.
-- WHERE targets only MemberID 104; without it, every member would be deleted.
DELETE FROM Members
WHERE MemberID = 104;

-- Show all remaining members and loans to confirm the delete.
SELECT * FROM Members;
SELECT * FROM Loans;