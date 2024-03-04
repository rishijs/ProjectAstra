extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@onready var projectile_manager_ref = get_tree().get_first_node_in_group("ProjectileManager")
@onready var weapon_data = Data.all_data[Data.wcls]

var projectile
var muzzle
var weapon_stats = []
var initialized = false
var weapon_name

enum States{READY, PREPARING, RELOADING};
var weapon_state= States.READY

func _ready():
	muzzle = %muzzle

func _process(_delta):
	pass

func initialize_weapon(weapon):
	#weapon stats for mutability
	weapon_name = weapon
	for attr in range(len(weapon_data[weapon].keys())):
		weapon_stats.append(Data.get_attr(Data.wcls,weapon,attr))
	initialized = true

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
	add_recoil(weapon_stats[Data.wattr.RECOIL_TIME],weapon_stats[Data.wattr.RECOIL_AMOUNT])
	weapon_state = States.PREPARING
	await get_tree().create_timer(weapon_stats[Data.wattr.FIRE_RATE],false).timeout
	weapon_state = States.READY
