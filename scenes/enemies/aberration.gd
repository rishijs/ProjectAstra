extends CharacterBody3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@export var speed = 10
@export var ramp_interval = 1
@export var ramp = 0.5

func _ready():
	%Ramp.wait_time = ramp_interval
	
	
func _physics_process(_delta):
	if is_instance_valid(player_ref):
		velocity = global_position.direction_to(player_ref.global_position) * speed
	move_and_slide()


func _on_close_body_entered(body):
	if body == player_ref:
		player_ref.aberration_close = true


func _on_warning_body_entered(body):
	if body == player_ref:
		player_ref.aberration_close = true


func _on_close_body_exited(body):
	if body == player_ref:
		player_ref.aberration_close = false


func _on_warning_body_exited(body):
	if body == player_ref:
		player_ref.aberration_warning = false


func _on_kill_body_entered(body):
	if body == player_ref:
		SceneLoader.load_scene("res://interface/menus/main_menu.tscn", true)
		SceneLoader.change_scene_to_loading_screen()


func _on_ramp_timeout():
	speed += ramp
