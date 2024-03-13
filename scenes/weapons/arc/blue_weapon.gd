extends "res://scenes/weapons/weapon.gd"

var cancel_reload = false
var can_fire = true

func _ready():
	super()
	projectile = preload("res://scenes/weapons/arc/blue_projectile.tscn")
	initialize_weapon(Data.all_data[Data.wcls].keys()[Data.chromas.ARC])

func _process(delta):
	super(delta)
	if magazine == 0:
		cancel_reload = false


func fire():
	if is_instance_valid(projectiles_ref) and is_instance_valid(muzzle) and can_fire:
		if initialized and magazine >= weapon_stats[Data.wattr.NUM_PROJECTILES]:
			shooting_pattern()
			cancel_reload = true

func reload():
	%Reload.wait_time = weapon_stats[Data.wattr.RELOAD_SPEED]
	%Reload.start()
	weapon_state = States.RELOADING
	
func shooting_pattern():
	super()
	if is_instance_valid(target_loc):
		await get_tree().create_timer(0.25,false).timeout
		for i in range(weapon_stats[Data.wattr.NUM_PROJECTILES]):
			fire_once()
		prepare_next_shot()

func prepare_next_shot():
	add_recoil(weapon_stats[Data.wattr.RECOIL_TIME],weapon_stats[Data.wattr.RECOIL_AMOUNT])
	weapon_state = States.PREPARING
	can_fire = false
	if is_ads_fire:
		await get_tree().create_timer(weapon_stats[Data.wattr.ADS_FIRE_RATE],false).timeout
	else:
		await get_tree().create_timer(weapon_stats[Data.wattr.FIRE_RATE],false).timeout
	can_fire = true
	if weapon_state != States.RELOADING and weapon_state != States.CHARGING:
		weapon_state = States.READY


func _on_reload_timeout():
	magazine += weapon_stats[Data.wattr.NUM_PROJECTILES]
	if magazine == weapon_stats[Data.wattr.MAGAZINE]:
		weapon_state = States.READY
		%Reload.stop()
