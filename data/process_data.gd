extends Node

var all_data = {}

#definer, path
@export var csv_files:Dictionary = {
	"weapons":"res://data/csv/weapons.csvdata",
	"aberrations":"res://data/csv/aberrations.csvdata",
	"enemies":"res://data/csv/enemies.csvdata"
}
var weapon_identifier = "weapons"
enum weapon_attributes {NAME,CHROMA,ARCHETYPE,DAMAGE,MAGAZINE,
FIRE_RATE,CRITICAL_CHANCE,CRITICAL_DAMAGE,DAMAGE_ID,ABERRATION_OBJECTIVE,
ABERRATION_TIME,ABERRATION_MOVEMENT}
var aberration_identifier = "aberrations"
enum aberration_attributes {NAME,FLAT_BONUS,MULTIPLIED_BONUS,ID,DESCRIPTION}
var enemy_identifier = "enemies"
enum enemy_attributes {NAME,HEALTH,DAMAGE,ID}

func _ready():
	for type in csv_files.keys():
		all_data[type] = csv_to_dict(csv_files[type])
	#print("default weapon fire rate: %f [test access]"%[get_weapon_attribute("default",weapon_attributes.FIRE_RATE)])

#takes in a csv file path and returns a dictionary of values it reads
#assumes you have headers in the csv along with the first column of each row being names
func csv_to_dict(filepath,delimiter = ','):
	if FileAccess.file_exists(filepath):
		var file = FileAccess.open(filepath,FileAccess.READ).get_as_text()
		#remove returns
		file = file.replace('\r','')
		#split by newline
		var rows = file.split('\n')
		#split by a comma delimiter for only headers
		var headers = rows[0].split(delimiter)
		var data = {}
		for i in range(1,len(rows)):
			#split by a comma delimiter for values
			var row = rows[i].split(delimiter)
			for j in range(1,len(headers)):
				#get row name and create a sub dictionary for every row's values
				if row[0] not in data:
					data[row[0]] = {}
				#convert values to float, or keep it as a string, then fill in dictionary
				if row[j].is_valid_float():
					data[row[0]][headers[j]] = float(row[j])
				else:
					data[row[0]][headers[j]] = row[j]
		return data

#easier way to get data without worrying about retyping the same line over and over again
#manually defined name, row name, col name
func get_weapon_attribute(item,attribute:weapon_attributes):
	if item is int:
		if len(all_data[weapon_identifier].keys()) > item:
			item = all_data[weapon_identifier].keys()[item]
	if (weapon_identifier in all_data) and (item in all_data[weapon_identifier]):
		match attribute:
			weapon_attributes.NAME:
				return all_data[weapon_identifier][item]["weapon"]
			weapon_attributes.CHROMA:
				return all_data[weapon_identifier][item]["chroma"]
			weapon_attributes.ARCHETYPE:
				return all_data[weapon_identifier][item]["archetype"]
			weapon_attributes.DAMAGE:
				return all_data[weapon_identifier][item]["damage"]
			weapon_attributes.MAGAZINE:
				return all_data[weapon_identifier][item]["magazine"]
			weapon_attributes.FIRE_RATE:
				return all_data[weapon_identifier][item]["fire rate"]
			weapon_attributes.CRITICAL_CHANCE:
				return all_data[weapon_identifier][item]["critical chance"]
			weapon_attributes.CRITICAL_DAMAGE:
				return all_data[weapon_identifier][item]["critical damage"]
			weapon_attributes.DAMAGE_ID:
				return all_data[weapon_identifier][item]["damage id"]
			weapon_attributes.ABERRATION_OBJECTIVE:
				return all_data[weapon_identifier][item]["aberration objective"]
			weapon_attributes.ABERRATION_TIME:
				return all_data[weapon_identifier][item]["aberration time"]
			weapon_attributes.ABERRATION_MOVEMENT:
				return all_data[weapon_identifier][item]["aberration movement"]
			_:
				printerr("weapon attribute not found")
	else:
		printerr("weapon data not found")

func get_aberration_attribute(item,attribute:aberration_attributes):
	if item is int:
		if len(all_data[aberration_identifier].keys()) > item:
			item = all_data[aberration_identifier].keys()[item]
	if (aberration_identifier in all_data) and (item in all_data[aberration_identifier]):
		match attribute:
			aberration_attributes.NAME:
				return all_data[aberration_identifier][item]["aberration"]
			aberration_attributes.FLAT_BONUS:
				return all_data[aberration_identifier][item]["flat bonus"]
			aberration_attributes.MULTIPLIED_BONUS:
				return all_data[aberration_identifier][item]["multiplied bonus"]
			aberration_attributes.ID:
				return all_data[aberration_identifier][item]["id"]
			aberration_attributes.DESCRIPTION:
				return all_data[aberration_identifier][item]["description"]
			_:
				printerr("aberration attribute not found")
	else:
		printerr("aberration data not found")
		
func get_enemy_attribute(item,attribute:enemy_attributes):
	if item is int:
		if len(all_data[enemy_identifier].keys()) > item:
			item = all_data[enemy_identifier].keys()[item]
	if (enemy_identifier in all_data) and (item in all_data[enemy_identifier]):
		match attribute:
			enemy_attributes.NAME:
				return all_data[enemy_identifier][item]["enemy"]
			enemy_attributes.HEALTH:
				return all_data[enemy_identifier][item]["health"]
			enemy_attributes.DAMAGE:
				return all_data[enemy_identifier][item]["damage"]
			enemy_attributes.ID:
				return all_data[enemy_identifier][item]["id"]
			_:
				printerr("enemy attribute not found")
	else:
		printerr("enemy data not found")
		
func _process(_delta):
	pass
