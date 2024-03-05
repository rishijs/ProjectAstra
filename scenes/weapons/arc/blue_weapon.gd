extends "res://scenes/weapons/weapon.gd"

func _ready():
	super()
	projectile = preload("res://scenes/weapons/default/default_projectile.tscn")
	initialize_weapon(Data.all_data[Data.wcls].keys()[Data.chromas.ARC])

func _process(delta):
	super(delta)

func fire():
	super()

func shooting_pattern():
	if is_instance_valid(target_loc):
		#12 rounds per shot
		for i in range(12):
			fire_once()
		prepare_next_shot()

func prepare_next_shot():
	super()
