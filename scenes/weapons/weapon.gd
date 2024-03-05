extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@onready var projectiles_ref = get_tree().get_first_node_in_group("Projectiles")
@export var camera_shake_noise : FastNoiseLite

var offset : Vector3
var camera_shake_amp = 0.0
var camera_shake_time_left = 0.0

var projectile
var muzzle
var weapon_stats = []
var initialized = false
var weapon_name

enum States{READY, PREPARING, RELOADING};
var weapon_state= States.READY

func _ready():
	muzzle = %muzzle

func _process(delta):
	if camera_shake_time_left > 0:
		camera_shake_time_left -= delta
		camera_shake()

func initialize_weapon(weapon):
	#weapon stats for mutability
	camera_shake_noise.seed = randi()
	weapon_name = weapon
	for attr in range(len(Data.all_data[Data.wcls][weapon].keys())):
		weapon_stats.append(Data.get_attr(Data.wcls,weapon,attr))
	initialized = true

func muzzle_flash():
	pass

func camera_shake():
	offset.y = camera_shake_noise.get_noise_3d(camera_shake_noise.seed*2,camera_shake_time_left,randf()) 
	offset.z = camera_shake_noise.get_noise_3d(camera_shake_noise.seed*3,randf(),randf())
	player_ref.camera_first_person.rotation.y = offset.y * camera_shake_amp
	player_ref.camera_first_person.rotation.z = offset.z * camera_shake_amp
	
func add_recoil(time,angle):
	player_ref.weapon.rotate_z(angle)
	player_ref.camera_first_person.rotate_x(angle * weapon_stats[Data.wattr.MAX_RECOIL])
	player_ref.weapon_socket.rotation.z = player_ref.camera_first_person.rotation.x
	camera_shake_amp = weapon_stats[Data.wattr.RECOIL_AMOUNT]+1
	camera_shake_time_left = time
	camera_shake()
	await get_tree().create_timer(time,true).timeout
	player_ref.weapon.rotate_z(-angle)
	#player_ref.camera_first_person.rotate_x(-angle/100)
		
func fire():
	if is_instance_valid(projectiles_ref) and is_instance_valid(muzzle):
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
