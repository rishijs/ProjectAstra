extends Node

var all_data = {}

#definer, path
var csv_files:Dictionary = {
	"weapons":"res://data/csv/weapons.csvdata",
	"aberrations":"res://data/csv/aberrations.csvdata",
}

var wcls= csv_files.keys()[0]
var abcls = csv_files.keys()[1]

var unstable_aberrations = []
var stable_aberrations = []
var successful_aberrations = []

enum wattr{
	CHROMA,ARCHETYPE,DAMAGE,MAGAZINE,NUM_PROJECTILES,RELOAD_SPEED,FIRE_RATE,CHARGE_DURATION,RECOIL_AMOUNT,
	RECOIL_TIME,MAX_RECOIL,ACCURACY,MAX_SPREAD,JITTER,PROJECTILE_SPEED,HEADSHOT_MULTIPLIER,
	CRITICAL_CHANCE,CRITICAL_DAMAGE,DAMAGE_ID,ADS_FIRE_RATE,ADS_RECOIL_AMOUNT,ADS_ACCURACY,ADS_MAX_SPREAD,ADS_CRITICAL_CHANCE
}
enum abattr{
	STABILITY,FLAT_EFFECT,MULTIPLIED_EFFECT,ID,DESCRIPTION
}
enum chromas{
	IGNEOUS,ARC,NATURA,CHRONO,GREY
}

func _ready():
	for type in csv_files.keys():
		all_data[type] = csv_to_dict(csv_files[type])
	split_into_aberration_types()
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

#classifier,item name (ie. weapon name),attribute name (ie. fire rate)
#alternative way of getting data
func get_attr(cls,item_name,attribute):
	if item_name is int:
		item_name = all_data[cls].keys()[item_name]
	if item_name in all_data[cls]:
		var attribute_name = all_data[cls][item_name].keys()[attribute]
		if attribute_name in all_data[cls][item_name]:
			return all_data[cls][item_name][attribute_name]
		else:
			printerr("attribute not found: ",attribute_name)
	else:
		printerr("weapon not found: ",item_name)

func split_into_aberration_types():
	for i in range (all_data[abcls].keys().size()):
		var aberration = all_data[abcls][i]
		match aberration[abattr.STABILITY]:
			"unstable":
				unstable_aberrations.append(i)
			"stable":
				stable_aberrations.append(i)
			"successful":
				successful_aberrations.append(i)

