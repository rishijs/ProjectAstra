extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@export var teleport_location : Marker3D

func _ready():
	pass


func _process(_delta):
	pass


func _on_area_3d_body_entered(body):
	if body == player_ref:
		player_ref.global_position = teleport_location.global_position
		player_ref.is_training = true
		
