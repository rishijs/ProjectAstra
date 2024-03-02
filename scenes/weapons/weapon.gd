extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@onready var projectile_manager_ref = get_tree().get_first_node_in_group("ProjectileManager")
@onready var weapon_data = Data.all_data["weapons"]

var projectile
var muzzle
var weapon_stats = {}
var projectile_stats = {}
var initialized = false
var weapon_name

enum States{READY, PREPARING, RELOADING};
var weapon_state= States.READY

func _ready():
	muzzle = %muzzle

func _process(_delta):
	pass

func initialize_weapon(weapon):
	#weapon specific mutable stats
	weapon_name = weapon
	weapon_stats["fire_rate"] = weapon_data[weapon]["fire rate"]
	weapon_stats["objective"] = weapon_data[weapon]["objective"]
	weapon_stats["stable_time"] = weapon_data[weapon]["stable time"]
	weapon_stats["damage_id"] = weapon_data[weapon]["projectile speed"]
	weapon_stats["reload_speed"] = weapon_data[weapon]["reload speed"]
	weapon_stats["recoil_amount"] = weapon_data[weapon]["recoil amount"]
	weapon_stats["recoil_time"] = weapon_data[weapon]["recoil time"]
	initialized = true
	
	#projectile specific mutable stats
	projectile_stats["critical_chance"] = weapon_data[weapon]["critical chance"]
	projectile_stats["critical_damage"] = weapon_data[weapon]["critical damage"]
	projectile_stats["headshot_multiplier"] = weapon_data[weapon]["headshot multiplier"]
	projectile_stats["bullet_damage"] = weapon_data[weapon]["damage"]
	projectile_stats["bullet_speed"] = weapon_data[weapon]["projectile speed"]
	projectile_stats["damage_id"] = weapon_data[weapon]["damage id"]
	projectile_stats["jitter"] = weapon_data[weapon]["jitter"]
	projectile_stats["falloff_range"] = weapon_data[weapon]["falloff range"]
	projectile_stats["falloff_multiplier"] = weapon_data[weapon]["falloff multiplier"]
	projectile_stats["max_range"] = weapon_data[weapon]["max range"]
	projectile_stats["accuracy"] = weapon_data[weapon]["accuracy"]
	projectile_stats["max_spread"] = weapon_data[weapon]["max spread"]

func muzzle_flash():
	pass

func add_recoil(time,angle):
	player_ref.weapon.rotate_z(angle)
	await get_tree().create_timer(time,true).timeout
	player_ref.weapon.rotate_z(-angle)
		
func fire():
	if is_instance_valid(projectile_manager_ref) and is_instance_valid(muzzle):
		if weapon_state == States.READY and initialized:
			shooting_pattern()
	else:
		printerr("references not set")

func shooting_pattern():
	pass

func prepare_next_shot():
	add_recoil(weapon_stats["recoil_time"],weapon_stats["recoil_amount"])
	weapon_state = States.PREPARING
	await get_tree().create_timer(weapon_stats["fire_rate"],false).timeout
	weapon_state = States.READY
