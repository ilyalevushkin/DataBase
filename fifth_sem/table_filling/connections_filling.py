import random

def fk_id_filling(n, k):
    list = []
    random.seed()
    for i in range(n):
        list.append(random.randint(1, k))
    return list


def sport_place_id_filling(n, k):
    return fk_id_filling(n, k)

def trainer_id_filling(n, k):
    return fk_id_filling(n, k)

def training_id_filling(n, k):
    return fk_id_filling(n, k)

def sportsmen_id_filling(n, k):
    return fk_id_filling(n, k)

def equipment_id_filling(n, k):
    return fk_id_filling(n, k)

def sport_elem_id_filling(n, k):
    return fk_id_filling(n, k)
