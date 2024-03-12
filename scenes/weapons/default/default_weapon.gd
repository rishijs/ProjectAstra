extends "res://scenes/weapons/weapon.gd"

func _ready():
	super()
	projectile = preload("res://scenes/weapons/default/default_projectile.tscn")
	initialize_weapon(Data.all_data[Data.wcls].keys()[Data.chromas.GREY])

func _process(delta):
	super(delta)

func fire(ads = false):
	super(ads)

func shooting_pattern():
	super()
	if is_instance_valid(target_loc):
		fire_once()
		prepare_next_shot()
		
func prepare_next_shot():
	super()
