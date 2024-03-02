extends Node3D

@export_category("refs")
@export var start:Marker3D

@export_category("procedural_generation_params")
@export var enable = true
@export var segments_per_chunk = 5
@export var initial_chunks = 2
@export var max_segments = 20

var segments = []
var player_segment_index = 0
var segment_index = -1
var segment_rotation = 0
var reward_room_spawned = false

enum segment_types{PLANE,CURVED_TUBE,STRAIGHT_TUBE,ARENA,CHROMA,REWARD}
var plane = preload("res://scenes/segments/plane.tscn")
var curved_tube = preload("res://scenes/segments/speed_tubes/curved_speed_tube.tscn")
var straight_tube = preload("res://scenes/segments/speed_tubes/straight_speed_tube.tscn")
var arena = preload("res://scenes/segments/combat_arenas/combat_arena.tscn")
var chroma = preload("res://scenes/segments/shops/chroma_room.tscn")
var reward = preload("res://scenes/segments/shops/reward_room.tscn")

signal new_chunk

func _ready():
	if enable:
		for i in range(initial_chunks):
			new_chunk.emit()

func _process(_delta):
	if enable and segment_index!= -1 and player_segment_index == segment_index - segments_per_chunk:
		if segment_index < max_segments:
			new_chunk.emit()
		elif not reward_room_spawned:
			reward_room_spawned = true
			enable = false
			create_segment(5)

func get_current_segment_start_position() -> Vector3:
	if segment_index == -1:
		return start.global_position
	else:
		return segments[segment_index].connection_start.global_position
	
func get_current_segment_end_position(index) -> Vector3:
	if segment_index == -1:
		return start.global_position
	else:
		return segments[segment_index].connection_end[index].global_position
		
	
func create_segment(type:segment_types):
	var curr_segment
	match type:
		segment_types.PLANE:
			curr_segment = plane.instantiate()
		segment_types.CURVED_TUBE:
			curr_segment = curved_tube.instantiate()
			segment_rotation -= 90
			if segment_rotation < 0:
				segment_rotation += 360
		segment_types.STRAIGHT_TUBE:
			curr_segment = straight_tube.instantiate()
		segment_types.ARENA:
			curr_segment = arena.instantiate()
		segment_types.CHROMA:
			curr_segment = chroma.instantiate()
		segment_types.REWARD:
			curr_segment = reward.instantiate()
	if curr_segment!=null:
		curr_segment.id = segment_index+1
		add_child(curr_segment)
		curr_segment.global_position = get_current_segment_end_position(0)
		segments.append(curr_segment)
			
	
func spawn_new_segments():
	for i in range(segments_per_chunk):
		create_segment(randi_range(2,4))
		segment_index += 1

func _on_new_chunk():
	spawn_new_segments()
