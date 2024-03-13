extends "res://scenes/weapons/weapon.gd"

func _ready():
	super()
	projectile = preload("res://scenes/weapons/natura/green_projectile.tscn")
	initialize_weapon(Data.all_data[Data.wcls].keys()[Data.chromas.NATURA])

func _process(delta):
	super(delta)

func fire():
	super()

func shooting_pattern():
	super()
	if is_instance_valid(target_loc):
		fire_once()
		prepare_next_shot()

func reload():
	weapon_state = States.RELOADING
	reloadS.pitch_scale = randf_range(0.8,1.2)
	reloadS.play()
	await get_tree().create_timer(weapon_stats[Data.wattr.RELOAD_SPEED],false).timeout
	weapon_state = States.READY
	magazine = weapon_stats[Data.wattr.MAGAZINE]
	if (Input.is_action_pressed("primary_fire") or Input.is_action_pressed("ads_fire")) and player_ref.active_weapon_index == Data.chromas.IGNEOUS:
		fire()

func prepare_next_shot():
	add_recoil(weapon_stats[Data.wattr.RECOIL_TIME],weapon_stats[Data.wattr.RECOIL_AMOUNT]/5)
	if weapon_state != States.RELOADING:
		weapon_state = States.PREPARING
		if is_ads_fire:
			await get_tree().create_timer(weapon_stats[Data.wattr.ADS_FIRE_RATE],false).timeout
		else:
			await get_tree().create_timer(weapon_stats[Data.wattr.FIRE_RATE],false).timeout
		weapon_state = States.READY
		if (Input.is_action_pressed("primary_fire") or Input.is_action_pressed("ads_fire")) and player_ref.active_weapon_index == Data.chromas.NATURA:
			if magazine >= weapon_stats[Data.wattr.NUM_PROJECTILES] and weapon_state != States.RELOADING:
				shooting_pattern()
