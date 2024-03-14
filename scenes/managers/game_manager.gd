extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@onready var spawn_manager_ref = get_tree().get_first_node_in_group("SpawnManager")

#chroma segments
var checkpoint_ref
var segment_ref
var rotation_at_checkpoint
var depth_at_checkpoint

var score = 0
var player_time_seconds = 300
var player_time_string = "00:00"

var altered_weapon_flat_stats = []
var altered_weapon_multiplied_stats = []


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.in_game = true
	
	altered_weapon_flat_stats.resize(Data.wattr.keys().size())
	altered_weapon_flat_stats.fill(0)
	altered_weapon_multiplied_stats.resize(Data.wattr.keys().size())
	altered_weapon_multiplied_stats.fill(1.0)


func _process(_delta):
	pass


func _on_timer_timeout():
	if not player_ref.is_training:
		player_time_seconds -= 1
		var mins = int(player_time_seconds) / 60
		var seconds = int(player_time_seconds) % 60
		player_time_string = Globals.convert_time_to_string(mins,seconds)
	
	if player_time_seconds <= 0:
		#game over
		get_tree().change_scene_to_file("res://interface/menus/main_menu.tscn")
