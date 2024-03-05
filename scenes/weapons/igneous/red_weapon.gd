extends "res://scenes/weapons/weapon.gd"

func _ready():
	super()
	projectile = preload("res://scenes/weapons/igneous/red_projectile.tscn")
	initialize_weapon(Data.all_data[Data.wcls].keys()[Data.chromas.IGNEOUS])

func _process(delta):
	super(delta)

func fire():
	super()

func shooting_pattern():
	if is_instance_valid(target_loc):
		fire_once()
		prepare_next_shot()

func prepare_next_shot():
	add_recoil(weapon_stats[Data.wattr.RECOIL_TIME],weapon_stats[Data.wattr.RECOIL_AMOUNT]/10)
	weapon_state = States.PREPARING
	await get_tree().create_timer(weapon_stats[Data.wattr.FIRE_RATE],false).timeout
	weapon_state = States.READY
	if Input.is_action_pressed("primary_fire"):
		shooting_pattern()
