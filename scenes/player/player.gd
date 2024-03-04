extends CharacterBody3D

@export_category("refs")
@export var camera_first_person:Camera3D
@export var camera_third_person:Camera3D
@export var weapon:Node3D
@export var weapon_socket:Marker3D
@export var target:Marker3D

var min_pitch = 50
var max_pitch = 50

var speed = 10.0
var base_speed = 10.0
var jump_velocity = 4.5
var movement_boost = 4
var inertia_slow = 0.1
var movement_ability = false

var enemies_defeated = 0
var arena_ref

var aberration_close = false
var aberration_warning = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass

func _input(event):
	if Input.is_action_just_pressed("primary_fire"):
		weapon.fire()
	
	#rotate based on mouse
	if event is InputEventMouseMotion and is_instance_valid(camera_first_person):
		var mouse_sensitivity = Globals.player_preferences["mouse_sensitivity"]
		if not is_on_floor():
			mouse_sensitivity *= 0.9
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_first_person.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_first_person.rotation.x = clampf(camera_first_person.rotation.x, -deg_to_rad(min_pitch), deg_to_rad(max_pitch))
		weapon_socket.rotation.z = camera_first_person.rotation.x

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_pressed("movement_ability"):
		speed = base_speed * movement_boost
		movement_ability = true
	else:
		speed = base_speed
		movement_ability = false
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction
	if movement_ability:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
