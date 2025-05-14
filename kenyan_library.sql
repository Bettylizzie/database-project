
-- I'm first creating the database and selecting it

CREATE DATABASE kenyan_library;
USE kenyan_library;

-- Stores information about local authors

CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    county_of_origin VARCHAR(50) COMMENT 'Stores Kenyan county',
    biography TEXT,
    CONSTRAINT uk_author_name UNIQUE (first_name, last_name)
) COMMENT 'Table for Kenyan authors information';


-- Classification system for Kenyan libraries

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) COMMENT 'Book classification categories';



-- Main inventory with Kenyan publication detail
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE COMMENT 'International Standard Book Number',
    title VARCHAR(255) NOT NULL,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    publisher VARCHAR(100),
    year_published INT,
    edition VARCHAR(20),
    language VARCHAR(30) DEFAULT 'English',
    pages INT,
    price DECIMAL(10,2) COMMENT 'Price in Kenyan Shillings',
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT chk_year CHECK (year_published > 1900)
) COMMENT 'Main books inventory table';


-- Kenyan library locations

CREATE TABLE branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    county VARCHAR(50) NOT NULL COMMENT 'Kenyan county location',
    town VARCHAR(50) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(15) COMMENT 'Kenyan phone format',
    email VARCHAR(100),
    opening_hours VARCHAR(100)
) COMMENT 'Library branches across Kenya';


-- Tracks physical copies in each branch

CREATE TABLE book_copies (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    branch_id INT NOT NULL,
    shelf_location VARCHAR(20),
    status ENUM('available', 'checked_out', 'lost', 'damaged') DEFAULT 'available',
    date_added DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
) COMMENT 'Tracks physical copies in branches';

-- Library members with Kenyan ID validation
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    national_id VARCHAR(12) UNIQUE COMMENT 'Kenyan National ID format',
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) NOT NULL COMMENT 'Kenyan phone number',
    county VARCHAR(50),
    registration_date DATE DEFAULT (CURRENT_DATE),
    membership_expiry DATE,
    status ENUM('active', 'expired', 'suspended') DEFAULT 'active'
) COMMENT 'Library members information';

-- Tracks book borrowing transactions
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(10,2) DEFAULT 0.00 COMMENT 'Fines in KES',
    status ENUM('active', 'returned', 'overdue') DEFAULT 'active',
    FOREIGN KEY (copy_id) REFERENCES book_copies(copy_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT chk_due_date CHECK (due_date > loan_date)
) COMMENT 'Book loan transactions';

-- Local publishing houses
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    county VARCHAR(50) COMMENT 'Based in which Kenyan county',
    year_established INT,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(15)
) COMMENT 'Kenyan publishing houses';

-- Adding publisher reference to books table
ALTER TABLE books
ADD CONSTRAINT fk_publisher
FOREIGN KEY (publisher) REFERENCES publishers(name);loans

-- Shows books currently in stock

CREATE VIEW available_books AS
SELECT b.title, a.first_name, a.last_name, bc.shelf_location, br.branch_name
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN book_copies bc ON b.book_id = bc.book_id
JOIN branches br ON bc.branch_id = br.branch_id
WHERE bc.status = 'available';

-- INDEXES for performance optimization

CREATE INDEX idx_book_title ON books(title);
CREATE INDEX idx_author_name ON authors(last_name, first_name);
CREATE INDEX idx_member_name ON members(last_name, first_name);

select * from loans;