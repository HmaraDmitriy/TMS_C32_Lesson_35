
CREATE DATABASE library_management;
\c library_management;
CREATE TABLE users (
                       id SERIAL PRIMARY KEY,
                       login VARCHAR(50) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE logs (
                      id SERIAL PRIMARY KEY,
                      action VARCHAR(50),
                      user_id INT,
                      timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE books (
                       id SERIAL PRIMARY KEY,
                       title VARCHAR(255) NOT NULL,
                       author VARCHAR(255) NOT NULL,
                       published_year INT
);

CREATE TABLE readers (
                         id SERIAL PRIMARY KEY,
                         name VARCHAR(100) NOT NULL,
                         email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE reservations (
                              id SERIAL PRIMARY KEY,
                              book_id INT NOT NULL,
                              reader_id INT NOT NULL,
                              reservation_date DATE DEFAULT CURRENT_DATE,
                              return_date DATE,
                              FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
                              FOREIGN KEY (reader_id) REFERENCES readers(id) ON DELETE CASCADE
);

INSERT INTO books (title, author, published_year) VALUES
                                                      ('1984', 'George Orwell', 1949),
                                                      ('To Kill a Mockingbird', 'Harper Lee', 1960),
                                                      ('The Great Gatsby', 'F. Scott Fitzgerald', 1925),
                                                      ('Moby-Dick', 'Herman Melville', 1851),
                                                      ('War and Peace', 'Leo Tolstoy', 1869),
                                                      ('Pride and Prejudice', 'Jane Austen', 1813),
                                                      ('The Catcher in the Rye', 'J.D. Salinger', 1951),
                                                      ('The Hobbit', 'J.R.R. Tolkien', 1937),
                                                      ('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 1997),
                                                      ('The Lord of the Rings', 'J.R.R. Tolkien', 1954);

INSERT INTO users (login, password) VALUES
                                        ('Dimon', 'password123'),
                                        ('Vovan', 'qwerty');

CREATE OR REPLACE FUNCTION log_user_update() RETURNS TRIGGER AS $$
BEGIN
INSERT INTO logs (action, user_id) VALUES ('UPDATE', OLD.id);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_update_trigger
    AFTER UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION log_user_update();

CREATE OR REPLACE FUNCTION log_user_delete() RETURNS TRIGGER AS $$
BEGIN
INSERT INTO logs (action, user_id) VALUES ('DELETE', OLD.id);
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_delete_trigger
    AFTER DELETE ON users
    FOR EACH ROW
    EXECUTE FUNCTION log_user_delete();

CREATE OR REPLACE FUNCTION get_last_registered_user() RETURNS VARCHAR AS $$
DECLARE
last_login VARCHAR;
BEGIN
SELECT login INTO last_login FROM users ORDER BY created_at DESC LIMIT 1;
RETURN last_login;
END;
$$ LANGUAGE plpgsql;

