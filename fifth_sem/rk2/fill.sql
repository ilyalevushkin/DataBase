COPY sotrudnik FROM '/Users/ilalevuskin/github/GitHub/DataBase/fifth_sem/rk2/sotrudnik.csv' DELIMITER ',' CSV HEADER;
COPY otdel FROM '/Users/ilalevuskin/github/GitHub/DataBase/fifth_sem/rk2/otdel.csv' DELIMITER ',' CSV HEADER;
COPY medicament FROM '/Users/ilalevuskin/github/GitHub/DataBase/fifth_sem/rk2/medicament.csv' DELIMITER ',' CSV HEADER;
COPY sotrudnik_medicament FROM '/Users/ilalevuskin/github/GitHub/DataBase/fifth_sem/rk2/sotrudnik_medicament.csv' DELIMITER ',' CSV HEADER;

UPDATE otdel SET Zaved = 2 WHERE ID = 1;
UPDATE otdel SET Zaved = 8 WHERE ID = 2;
UPDATE otdel SET Zaved = 5 WHERE ID = 3;
UPDATE otdel SET Zaved = 10 WHERE ID = 4;
UPDATE otdel SET Zaved = 1 WHERE ID = 5;
UPDATE otdel SET Zaved = 9 WHERE ID = 6;
UPDATE otdel SET Zaved = 4 WHERE ID = 7;
UPDATE otdel SET Zaved = 7 WHERE ID = 8;
UPDATE otdel SET Zaved = 3 WHERE ID = 9;
UPDATE otdel SET Zaved = 6 WHERE ID = 10;