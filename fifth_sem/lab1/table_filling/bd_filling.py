
from connections_filling import *
from coumns_filling import *





def list_write(list, f):
    f.write('\n')
    for i in range(len(list[0])):
        for l in range(len(list) - 1):
            f.write(str(list[l][i]) + ',')
        f.write(str(list[len(list) - 1][i]) + '\n')





def trainer_filling(settings, settings_for_columns):
    return [id_filling(settings.get("trainer")),
            name_filling(settings.get("trainer"), "trainer", settings_for_columns.get("max_name_length")),
            sport_razryad_filling(settings.get("trainer"), settings_for_columns.get("min_razryad")),
            experience_filling(settings.get("trainer"), settings_for_columns.get("min_experience")),
            age_filling(settings.get("trainer"), settings_for_columns.get("min_age"), settings_for_columns.get("max_age")),
            phone_number_filling(settings.get("trainer")),
            sex_filling(settings.get("trainer"))
            ]



def sport_place_filling(settings, settings_for_columns):
    return [id_filling(settings.get("sport_place")),
            address_filling(settings.get("sport_place"), settings_for_columns.get("max_length_address")),
            area_filling(settings.get("sport_place")),
            stage_amount_filling(settings.get("sport_place")),
            name_filling(settings.get("sport_place"), "sport_place", settings_for_columns.get("max_length_name"))]



def equipment_filling(settings):
    return [id_filling(settings.get("equipment")),
            name_filling(settings.get("equipment"), "equipment", settings_for_columns.get("max_length_name")),
            sport_place_id_filling(settings.get("equipment"), settings.get("sport_place"))
            ]



def training_filling(settings, settings_for_columns):
    return [id_filling(settings.get("training")),
            date_time_filling(settings.get("training"), settings_for_columns.get("min_date_time")),
            sport_place_id_filling(settings.get("training"), settings.get("sport_place")),
            trainer_id_filling(settings.get("training"), settings.get("trainer"))
            ]



def sportsmen_filling(settings, settings_for_columns):
    return [id_filling(settings.get("sportsmen")),
            name_filling(settings.get("sportsmen"), "sportsmen", settings_for_columns.get("max_name_length")),
            sport_razryad_filling(settings.get("sportsmen"), settings_for_columns.get("min_razryad")),
            age_filling(settings.get("sportsmen"), settings_for_columns.get("min_age"), settings_for_columns.get("max_age")),
            phone_number_filling(settings.get("sportsmen")),
            sex_filling(settings.get("sportsmen"))
            ]



def sport_elem_filling(settings, settings_for_columns):
    return [id_filling(settings.get("sport_elem")),
            name_filling(settings.get("sport_elem"), "sport_elem", settings_for_columns.get("max_name_length")),
            level_filling(settings.get("sport_elem"))
            ]







def training_sportsmen_filling(settings):
    return [training_id_filling(settings.get("training_sportsmen"), settings.get("training")),
            sportsmen_id_filling(settings.get("training_sportsmen"), settings.get("sportsmen"))]

def sportsmen_equipment_filling(settings):
    return [equipment_id_filling(settings.get("sportsmen_equipment"), settings.get("equipment")),
            sportsmen_id_filling(settings.get("sportsmen_equipment"), settings.get("sportsmen"))]

def sportsmen_sport_elem_filling(settings):
    return [sport_elem_id_filling(settings.get("sportsmen_sport_elem"), settings.get("sport_elem")),
            sportsmen_id_filling(settings.get("sportsmen_sport_elem"), settings.get("sportsmen"))]


def training_equipment_filling(settings):
    return [training_id_filling(settings.get("training_equipment"), settings.get("training")),
            equipment_id_filling(settings.get("training_equipment"), settings.get("equipment"))]


def sport_elem_equipment_filling(settings):
    return [sport_elem_id_filling(settings.get("sport_elem_equipment"), settings.get("sport_elem")),
            equipment_id_filling(settings.get("sport_elem_equipment"), settings.get("equipment"))]





def open_file(n, base_settings, settings_for_columns):
    list = []
    str = ''
    if (n == 0):
        str = 'trainer.csv'
        list = trainer_filling(base_settings, settings_for_columns.get("trainer"))
    elif (n == 1):
        str = 'sport_place.csv'
        list = sport_place_filling(base_settings, settings_for_columns.get("sport_place"))
    elif (n == 2):
        str = 'equipment.csv'
        list = equipment_filling(base_settings)
    elif (n == 3):
        str = 'training.csv'
        list = training_filling(base_settings, settings_for_columns.get("training"))
    elif (n == 4):
        str = 'sportsmen.csv'
        list = sportsmen_filling(base_settings, settings_for_columns.get("sportsmen"))
    elif (n == 5):
        str = 'sport_elem.csv'
        list = sport_elem_filling(base_settings, settings_for_columns.get("sport_elem"))
    elif (n == 6):
        str = 'training_sportsmen.csv'
        list = training_sportsmen_filling(base_settings)
    elif (n == 7):
        str = 'sportsmen_equipment.csv'
        list = sportsmen_equipment_filling(base_settings)
    elif (n == 8):
        str = 'sportsmen_sport_elem.csv'
        list = sportsmen_sport_elem_filling(base_settings)
    elif (n == 9):
        str = 'training_equipment.csv'
        list = training_equipment_filling(base_settings)
    elif (n == 10):
        str = 'sport_elem_equipment.csv'
        list = sport_elem_equipment_filling(base_settings)

    f = open(str, 'w')
    list_write(list, f)
    f.close()




base_settings = {
    "trainer" : 1000,
    "sport_place" : 10,
    "equipment" : 9,
    "training" : 10000,
    "sportsmen" : 5000,
    "sport_elem" : 10,
    "training_sportsmen" : 50000,
    "sportsmen_equipment" : 30000,
    "sportsmen_sport_elem" : 20000,
    "training_equipment" : 50000,
    "sport_elem_equipment" : 50
}

settings_for_columns = {
    "trainer" : {
        "max_name_length" : 100,
        "min_razryad" : 6,
        "min_experience" : 6,
        "min_age" : 18,
        "max_age" : 70
    },
    "sport_place" : {
        "max_length_address" : 100,
        "max_length_name" : 100
    },
    "equipment" : {
        "max_length_name" : 100
    },
    "training" : {
        "min_date_time" : ""
    },
    "sportsmen" : {
        "max_name_length" : 100,
        "min_razryad" : 0,
        "min_age" : 6,
        "max_age" : 40
    },
    "sport_elem" : {
        "max_name_length" : 100
    }
}



for i in range(11):
    open_file(i, base_settings, settings_for_columns)
