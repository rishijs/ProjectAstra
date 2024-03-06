extends CanvasLayer

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@onready var segment_manager_ref = get_tree().get_first_node_in_group("SegmentManager")

@export_category("refs")
@export var fps_text:Label
@export var time_text:Label
@export var segment_time_text:Label
@export var objective_text:Label
@export var segment_id_text:Label
@export var magazine_text:Label
@export var reloading_text:Label
@export var swaps_text:Label

func _ready():
	pass


func _process(_delta):
	pass


func _on_update_timeout():
	fps_text.text = "%d FPS" % Engine.get_frames_per_second()
	time_text.text = "%s" % Globals.time_string
	
	if is_instance_valid(segment_manager_ref):
		var segment_time_left = segment_manager_ref.segments[segment_manager_ref.player_segment_index].timer
		if segment_manager_ref.player_segment_index == -1:
			segment_time_text.hide()
		elif segment_time_left >= 99:
			segment_time_text.hide()
		elif segment_time_left != null:
			segment_time_text.text = "%d SECONDS TILL SEGMENT DISINTEGRATION" % segment_time_left
		else:
			segment_time_text.text = "N/A"
		segment_id_text.text = "ID: %d" % segment_manager_ref.player_segment_index
	
	objective_text.text = "%d ELIM(S) TILL CHROMA SWAP" % player_ref.defeats_till_chroma_swap
	if player_ref.weapons[player_ref.active_weapon_index].magazine != null:
		magazine_text.text = "%d" % player_ref.weapons[player_ref.active_weapon_index].magazine
	else:
		magazine_text.hide()
	
	if player_ref.weapons[player_ref.active_weapon_index].weapon_state == player_ref.weapons[player_ref.active_weapon_index].States.RELOADING:
		reloading_text.show()
	else:
		reloading_text.hide()
	
	swaps_text.text = "SCORE: %d" % player_ref.num_swaps
