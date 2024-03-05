extends "res://scenes/weapons/weapon.gd"

func _ready():
	super()
	projectile = preload("res://scenes/weapons/default/default_projectile.tscn")
	initialize_weapon(Data.all_data[Data.wcls].keys()[Data.chromas.GREY])

func _process(delta):
	super(delta)

func fire():
	super()

func shooting_pattern():
	var this_projectile = projectile.instantiate()
	if player_ref.movement_ability:
		weapon_stats[Data.wattr.PROJECTILE_SPEED] = Data.get_attr(Data.wcls,weapon_name,Data.wattr.PROJECTILE_SPEED)
	this_projectile.weapon_stats = weapon_stats
	projectiles_ref.add_child(this_projectile)
	this_projectile.global_position = muzzle.global_position
	prepare_next_shot()

func prepare_next_shot():
	super()
