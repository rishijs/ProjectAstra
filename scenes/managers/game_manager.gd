extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@onready var spawn_manager_ref = get_tree().get_first_node_in_group("SpawnManager")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.in_game = true


func _process(_delta):
	pass
