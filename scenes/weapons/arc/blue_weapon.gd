extends "res://scenes/weapons/weapon.gd"

func _ready():
	super()
	projectile = preload("res://scenes/weapons/arc/blue_projectile.tscn")
	initialize_weapon(Data.all_data[Data.wcls].keys()[Data.chromas.ARC])

func _process(delta):
	super(delta)

func fire():
	super()

func shooting_pattern():
	if is_instance_valid(target_loc):
		for i in range(weapon_stats[Data.wattr.NUM_PROJECTILES]):
			fire_once()
		prepare_next_shot()

func prepare_next_shot():
	super()
