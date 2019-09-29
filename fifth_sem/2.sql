COPY trainer FROM '/Users/ilalevuskin/БД/table_filling/trainer.csv' DELIMITER ',' CSV HEADER;
COPY sport_place FROM '/Users/ilalevuskin/БД/table_filling/sport_place.csv' DELIMITER ',' CSV HEADER;
COPY equipment FROM '/Users/ilalevuskin/БД/table_filling/equipment.csv' DELIMITER ',' CSV HEADER;
COPY training FROM '/Users/ilalevuskin/БД/table_filling/training.csv' DELIMITER ',' CSV HEADER;
COPY sportsmen FROM '/Users/ilalevuskin/БД/table_filling/sportsmen.csv' DELIMITER ',' CSV HEADER;
COPY sport_elem FROM '/Users/ilalevuskin/БД/table_filling/sport_elem.csv' DELIMITER ',' CSV HEADER;


COPY training_sportsmen FROM '/Users/ilalevuskin/БД/table_filling/training_sportsmen.csv' DELIMITER ',' CSV HEADER;
COPY sportsmen_equipment FROM '/Users/ilalevuskin/БД/table_filling/sportsmen_equipment.csv' DELIMITER ',' CSV HEADER;
COPY sportsmen_sport_elem FROM '/Users/ilalevuskin/БД/table_filling/sportsmen_sport_elem.csv' DELIMITER ',' CSV HEADER;
COPY training_equipment FROM '/Users/ilalevuskin/БД/table_filling/training_equipment.csv' DELIMITER ',' CSV HEADER;
COPY sport_elem_equipment FROM '/Users/ilalevuskin/БД/table_filling/sport_elem_equipment.csv' DELIMITER ',' CSV HEADER;