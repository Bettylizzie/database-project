## Library Management System - MySQL Database
## README.md
## Project Title
## Kenyan Library Management System Database

# Description
I created a complete database system for managing libraries in Kenya. This database tracks books, Kenyan authors, library branches, and member transactions with proper constraints and relationships.

# Features
Stores Kenyan author information

Tracks book inventory across multiple library branches

Manages member registrations with Kenyan ID validation

Records book loans and returns

## ER Diagram

https://github.com/user-attachments/assets/6827c927-c661-4f5c-bb0d-4313e00cd866


## How to Setup
Create a new MySQL database
Run the SQL script

## Key Kenyan-Specific Features
National ID Tracking: Members table validates Kenyan ID numbers

County Fields: All addresses include Kenyan counties

Local Publishers: Separate table for Kenyan publishing houses

KES Currency: All prices in Kenyan Shillings

Phone Validation: Proper format for Kenyan phone numbers

## Relationships Explained
One-to-Many:

One author → Many books

One branch → Many book copies

Many-to-Many (implemented through junction tables):

Books to Branches (via book_copies)

Members to Books (via loans)

## Constraints:

Proper foreign keys

Unique constraints on ISBN, member IDs

Data validation checks

This database is ready for implementation in any Kenyan library system with proper localization.
