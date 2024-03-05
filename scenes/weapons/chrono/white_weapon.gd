extends "res://scenes/weapons/weapon.gd"

@export var muzzles:Array[Marker3D]

func _ready():
	super()
	projectile = preload("res://scenes/weapons/chrono/white_projectile.tscn")
	initialize_weapon(Data.all_data[Data.wcls].keys()[Data.chromas.CHRONO])

func _process(delta):
	super(delta)
	if weapon_state == States.CHARGING and charge_time > 0 and Input.is_action_pressed("primary_fire"):
		charge_time = clampf(charge_time - delta,0,weapon_stats[Data.wattr.CHARGE_DURATION])
	elif weapon_state == States.CHARGING and charge_time == 0 and Input.is_action_pressed("primary_fire"):
		shooting_pattern()
	elif not Input.is_action_pressed("primary_fire"):
		weapon_state = States.READY
		charge_time = 0

func fire():
	if is_instance_valid(projectiles_ref) and is_instance_valid(muzzle):
		if weapon_state == States.READY and initialized:
			weapon_state = States.CHARGING
			charge_time = weapon_stats[Data.wattr.CHARGE_DURATION]
	else:
		printerr("references not set")

func shooting_pattern():
	if is_instance_valid(target_loc):
		for m in range(weapon_stats[Data.wattr.NUM_PROJECTILES]):
			if m < muzzles.size():
				fire_at_muzzle(m)
		prepare_next_shot()

func fire_at_muzzle(muzzle_index):
	var this_projectile = projectile.instantiate()
	if player_ref.movement_ability:
		weapon_stats[Data.wattr.PROJECTILE_SPEED] = Data.get_attr(Data.wcls,weapon_name,Data.wattr.PROJECTILE_SPEED)
	this_projectile.weapon_stats = weapon_stats
	this_projectile.target = target_loc
	projectiles_ref.add_child(this_projectile)
	this_projectile.global_position = muzzles[muzzle_index].global_position

func prepare_next_shot():
	super()
