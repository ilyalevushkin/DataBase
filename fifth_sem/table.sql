CREATE DATABASE gymnastics;



CREATE TYPE SPORT_RAZR AS ENUM (
    'Merited Master of Sport', 
    'Master of Sport of the International Class', 
    'Master of Sport',
    'Candidate for Master of Sport',
    'First-Class Sportsman',
    'Second-Class Sportsman',
    'Third-Class Sportsman',
    'First-Class Junior Sportsman',
    'Second-Class Junior Sportsman',
    'Third-Class Junior Sportsman',
    'None'
);

CREATE TYPE SPORT_ELEM_LEVEL AS ENUM (
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
);

CREATE TYPE EQUIPMENT_NAME AS ENUM (
    'Balance beam',
    'Crossbar',
    'Bars',
    'Rings',
    'Bridge',
    'Uneven bars',
    'Gymnastic horse for jumping',
    'Goat gymnastic',
    'Gymnastic horse'
);

CREATE TYPE SEX AS ENUM (
    'Men',
    'Women'
);


CREATE TABLE trainer
(
    Id SERIAL PRIMARY KEY,
    Full_name CHAR(100) NOT NULL,
    Sport_razryad SPORT_RAZR CHECK(Sport_razryad <= 'First-Class Sportsman') NOT NULL,
    Experience INTEGER CHECK(Experience > 5) NOT NULL,
    Age INTEGER CHECK(Age >= 18 AND Age <= 70) NOT NULL,
    Phone_number BIGINT CHECK(Phone_number > 0) UNIQUE NULL,
    Sex SEX NOT NULL
);

CREATE TABLE sport_place
(
    Id SERIAL PRIMARY KEY,
    Address CHAR(100) NOT NULL,
    Area INTEGER CHECK(Area > 0) NOT NULL,
    Stage_amount SMALLINT CHECK(Stage_amount > 0) NOT NULL,
    Name CHAR(100) NOT NULL
);

CREATE TABLE equipment
(
    Id SERIAL PRIMARY KEY,
    Name EQUIPMENT_NAME NOT NULL,
    Sport_place_id INTEGER,
    FOREIGN KEY (Sport_place_id) REFERENCES sport_place (Id)
);

CREATE TABLE training
(
    Id SERIAL PRIMARY KEY,
    Date_time TIMESTAMP CHECK(Date_time > '2000-01-01 00:00:00') NOT NULL,
    Sport_place_id INTEGER,
    Trainer_id INTEGER,
    FOREIGN KEY (Sport_place_id) REFERENCES sport_place (Id),
    FOREIGN KEY (Trainer_id) REFERENCES trainer (Id)
);

CREATE TABLE sportsmen
(
    Id SERIAL PRIMARY KEY,
    Full_name CHAR(100) NOT NULL,
    Sport_razryad SPORT_RAZR NOT NULL,
    Age INTEGER CHECK(Age >= 6 AND Age <= 40) NOT NULL,
    Phone_number BIGINT CHECK(Phone_number > 0) UNIQUE NULL,
    Sex SEX NOT NULL
);

CREATE TABLE sport_elem
(
    Id SERIAL PRIMARY KEY,
    Name CHAR(100),
    Level SPORT_ELEM_LEVEL NOT NULL
);





CREATE TABLE training_sportsmen
(
    Training_id INTEGER,
    Sportsmen_id INTEGER,
    FOREIGN KEY (Sportsmen_id) REFERENCES sportsmen (Id),
    FOREIGN KEY (Training_id) REFERENCES training (Id)
);

CREATE TABLE sportsmen_equipment
(
    Equipment_id INTEGER,
    Sportsmen_id INTEGER,
    FOREIGN KEY (Sportsmen_id) REFERENCES sportsmen (Id),
    FOREIGN KEY (Equipment_id) REFERENCES equipment (Id)
);

CREATE TABLE sportsmen_sport_elem
(
    Sport_elem_id INTEGER,
    Sportsmen_id INTEGER,
    FOREIGN KEY (Sportsmen_id) REFERENCES sportsmen (Id),
    FOREIGN KEY (Sport_elem_id) REFERENCES sport_elem (Id)
);

CREATE TABLE training_equipment
(
    Training_id INTEGER,
    Equipment_id INTEGER,
    FOREIGN KEY (Equipment_id) REFERENCES equipment (Id),
    FOREIGN KEY (Training_id) REFERENCES training (Id)
);

CREATE TABLE sport_elem_equipment
(
    Sport_elem_id INTEGER,
    Equipment_id INTEGER,
    FOREIGN KEY (Equipment_id) REFERENCES equipment (Id),
    FOREIGN KEY (Sport_elem_id) REFERENCES sport_elem (Id)
);