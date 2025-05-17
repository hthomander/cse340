-- Grant necessary permissions first
GRANT ALL ON SCHEMA public TO cse340ht;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO cse340ht;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO cse340ht;


DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS account CASCADE;
DROP TABLE IF EXISTS classification CASCADE;
DROP TABLE IF EXISTS account_type CASCADE;

DO $$
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'account_type') THEN
    

CREATE TYPE account_type AS ENUM ('Client', 'Admin');
    END IF;
END$$;

ALTER TYPE account_type OWNER TO cse340ht;



CREATE TABLE classification (
    classification_id SERIAL PRIMARY KEY,
    classification_name VARCHAR(30) NOT NULL
);

CREATE TABLE account (
    account_id SERIAL PRIMARY KEY,
    account_firstname VARCHAR(50) NOT NULL,
    account_lastname VARCHAR(50) NOT NULL,
    account_email VARCHAR(100) NOT NULL,
    account_password VARCHAR(200) NOT NULL,
    account_type account_type DEFAULT 'Client'
);


CREATE TABLE inventory (
    inv_id SERIAL PRIMARY KEY,
    inv_make VARCHAR(50) NOT NULL,
    inv_model VARCHAR(50) NOT NULL,
    inv_year INTEGER NOT NULL,
    inv_description TEXT NOT NULL,
    inv_image VARCHAR(200) NOT NULL,
    inv_thumbnail VARCHAR(200) NOT NULL,
    inv_price DECIMAL(10,2) NOT NULL,
    inv_miles INTEGER NOT NULL,
    inv_color VARCHAR(20) NOT NULL,
    classification_id INTEGER REFERENCES classification(classification_id)
);

INSERT INTO classification (classification_name) VALUES 
('Sport'),
('SUV'),
('Truck'),
('Sedan');

INSERT INTO account (
    account_firstname, account_lastname, account_email, account_password, account_type
) VALUES 
('John', 'Doe', 'john@example.com', 'secure123', 'Client'),
('Jane', 'Smith', 'jane@example.com', 'pass456', 'Admin');

INSERT INTO inventory (
    inv_make, inv_model, inv_year, inv_description, inv_image, inv_thumbnail, inv_price, inv_miles, inv_color, classification_id
) VALUES 
('GM', 'Hummer', 2020, 'A rugged, off-road vehicle with a huge interior.', '/images/hummer.jpg', '/images/hummer-tn.jpg', 45000.00, 12000, 'Black', 3),
('Ford', 'Mustang', 2022, 'A sleek, high-performance sports car.', '/images/mustang.jpg', '/images/mustang-tn.jpg', 55000.00, 5000, 'Red', 1),
('Toyota', '4Runner', 2021, 'A durable SUV for adventure seekers.', '/images/4runner.jpg', '/images/4runner-tn.jpg', 38000.00, 15000, 'Blue', 2);

UPDATE inventory 
SET inv_description = REPLACE(inv_description, 'small interiors', 'a huge interior') 
WHERE inv_make = 'GM' AND inv_model = 'Hummer';


UPDATE inventory 
SET 
    inv_image = REPLACE(inv_image, '/images/', '/images/vehicles/'),
    inv_thumbnail = REPLACE(inv_thumbnail, '/images/', '/images/vehicles/');