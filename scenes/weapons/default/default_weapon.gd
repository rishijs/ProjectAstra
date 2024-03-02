extends "res://scenes/weapons/weapon.gd"

func _ready():
	super()
	projectile = preload("res://scenes/weapons/default/default_projectile.tscn")
	initialize_weapon("default")

func _process(delta):
	super(delta)

func fire():
	super()

func shooting_pattern():
	var this_projectile = projectile.instantiate()
	if player_ref.movement_ability:
		projectile_stats["bullet_speed"] = weapon_data[weapon_name]["projectile speed"] * 2
	this_projectile.projectile_stats = projectile_stats
	projectile_manager_ref.add_child(this_projectile)
	this_projectile.global_position = muzzle.global_position
	prepare_next_shot()

func prepare_next_shot():
	super()
