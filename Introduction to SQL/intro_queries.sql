-- Return all titles from the books table
SELECT title
FROM books;

-- Select title and author from the books table
SELECT title, author
FROM books;

-- Select all fields from the books table
SELECT *
FROM books;

-- Select unique authors from the books table
SELECT DISTINCT author
FROM books;

-- Select unique authors and genre combinations from the books table
SELECT DISTINCT author, genre
FROM books;

-- Alias author so that it becomes unique_author
SELECT DISTINCT author as unique_author
FROM books;

-- Create a view called library_authors
CREATE VIEW library_authors AS
SELECT DISTINCT author AS unique_author
FROM books;

-- Select all columns from library_authors
SELECT *
FROM library_authors;

-- Select the first 10 genres from books using PostgreSQL
SELECT genre
FROM books
LIMIT 10;
