extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@export var teleport_location : Marker3D

func _ready():
	pass


func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body == player_ref and player_ref.is_training:
		player_ref.global_position = teleport_location.global_position
		player_ref.is_training = false
		player_ref.active_weapon_index = 0
		player_ref.swap_weapons(0)
