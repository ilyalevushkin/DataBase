CREATE TABLE otdel
(
    Id SERIAL PRIMARY KEY,
    Name CHAR(100) NOT NULL,
    Phone_number BIGINT CHECK(Phone_number > 0) UNIQUE NULL
);

CREATE TABLE sotrudnik
(
    Id SERIAL PRIMARY KEY,
	Dolgnost CHAR(100) NOT NULL,
    Full_name CHAR(100) NOT NULL,
	Salary INTEGER CHECK(Salary >= 5000) NOT NULL,
	otdel_id INTEGER,
    FOREIGN KEY (otdel_id) REFERENCES otdel (Id)
);

CREATE TABLE medicament
(
    Id SERIAL PRIMARY KEY,
    Name CHAR(100) NOT NULL,
	Instruction CHAR(1000) NOT NULL,
	Cost INTEGER CHECK(Cost > 0) NOT NULL
);

CREATE TABLE sotrudnik_medicament
(
    Sotrudnik_id INTEGER,
    Medicament_id INTEGER,
    FOREIGN KEY (Sotrudnik_id) REFERENCES sotrudnik (Id),
    FOREIGN KEY (Medicament_id) REFERENCES medicament (Id)
);

ALTER TABLE otdel ADD COLUMN Zaved INTEGER;
ALTER TABLE otdel ADD FOREIGN KEY (Zaved) REFERENCES sotrudnik (Id);