from faker import Faker
import random

sport_elements = [
    "Перекат",
    "Кувырок",
    "Переворот",
    "Движение дугой",
    "Сальто",
    "Стойка",
    "Мост",
    "Шпагат",
    "Винт",
    "Фляк",
]

sport_razryad = [
    "Merited Master of Sport",
    "Master of Sport of the International Class",
    "Master of Sport",
    "Candidate for Master of Sport",
    "First-Class Sportsman",
    "Second-Class Sportsman",
    "Third-Class Sportsman",
    "First-Class Junior Sportsman",
    "Second-Class Junior Sportsman",
    "Third-Class Junior Sportsman",
    "None"
]

sex_list = [
    "Men",
    "Women"
]

level_list = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F"
]

def id_filling(n):
    list = []
    for i in range(n):
        list.append(i + 1)
    return list


def get_trainer_name(fake, length):
    rezult = fake.name()
    while (len(rezult) > length):
        rezult = fake.name()
    return rezult

def get_address(fake, length):
    rezult = fake.country()
    while (len(rezult) > length):
        rezult = fake.country()
    return rezult

def get_sport_place_name(n):
    rezult = "ARENA_" + str(n)
    return rezult

def get_equipment_name(i):
    if (i == 0):
        rezult = "Balance beam"
    elif (i == 1):
        rezult = "Crossbar"
    elif (i == 2):
        rezult = "Bars"
    elif (i == 3):
        rezult = "Rings"
    elif (i == 4):
        rezult = "Bridge"
    elif (i == 5):
        rezult = "Uneven bars"
    elif (i == 6):
        rezult = "Gymnastic horse for jumping"
    elif (i == 7):
        rezult = "Goat gymnastic"
    elif (i == 8):
        rezult = "Gymnastic horse"
    return rezult

def get_sportsmen_name(fake, length):
    rezult = fake.name()
    while (len(rezult) > length):
        rezult = fake.name()
    return rezult

def get_sport_elem_name(n):
    rezult = sport_elements[n]
    return rezult


def name_filling(n, which_name, length):
    fake = Faker()
    list = []
    if (which_name == "trainer"):
        for i in range(n):
            rezult = get_trainer_name(fake, length)
            list.append(rezult)
    elif (which_name == "sport_place"):
        for i in range(n):
            rezult = get_sport_place_name(i)
            list.append(rezult)
    elif (which_name == "equipment"):
        for i in range(n):
            rezult = get_equipment_name(i)
            list.append(rezult)
    elif (which_name == "sportsmen"):
        for i in range(n):
            rezult = get_sportsmen_name(fake, length)
            list.append(rezult)
    elif (which_name == "sport_elem"):
        for i in range(n):
            rezult = get_sport_elem_name(i)
            list.append(rezult)
    return list

def sport_razryad_filling(n, min_razryad):
    list = []
    random.seed()
    for i in range(n):
        rezult = sport_razryad[random.randint(0, 11 - min_razryad - 1)]
        list.append(rezult)
    return list

def experience_filling(n, min_exp):
    list = []
    random.seed()
    for i in range(n):
        rezult = random.randint(min_exp, 52)
        list.append(rezult)
    return list

def age_filling(n, min_age, max_age):
    list = []
    random.seed()
    for i in range(n):
        rezult = random.randint(min_age, max_age)
        list.append(rezult)
    return list

def phone_number_filling(n):
    list = []
    random.seed()
    for i in range(n):
        rezult = 89
        for l in range(9):
            rezult = rezult * 10 + random.randint(0, 9)
        list.append(rezult)
    return list

def sex_filling(n):
    list = []
    random.seed()
    for i in range(n):
        rezult = sex_list[random.randint(0, 1)]
        list.append(rezult)
    return list

def address_filling(n, length):
    list = []
    fake = Faker()
    for l in range(n):
        rezult = get_address(fake, length)
        list.append(rezult)
    return list

def area_filling(n):
    list = []
    random.seed()
    for i in range(n):
        rezult = random.randint(1, 10000)
        list.append(rezult)
    return list

def stage_amount_filling(n):
    list = []
    random.seed()
    for i in range(n):
        rezult = random.randint(1, 20)
        list.append(rezult)
    return list


def convert_number_to_str_format(number):
    rezult = str(number)
    if (number < 10):
        rezult = "0" + rezult
    return rezult

def date_time_filling(n, date_time_from):
    list = []
    random.seed()
    year = ""
    month = ""
    day = ""
    hours = ""
    minutes = ""
    sec = ""
    i = 0
    while (date_time_from[i] != '-'):
        year += date_time_from[i]
        i += 1
    i += 1
    while (date_time_from[i] != '-'):
        month += date_time_from[i]
        i += 1
    i += 1
    while (date_time_from[i] != ' '):
        day += date_time_from[i]
        i += 1
    i += 1
    while (date_time_from[i] != ':'):
        hours += date_time_from[i]
        i += 1
    i += 1
    while (date_time_from[i] != ':'):
        minutes += date_time_from[i]
        i += 1
    i += 1
    while (i != len(date_time_from)):
        sec += date_time_from[i]
        i += 1
    year = int(year)
    month = int(month)
    day = int(day)
    hours = int(hours)
    minutes = int(minutes)
    sec = int(sec)

    for i in range(n):
        res_year = random.randint(year, 2018)
        res_month = 0
        res_day = 0
        res_hours = 0
        res_minutes = 0
        res_sec = 0
        if (res_year == year):
            res_month = random.randint(month, 12)
            if (res_month == month):
                res_day = random.randint(day, 28)
                if (res_day == day):
                    res_hours = random.randint(hours, 23)
                    if (res_hours == hours):
                        res_minutes = random.randint(minutes, 59)
                        if (res_minutes == minutes):
                            res_sec = random.randint(sec, 59)
                        else:
                            res_sec = random.randint(0, 59)
                    else:
                        res_minutes = random.randint(0, 59)
                        res_sec = random.randint(0, 59)
                else:
                    res_hours = random.randint(0, 23)
                    res_minutes = random.randint(0, 59)
                    res_sec = random.randint(0, 59)
            else:
                res_day = random.randint(1, 28)
                res_hours = random.randint(0, 23)
                res_minutes = random.randint(0, 59)
                res_sec = random.randint(0, 59)
        else:
            res_month = random.randint(1, 12)
            res_day = random.randint(1, 28)
            res_hours = random.randint(0, 23)
            res_minutes = random.randint(0, 59)
            res_sec = random.randint(0, 59)


        month_str = convert_number_to_str_format(res_month)
        day_str = convert_number_to_str_format(res_day)
        hours_str = convert_number_to_str_format(res_hours)
        minutes_str = convert_number_to_str_format(res_minutes)
        sec_str = convert_number_to_str_format(res_sec)

        list.append(str(res_year) + "-" + month_str + "-"
                    + day_str + " " + hours_str + ":" + minutes_str + ":" + sec_str)

    return list

def level_filling(n):
    list = []
    random.seed()
    for i in range(n):
        rezult = level_list[random.randint(0, 5)]
        list.append(rezult)
    return list






