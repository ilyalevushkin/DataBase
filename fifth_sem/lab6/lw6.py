import psycopg2
import json


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


def loadDataFromJSON(dataFile):
    jsonFile = open(dataFile, "r")
    dataFromDB = json.load(jsonFile)
    jsonFile.close()

    return dataFromDB


def updateJSON(dataFile, dataFromDB, rowInd, colName, newValue):
    dataFromDB[rowInd][colName] = newValue
    jsonFile = open(dataFile, "w")

    json.dump(dataFromDB, jsonFile)
    jsonFile.close()


def addToJSON(dataFile, dataToDB):
    jsonFile = open(dataFile, "r")
    dataFromDB = json.load(jsonFile)
    jsonFile.close()

    dataFromDB.append(dataToDB)

    jsonFile = open(dataFile, "w")
    json.dump(dataFromDB, jsonFile)
    jsonFile.close()


# Однотабличный запрос
# Возраст тренеров с именем John
def doRequestType1():
    cur = con.cursor()
    cur.execute('''select tr.age as age
                from trainer as tr
                where tr.full_name like \'John%\';''')

    rows = cur.fetchall()
    for row in rows:
        print(row)


# Многотабличный запрос
# Получить список всех тренеров, обучающих спортсменов с отчеством 'Johnson'
def doRequestType2():
    cur = con.cursor()
    cur.execute('''SELECT DISTINCT *
                    FROM trainer AS t
                    WHERE t.Id IN
                    (
                     SELECT t.Id
                     FROM trainer AS t
                        JOIN training ON t.Id = training.Trainer_id
                        JOIN training_sportsmen AS ts ON ts.Training_id = training.Id
                        JOIN sportsmen ON sportsmen.Id = ts.Sportsmen_id
                     WHERE sportsmen.Full_name LIKE \'%Johnson%\'
                    )
                    ORDER BY t.Id
;''')

    rows = cur.fetchall()
    for row in rows:
        print(row)


# Запросы на добавление, изменение и удаление
# Добавление Гитлера в качестве тренера
def doRequestType3():
    cur = con.cursor()
    cur.execute('''INSERT INTO trainer (Id, full_name, sport_razryad, experience, age, phone_number, sex)
                    values (%s, %s, %s, %s, %s, %s, %s);''',
                    [1004, 'Adolph Hitler', 'Master of Sport', 10, 33, 82282282282, 'Men'])
    con.commit()


# Увеличить опыт работы тренеров всем мужчинам на 2
def doRequestType4():
    cur = con.cursor()
    cur.execute('''UPDATE trainer
                SET experience = experience + 2
                WHERE sex = \'Men\' ''')
    con.commit()


# Удаляем всех тренеров с Id большим 1000
def doRequestType5():
    cur = con.cursor()
    cur.execute('''DELETE FROM trainer
                    WHERE Id > 1000
                        ;''')
    con.commit()


# Доступ к данным, используя хранимую процедуру
# Добавляет выбранного спортсмена в тренера
def doRequestType6():
    cur = con.cursor()
    cur.execute("call test(4);")

    # rows = cur.fetchall()
    # for row in rows:
    #     print(row)


if __name__ == "__main__":
    con = psycopg2.connect(
        database="gymnastics", user='postgres',
        password='1973', host='localhost'
    )

    # doRequestType1()
    # doRequestType2()
    # doRequestType3()
    # doRequestType4()
    # doRequestType5()
    # doRequestType6()

    con.commit()
    con.close()

    print("OK")

    '''jsonFile = "/bd/trainer.json"

    trainer = loadDataFromJSON(jsonFile)

    updateJSON(jsonFile, trainer, 1000, "full_name", "Silvestr Stalone")

    dataToDB = {"Id":1001, "full_name":"Mark Zukerberg", "Sport_razryad":"Master of Sport of the International Class",
        "Experience":30, "Age":50, "Phone_number":89859771492, "Sex":'Men'}
    addToJSON(jsonFile, dataToDB)

    trainer = loadDataFromJSON(jsonFile)

    for row in trainer:
        print(row)'''

