extends CanvasLayer

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@onready var segment_manager_ref = get_tree().get_first_node_in_group("SegmentManager")
@onready var game_manager_ref = get_tree().get_first_node_in_group("GameManager")

@export var elims_required_initial_y_pos = 190
@export var elims_required_target_y_pos = 20
var moving = false

@export_category("refs")
@export var fps_text:Label
@export var time_text:Label
@export var objective_text:Label
@export var magazine_text:Label
@export var reloading_text:Label
@export var score_text:Label
@export var player_healthbar:ProgressBar
@export var player_energy:ProgressBar
@export var arena_elims:Label
@export var aberration_container:PanelContainer
@export var aberration_name:Label
@export var aberration_description:Label
@export var simulation_progress:ProgressBar
@export var time_change_text:Label

signal aberration(ab_name,ab_desc,ab_type)
signal time_change(amount)

func _ready():
	player_healthbar.max_value = player_ref.max_health
	player_healthbar.value = player_ref.health
	player_energy.max_value = player_ref.max_movement_energy
	player_energy.value = player_ref.movement_energy
	simulation_progress.max_value = segment_manager_ref.max_chunks
	simulation_progress.value = clampi(segment_manager_ref.arena_index,0, segment_manager_ref.max_chunks)


func _process(_delta):
	pass


func _on_update_timeout():
	fps_text.text = "%d FPS" % Engine.get_frames_per_second()
	time_text.text = "%s" % game_manager_ref.player_time_string
	
	if is_instance_valid(segment_manager_ref):
		"""
		var segment_time_left = segment_manager_ref.segments[segment_manager_ref.player_segment_index].timer
		if segment_manager_ref.player_segment_index == -1:
			segment_time_text.hide()
		elif segment_time_left >= 99:
			segment_time_text.hide()
		elif segment_time_left != null:
			segment_time_text.show()
			segment_time_text.text = "%d SECONDS TILL SEGMENT DISINTEGRATION" % segment_time_left
		"""
		#segment_id_text.text = "ID: %d" % segment_manager_ref.player_segment_index
	
	objective_text.text = "%d ELIM(S) TILL CHROMA SWAP" % player_ref.defeats_till_chroma_swap
	if player_ref.weapons[player_ref.active_weapon_index].magazine != null:
		magazine_text.text = "%d" % player_ref.weapons[player_ref.active_weapon_index].magazine
	else:
		magazine_text.hide()
	
	if player_ref.weapons[player_ref.active_weapon_index].weapon_state == player_ref.weapons[player_ref.active_weapon_index].States.RELOADING:
		reloading_text.show()
	else:
		reloading_text.hide()
	
	if player_ref.arena_ref != null:
		arena_elims.show()
		%objective_info.show()
		arena_elims.text = "%d TARGETS REMAINING" % player_ref.arena_ref.defeats_required
		if not moving:
			move_arena_text()
	else:
		arena_elims.hide()
		%objective_info.hide()
		%objective_info.position.y = elims_required_initial_y_pos
		moving = false
	
	player_healthbar.value = player_ref.health
	player_energy.value = player_ref.movement_energy
	if player_energy.value < 40:
		player_energy.modulate = Color.BLUE
	else:
		player_energy.modulate = Color.WHITE
	simulation_progress.value = clampi(segment_manager_ref.arena_index,0, segment_manager_ref.max_chunks)
	
	score_text.text = "SCORE: %d" % game_manager_ref.score

func move_arena_text():
	moving = true
	await get_tree().create_timer(2.0,false).timeout
	%objective_info.position.y = elims_required_target_y_pos
	
func _on_aberration(ab_name, ab_desc, ab_type):
	aberration_container.show()
	aberration_name.text = ab_name + "Type: " + ab_type
	aberration_description.text = ab_desc
	if ab_type == "unstable":
		aberration_name.modulate = Color.LIGHT_CORAL
	if ab_type == "stable":
		aberration_name.modulate = Color.LIGHT_YELLOW
	if ab_type == "successful":
		aberration_name.modulate = Color.LIGHT_GREEN
	if ab_type == "learned":
		aberration_name.modulate = Color.LIGHT_SKY_BLUE
	%Info.volume_db = 0
	%Info.pitch_scale = randf_range(0.8,1.2)
	%Info.play()
	await get_tree().create_timer(5.0,false).timeout
	aberration_container.hide()
	


func _on_time_change(amount):
	time_change_text.text = "%d SECONDS"%amount
	if amount < 0:
		time_change_text.modulate = Color.RED
	else:
		time_change_text.modulate = Color.GREEN
	%Info.pitch_scale = randf_range(0.8,1.2)
	%Info.volume_db = -10
	%Info.play()
	time_change_text.show()
	await get_tree().create_timer(2.0,false).timeout
	time_change_text.hide()
