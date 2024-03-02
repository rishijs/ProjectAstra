extends Node

var all_data = {}

#definer, path
@export var csv_files:Dictionary = {
	"weapons":"res://data/csv/weapons.csvdata",
	"aberrations":"res://data/csv/aberrations.csvdata",
	"enemies":"res://data/csv/enemies.csvdata"
}

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
		
func _process(_delta):
	pass
