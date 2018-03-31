-- Schema for storing a subset of the Car rentals
-- available at https://www.avis.ca/


DROP SCHEMA IF EXISTS carschema CASCADE;
CREATE SCHEMA carschema;

SET SEARCH_PATH to carschema;

CREATE TABLE customer(
  -- The full name of the customer.
  name VARCHAR(50) NOT NULL,
  age INT NOT NULL,
  email VARCHAR(100) NOT NULL,
  UNIQUE(name, age, email)
);

CREATE TYPE status_type AS ENUM(
'Confirmed', 'Ongoing', 'Completed', 'Cancelled');

CREATE TABLE model(
  id INT primary key,
  name VARCHAR(50) NOT NULL,
  vehicle_type VARCHAR(50) NOT NULL,
  model_number INT NOT NULL,
  capacity INT NOT NULL
);

CREATE TABLE car(
  id INT primary key,
  licence_plate_number VARCHAR(10),
  station_code INT NOT NULL,
  model_id INT NOT NULL REFERENCES model(id)
);


CREATE TABLE reservation(
  id INT primary key,
  from_date Timestamp NOT NULL,
  to_date Timestamp NOT NULL CHECK (to_date > from_date),
  car_id INT NOT NULL REFERENCES car(id),
  old_reservation_id INT REFERENCES reservation(id),
  reservation_status status_type NOT NULL,
  drivers INT NOT NULL
);

CREATE TABLE rental_station(
  station_code INT primary key,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(100) NOT NULL,
  area_code VARCHAR(10) NOT NULL,
  city VARCHAR(100) NOT NULL
);


CREATE TABLE customer_reservation(
  customer_email VARCHAR(100) NOT NULL,
  reservation_id INT NOT NULL,
  UNIQUE(customer_email, reservation_id)
);


