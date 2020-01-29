import psycopg2
import json
from datetime import datetime, date, time


class Trainer:

    def __init__(self, id, full_name, sport_razryad, experience, age,
                 phone_number, sex):
        self.id = id
        self.full_name = full_name
        self.sport_razryad = sport_razryad
        self.experience = experience
        self.age = age
        self.phone_number = phone_number
        self.sex = sex

class Training:

    def __init__(self, id, date_time, sport_place_id, trainer_id):
        self.id = id
        self.date_time = date_time
        self.sport_place_id = sport_place_id
        self.trainer_id = trainer_id


class Sportsmen:
    def __init__(self, id, full_name, sport_razryad, age,
                 phone_number, sex):
        self.id = id
        self.full_name = full_name
        self.sport_razryad = sport_razryad
        self.age = age
        self.phone_number = phone_number
        self.sex = sex

sport_razryad = {
    'Merited Master of Sport' : 10,
    'Master of Sport of the International Class' : 9,
    'Master of Sport' : 8,
    'Candidate for Master of Sport' : 7,
    'First-Class Sportsman' : 6,
    'Second-Class Sportsman' : 5,
    'Third-Class Sportsman' : 4,
    'First-Class Junior Sportsman' : 3,
    'Second-Class Junior Sportsman' : 2,
    'Third-Class Junior Sportsman' : 1,
    'None' : 0
}


# Однотабличный запрос
# Возраст тренеров с именем John
def doRequest1():
    cur = con.cursor()
    cur.execute('''select tr.age as age
                from trainer as tr
                where tr.full_name like \'John%\';''')

    rows = cur.fetchall()
    for row in rows:
        print(row)


# Многотабличный запрос
# Получить список всех тренеров, не имеющих никаких тренировок
def doRequest2():
    cur = con.cursor()
    cur.execute('''SELECT Id, Full_name
                    FROM trainer
                    WHERE EXISTS
                    (
                    SELECT tr.Id
                     FROM trainer AS tr
                        LEFT OUTER JOIN training ON training.Trainer_id = trainer.Id
                     WHERE training.Trainer_id IS NULL
                    );
''')

    rows = cur.fetchall()
    for row in rows:
        print(row)


# Получить список всех тренировок 1 января 2010 года
def doRequest3():
    cur = con.cursor()
    cur.execute('''SELECT DISTINCT Id, Date_time
                    FROM Training
                    WHERE Date_time BETWEEN '2010-01-01 00:00:00' AND '2010-01-01 23:59:59';''')
    rows = cur.fetchall()
    for row in rows:
        print(row)


# Получить пары спортсменов с одинаковым разрядом и возростом 18 лет
def doRequest4():
    cur = con.cursor()
    cur.execute('''SELECT DISTINCT C1.Full_name, C2.Full_name, C1.sport_razryad, C1.age
                    FROM Sportsmen AS C1 JOIN Sportsmen AS C2 ON C2.sport_razryad = C1.sport_razryad
                    WHERE C2.Id <> C1.Id AND C1.age = 18''')

    rows = cur.fetchall()
    for row in rows:
        print(row)


# Получить список всех спортсменов, разряд которых больше разряда тренера с id 10
def doRequest5():
    cur = con.cursor()
    cur.execute('''SELECT *
                    FROM sportsmen s
                    WHERE s.sport_razryad < ALL
                    (
                    SELECT t.sport_razryad
                     FROM trainer t
                     WHERE id  = 10
                    );''')

    rows = cur.fetchall()
    for row in rows:
        print(row)

# Возраст тренеров с именем John
def doRequest6(trainer):
    res = []

    for i in range(len(trainer.full_name)):
        if (trainer.full_name[i].find("John") != -1):
            res.append(trainer.age[i])

    for row in res:
        print(row)



# Получить список всех тренеров, не имеющих никаких тренировок
def doRequest7(trainer, training):
    res = []

    for i in range(len(trainer.id)):
        flag = True
        for j in range(len(training.id)):
            if (trainer.id[i] == training.trainer_id[j]):
                flag = False
                break
        if (flag):
            res.append([trainer.id[i], trainer.full_name[i], trainer.sport_razryad[i], trainer.experience[i], trainer.age[i],\
                 trainer.phone_number[i], trainer.sex[i]])

    '''for row in trainer:
        flag = True
        for row2 in training:
            if (row[0] == row2[3]):
                flag = False
                break
        if (flag):
            res.append(row)'''

    for row in res:
        print(row)


# Получить список всех тренировок 1 января 2010 года
def doRequest8(training):
    res = []

    d = date(2010, 1, 1)

    for i in range(len(training.id)):
        if (training.date_time[i].date() == d):
            res.append([training.id[i], training.date_time[i], training.sport_place_id[i], training.trainer_id[i]])

    for row in res:
        print(row)

# Получить пары спортсменов с одинаковым разрядом и возростом 18 лет
def doRequest9(sportsmen):
    res = []

    for i in range(len(sportsmen.id)):
        if (sportsmen.age[i] != 18):
            continue
        for j in range(len(sportsmen.id)):
            if ((sportsmen.sport_razryad[i] == sportsmen.sport_razryad[j]) and (sportsmen.age[j] == 18)):
                res.append([sportsmen.full_name[i], sportsmen.full_name[j], sportsmen.sport_razryad[i], sportsmen.age[i]])

    '''for row in sportsmen:
        if (row[3] != 18):
            continue
        for row2 in sportsmen:
            if ((row[2] == row2[2]) and (row2[3] == 18)):
                res.append([row[1], row2[1], row[2], row[3]])'''

    for row in res:
        print(row)           
    # print(res_rows)


# Получить список всех спортсменов, разряд которых больше разряда тренера с id 10
def doRequest10(sportsmen, trainer):
    res = []

    sp_r = ''

    for i in range(len(trainer.id)):
        if (trainer.id[i] == 10):
            sp_r = trainer.sport_razryad[i][:]
            break

    '''for row in trainer:
        if (row[0] == 10):
            sp_r = row[2][:]
            break'''


    for i in range(len(sportsmen.id)):
        if (sport_razryad.get(sportsmen.sport_razryad[i]) > sport_razryad.get(sp_r)):
            res.append([sportsmen.id[i], sportsmen.full_name[i], sportsmen.sport_razryad[i], sportsmen.age[i],
                 sportsmen.phone_number[i], sportsmen.sex[i]])

    '''for row in sportsmen:
        if (sport_razryad.get(row[2]) > sport_razryad.get(sp_r)):
            res.append(row)'''


    for row in res:
        print(row)

    print(len(res))


def get_col_from_table(table, col):
    res = []
    for row in table:
        res.append(row[col])
    return res


if __name__ == "__main__":
    con = psycopg2.connect(
        database="gymnastics", user='postgres',
        password='1973', host='localhost'
    )

    # doRequest1()
    # doRequest2()
    # doRequest3()
    # doRequest4()
    # doRequest5()
    
    con.commit()  
    con.close()

    print('\n\n\n\n\n\n')

    con = psycopg2.connect(
        database="gymnastics", user='postgres',
        password='1973', host='localhost'
    )

    cur = con.cursor()  
    cur.execute("select * from trainer;")
    record = cur.fetchall()

    trainer = Trainer(get_col_from_table(record, 0), get_col_from_table(record, 1), get_col_from_table(record, 2), get_col_from_table(record, 3), \
                           get_col_from_table(record, 4), get_col_from_table(record, 5), get_col_from_table(record, 6))


    cur.execute("select * from training;")
    record = cur.fetchall()
    training = Training(get_col_from_table(record, 0), get_col_from_table(record, 1), get_col_from_table(record, 2), get_col_from_table(record, 3))

    cur.execute("select * from sportsmen;")
    record = cur.fetchall()
    sportsmen = Sportsmen(get_col_from_table(record, 0), get_col_from_table(record, 1), get_col_from_table(record, 2), get_col_from_table(record, 3), \
                           get_col_from_table(record, 4), get_col_from_table(record, 5))

    con.commit()  
    con.close()

    # doRequest6(trainer)
    # doRequest7(trainer, training)
    # doRequest8(training)
    # doRequest9(sportsmen)
    # doRequest10(sportsmen, trainer)
