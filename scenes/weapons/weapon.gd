extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@onready var projectiles_ref = get_tree().get_first_node_in_group("Projectiles")
@onready var post_process = get_tree().get_first_node_in_group("PostProcess");
@onready var game_manager_ref = get_tree().get_first_node_in_group("GameManager");

@export var current_weapon = false
@export var camera_shake_noise : FastNoiseLite

var offset : Vector3
var camera_shake_amp = 0.0
var camera_shake_time_left = 0.0

var projectile
var muzzle
var target_loc
var weapon_stats = []
var initialized = false
var weapon_name
var charge_time = 0
var magazine

var is_ads_fire

enum States{READY, PREPARING, RELOADING, CHARGING, INACTIVE};
var weapon_state= States.INACTIVE

func _ready():
	muzzle = %muzzle
	target_loc = %Target

func _input(_event):
	if Input.is_action_just_pressed("primary_fire"):
		is_ads_fire = false
		switch_to_ads(false)
	elif Input.is_action_just_pressed("ads_fire") and weapon_state != States.CHARGING:
		is_ads_fire = true
		switch_to_ads(true)
	elif Input.is_action_just_released("ads_fire"):
		is_ads_fire = false
		switch_to_ads(false)
		
func _process(delta):
	if camera_shake_time_left > 0:
		camera_shake_time_left -= delta
		camera_shake()
	if current_weapon:
		weapon_load()
	else:
		weapon_inactive()
	
	if magazine == 0 and weapon_state!=States.RELOADING:
		reload()
		
func weapon_load():
	if weapon_state == States.INACTIVE:
		await get_tree().create_timer(0.5,false).timeout
		weapon_state= States.READY

func weapon_inactive():
	weapon_state= States.INACTIVE

func initialize_weapon(weapon):
	#weapon stats for mutability
	weapon_name = weapon
	
	for attr in range(len(Data.all_data[Data.wcls][weapon].keys())):
		weapon_stats.append(Data.get_attr(Data.wcls,weapon,attr))
		weapon_stats[attr] += game_manager_ref.altered_weapon_flat_stats
		weapon_stats[attr] *= game_manager_ref.altered_weapon_multiplied_stats
		
	magazine = weapon_stats[Data.wattr.MAGAZINE]
	initialized = true
	global_rotation = player_ref.weapon_socket.global_rotation

func muzzle_flash():
	pass

func camera_shake():
	offset.y = camera_shake_noise.get_noise_3d(camera_shake_noise.seed*2,camera_shake_time_left,randf()) 
	offset.z = camera_shake_noise.get_noise_3d(camera_shake_noise.seed*3,camera_shake_time_left,randf())
	player_ref.camera_first_person.rotation.y = clampf(offset.y,0,camera_shake_amp)
	player_ref.camera_first_person.rotation.z = clampf(offset.z,0,camera_shake_amp/10)
	
func add_recoil(time,angle):
	player_ref.weapons[player_ref.active_weapon_index].rotate_z(angle)
	player_ref.camera_first_person.rotate_x(angle * weapon_stats[Data.wattr.MAX_RECOIL])
	player_ref.weapon_socket.rotation.z = player_ref.camera_first_person.rotation.x
	camera_shake_amp = weapon_stats[Data.wattr.RECOIL_AMOUNT]+1
	camera_shake_time_left = time
	camera_shake()
	await get_tree().create_timer(time,true).timeout
	rotate_z(-angle)
	rotation = Vector3.ZERO
		
func fire():
	if is_instance_valid(projectiles_ref) and is_instance_valid(muzzle):
		if weapon_state == States.READY and initialized and magazine >= weapon_stats[Data.wattr.NUM_PROJECTILES]:
			shooting_pattern()
				

func shooting_pattern():
	magazine -= weapon_stats[Data.wattr.NUM_PROJECTILES]

func refill():
	magazine = weapon_stats[Data.wattr.MAGAZINE]
	
func reload():
	weapon_state = States.RELOADING
	await get_tree().create_timer(weapon_stats[Data.wattr.RELOAD_SPEED],false).timeout
	weapon_state = States.READY
	magazine = weapon_stats[Data.wattr.MAGAZINE]
	
func fire_once():
	var this_projectile = projectile.instantiate()
	weapon_stats[Data.wattr.PROJECTILE_SPEED] = player_ref.speed + Data.get_attr(Data.wcls,weapon_name,Data.wattr.PROJECTILE_SPEED)
	this_projectile.weapon_stats = weapon_stats
	this_projectile.target = target_loc
	projectiles_ref.add_child(this_projectile)
	this_projectile.global_position = muzzle.global_position
	this_projectile.global_rotation = muzzle.global_rotation

func switch_to_ads(to):
	if not to:
		weapon_stats[Data.wattr.CRITICAL_CHANCE] = Data.get_attr(Data.wcls,weapon_name,Data.wattr.CRITICAL_CHANCE)
		weapon_stats[Data.wattr.ACCURACY] = Data.get_attr(Data.wcls,weapon_name,Data.wattr.ACCURACY)
		weapon_stats[Data.wattr.MAX_SPREAD] = Data.get_attr(Data.wcls,weapon_name,Data.wattr.MAX_SPREAD)
		weapon_stats[Data.wattr.RECOIL_AMOUNT] = Data.get_attr(Data.wcls,weapon_name,Data.wattr.RECOIL_AMOUNT)
	else:
		weapon_stats[Data.wattr.CRITICAL_CHANCE] = Data.get_attr(Data.wcls,weapon_name,Data.wattr.ADS_CRITICAL_CHANCE)
		weapon_stats[Data.wattr.ACCURACY] = Data.get_attr(Data.wcls,weapon_name,Data.wattr.ADS_ACCURACY)
		weapon_stats[Data.wattr.MAX_SPREAD] = Data.get_attr(Data.wcls,weapon_name,Data.wattr.ADS_MAX_SPREAD)
		weapon_stats[Data.wattr.RECOIL_AMOUNT] = Data.get_attr(Data.wcls,weapon_name,Data.wattr.ADS_RECOIL_AMOUNT)
	
func prepare_next_shot():
	add_recoil(weapon_stats[Data.wattr.RECOIL_TIME],weapon_stats[Data.wattr.RECOIL_AMOUNT])
	weapon_state = States.PREPARING
	if is_ads_fire:
		await get_tree().create_timer(weapon_stats[Data.wattr.ADS_FIRE_RATE],false).timeout
	else:
		await get_tree().create_timer(weapon_stats[Data.wattr.FIRE_RATE],false).timeout
	if weapon_state != States.RELOADING and weapon_state != States.CHARGING:
		weapon_state = States.READY
	
