extends CharacterBody3D

@onready var post_process = get_tree().get_first_node_in_group("PostProcess");
@onready var game_manager_ref = get_tree().get_first_node_in_group("GameManager");
@onready var segment_manager_ref = get_tree().get_first_node_in_group("SegmentManager");
@onready var interface_ref = get_tree().get_first_node_in_group("Interface")
@onready var aberrations = Data.all_data[Data.abcls]

@export_category("refs")
@export var camera_first_person:Camera3D
@export var weapons:Array[Node3D]
@export var weapon_socket:Marker3D

#negative
var min_pitch = 25
#positive
var max_pitch = 55

var speed = 20.0
var base_speed = 20.0
var jump_velocity = 4.5

var movement_boost = 0
var min_movement_boost = 20
var max_movement_boost = base_speed * 4
var movement_ability_time = 0

var max_movement_energy = 100
var movement_energy = 100
var movement_energy_consumption_rate = 0.5
var movement_energy_regen_rate_base = 0.1
var movement_energy_regen_rate_inertia = 0.0075

var base_sensitivity = Globals.player_preferences["mouse_sensitivity"]
var strafe_sensitivity = base_sensitivity
var strafe_penalty = 1.0
var max_strafe_penalty = 0.1
var max_mouse_sense_reduction = 2

var speed_penalty_base = 0.2
var speed_penalty = 1

var movement_ability = false
var can_use_movement_ability = true

var is_training = false

var max_health = 100
var health = 100
var enemies_defeated = 0
var arena_ref
var active_weapon_index = 0

var base_defeats_till_chroma_swap = 3
var defeats_till_chroma_swap = 3
var num_swaps = 0
var weapon_aberration_chance = 0.05

var aberration_close = false
var aberration_warning = false

var sprint_guide = false
var altered_guide = false
var checkpoint_guide = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var chroma_particles = preload("res://art/vfx/chromatic_particles.tscn")

signal hit
signal enemy_defeated

func _ready():
	swap_weapons(active_weapon_index)
		
	%Ambience.play()

func _input(event):
	
	if Input.is_action_just_pressed("pause"):
		get_tree().get_first_node_in_group("PauseMenu").show()
		get_tree().get_first_node_in_group("Interface").hide()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		
	if Input.is_action_just_pressed("debug_kill"):
		hit.emit(max_health)
		
	if Input.is_action_just_pressed("training_swap") and is_training:
		active_weapon_index += 1
		if active_weapon_index == weapons.size():
			active_weapon_index = 0
		swap_weapons(active_weapon_index)
	
	if Input.is_action_just_pressed("movement_ability") and can_use_movement_ability:
		movement_ability = true
		%SprintActivated.play()
	
	if Input.is_action_just_released("movement_ability"):
		movement_ability = false
		
	if Input.is_action_just_pressed("primary_fire"):
		weapons[active_weapon_index].fire()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("ads_fire"):
		weapons[active_weapon_index].fire()
	
	if Input.is_action_just_pressed("swap_red") and is_training:
		active_weapon_index = 0
		swap_weapons(active_weapon_index)
	
	if Input.is_action_just_pressed("swap_blue") and is_training:
		active_weapon_index = 1
		swap_weapons(active_weapon_index)
	
	if Input.is_action_just_pressed("swap_green") and is_training:
		active_weapon_index = 2
		swap_weapons(active_weapon_index)
	
	if Input.is_action_just_pressed("swap_white") and is_training:
		active_weapon_index = 3
		swap_weapons(active_weapon_index)
	
	if Input.is_action_just_pressed("reload"):
		if not Input.is_action_pressed("primary_fire") and not Input.is_action_pressed("ads_fire"):
			if weapons[active_weapon_index].weapon_state != weapons[active_weapon_index].States.RELOADING:
				weapons[active_weapon_index].reload()
				if active_weapon_index == Data.chromas.ARC:
					weapons[active_weapon_index].cancel_reload = false
	
	#rotate based on mouse
	if event is InputEventMouseMotion and is_instance_valid(camera_first_person):
		var mouse_sensitivity = strafe_sensitivity
		if not is_on_floor():
			mouse_sensitivity *= 0.9
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_first_person.rotate_x(-event.relative.y * mouse_sensitivity)
		if is_on_floor:
			camera_first_person.rotation.x = clampf(camera_first_person.rotation.x, -deg_to_rad(min_pitch), deg_to_rad(max_pitch))
		weapon_socket.rotation.z = camera_first_person.rotation.x
		
		if is_on_floor():
			rotation.z = 0

func _process(delta):
	
	if movement_energy > 0:
		can_use_movement_ability = true
	else:
		can_use_movement_ability = false
		movement_ability = false
		
	if movement_ability:
		movement_ability_time += delta
		movement_boost = clamp(min_movement_boost + pow(movement_ability_time,3),0,max_movement_boost)
		strafe_penalty = clamp(1-movement_ability_time*0.2,max_strafe_penalty,1)
		strafe_sensitivity = clamp(base_sensitivity-movement_ability_time*0.005,base_sensitivity/max_mouse_sense_reduction,base_sensitivity)
		movement_energy = clampf((movement_energy+(movement_energy_regen_rate_inertia*speed*delta*100)-(movement_energy_consumption_rate*delta*100)),0,max_movement_energy)
	else:
		strafe_sensitivity = base_sensitivity
		movement_ability_time = 0
		movement_boost = 0
		strafe_penalty = 1
		movement_energy = clampf(movement_energy+movement_energy_regen_rate_base,0,max_movement_energy)
	
	if camera_first_person.rotation.x < -deg_to_rad(min_pitch):
		camera_first_person.rotation.x = -deg_to_rad(min_pitch)
	elif camera_first_person.rotation.x > deg_to_rad(max_pitch):
		camera_first_person.rotation.x = deg_to_rad(max_pitch)
	
	camera_first_person.rotation.y = 0
	
	if segment_manager_ref.player_segment_index >= 1 and not sprint_guide and Globals.prestige == 1:
		sprint_guide = true
		interface_ref.show_guide.emit(0)
				
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_pressed("primary_fire"):
		speed_penalty = speed_penalty_base
	else:
		speed_penalty = 1
	
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction
	if movement_ability:
		direction = (transform.basis * Vector3(input_dir.x*strafe_penalty, 0, input_dir.y)).normalized()
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if direction:
		speed = base_speed + movement_boost
		velocity.x = direction.x * speed * delta * 100
		velocity.z = direction.z * speed * delta * 100

	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		movement_ability = false

	move_and_slide()

func swap_weapons(weapon_index):
	for weapon in weapons:
		weapon.hide()
		weapon.current_weapon = false
	
	if weapons.size() > weapon_index:
		weapons[weapon_index].show()
		weapons[weapon_index].current_weapon = true
		weapons[weapon_index].refill()
		post_process.weapon_swapped.emit(weapon_index)
	
	if num_swaps > 1:
		%ChromaSwap.play()

func reset_at_checkpoint():
	global_position = game_manager_ref.checkpoint_ref.global_position
	game_manager_ref.segment_ref.door.show()
	segment_manager_ref.reset_segments()
	
	game_manager_ref.segment_ref.doorLock.show()
	game_manager_ref.segment_ref.doorLockCol.disabled = false

func _on_hit(damage):
	health = clampf(health-damage,0,max_health)
	if health == 0:
		if game_manager_ref.checkpoint_ref != null:
			reset_at_checkpoint()
			health = max_health
		else:
			#game over
			get_tree().get_first_node_in_group("Failure").show()

func aberrate_weapon(type = "none"):
	#random buff or debuff on going through an arena gate
	match type:
		"unstable":
			validate_aberration(Data.unstable_aberrations[randi_range(0,len(Data.unstable_aberrations)-1)])
		"stable":
			validate_aberration(Data.stable_aberrations[randi_range(0,len(Data.stable_aberrations)-1)])
		"successful":
			validate_aberration(Data.successful_aberrations[randi_range(0,len(Data.successful_aberrations)-1)])
		"none":
			#no effect
			pass

func validate_aberration(index,learned = false):
	var aberration_name = aberrations.keys()[index]
	var multiplied_effect = Data.get_attr(Data.abcls,aberration_name,Data.abattr.MULTIPLIED_EFFECT)
	var flat_effect = Data.get_attr(Data.abcls,aberration_name,Data.abattr.FLAT_EFFECT)
	var id = Data.get_attr(Data.abcls,aberration_name,Data.abattr.ID)
	var description = Data.get_attr(Data.abcls,aberration_name,Data.abattr.DESCRIPTION)
	game_manager_ref.altered_weapon_flat_stats[id] += flat_effect
	game_manager_ref.altered_weapon_multiplied_stats[id] *= multiplied_effect

	weapons[active_weapon_index].initialize_weapon()
	if learned:
		interface_ref.aberration.emit(aberration_name,description,"learned")
	else:
		interface_ref.aberration.emit(aberration_name,description,Data.get_attr(Data.abcls,aberration_name,Data.abattr.STABILITY))
	
	if not altered_guide and Globals.prestige == 1:
		altered_guide = true
		interface_ref.show_guide.emit(3)
		
func get_next_weapon():
	active_weapon_index += 1
	if active_weapon_index == weapons.size():
		active_weapon_index = 0
	num_swaps += 1
			
func _on_enemy_defeated():
	if not is_training:
		if is_instance_valid(arena_ref):
			if arena_ref.defeats_required > 0:
				arena_ref.defeats_required -= 1
		enemies_defeated += 1
		game_manager_ref.score += 50
		game_manager_ref.player_time_seconds += 3
		interface_ref.time_change.emit(3)
		defeats_till_chroma_swap -= 1
		if defeats_till_chroma_swap == 0:
			if num_swaps == 0 and Globals.prestige == 1:
				interface_ref.show_guide.emit(1)
			get_next_weapon()
			swap_weapons(active_weapon_index)
			game_manager_ref.score += 500
			defeats_till_chroma_swap = base_defeats_till_chroma_swap
		else:
			var chance = randf_range(0.01,1.0)
			if chance <= weapon_aberration_chance:
				aberrate_weapon("stable")
