extends Node3D

@export_category("refs")
@export var start:Marker3D

@export_category("procedural_generation_params")
@export var enable = true
@export var initial_straight_speed_tubes = 5
@export var min_speed_tubes_per_chunk = 10
@export var max_speed_tubes_per_chunk = 15
@export var max_curved_per_chunk = 3
@export var max_vertical_per_chunk = 2
@export var initial_chunks = 2
@export var max_chunks = 5
@export var segment_deletion_threshold = 5
@export var player_starting_depth = 10

var segments = []
var player_segment_index = 0
var segment_index = -1
var segment_rotation = 0
var reward_room_spawned = false
var segments_this_chunk = 0
var num_chunks = 0
var player_depth = player_starting_depth
var depth = player_starting_depth

enum segment_types{PLANE,CURVED_TUBE,STRAIGHT_TUBE,VERTICAL_TUBE,ARENA,CHROMA,REWARD}
enum seg_dir{UP,LEFT,DOWN,RIGHT}

var segment_scenes = {
	plane = preload("res://scenes/segments/plane.tscn"),
	curved_tube = preload("res://scenes/segments/speed_tubes/curved_speed_tube.tscn"),
	straight_tube = preload("res://scenes/segments/speed_tubes/straight_speed_tube.tscn"),
	vertical_tube = preload("res://scenes/segments/speed_tubes/vertical_speed_tube.tscn"),
	arena = preload("res://scenes/segments/combat_arenas/combat_arena.tscn"),
	chroma = preload("res://scenes/segments/shops/chroma_room.tscn"),
	reward = preload("res://scenes/segments/shops/reward_room.tscn"),
}

signal new_chunk(chunk_type)

func _ready():
	if enable:
		for i in range(initial_chunks):
			new_chunk.emit("arena")

func _process(_delta):
	destroy_past_chunks()

func destroy_past_chunks():
	for segment in segments:
		if segment.id + segment_deletion_threshold < player_segment_index:
			segments.erase(segment)
			segment.destruct()
			segment_index -= 1
			player_segment_index -= 1
			for i in range(segments.size()):
				segments[i].id = i


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

func adjust_to_ideal_position(segment,index,dir):
	segment.global_position = get_current_segment_end_position(index)
	match dir:
		0:
			segment.global_position = segment.up.global_position
			segment.global_rotation.y = segment.up.global_rotation.y
		1:
			segment.global_position = segment.left.global_position
			segment.global_rotation.y = segment.left.global_rotation.y
		2:
			segment.global_position = segment.down.global_position
			segment.global_rotation.y = segment.down.global_rotation.y
		3:
			segment.global_position = segment.right.global_position
			segment.global_rotation.y = segment.right.global_rotation.y
		
func add_y_rotation(value,angle):
	value += angle
	if value < 0:
		value += 360
	if value >= 360:
		value -= 360
	return value
	
func create_segment(type:segment_types):
	var curr_segment = segment_scenes[segment_scenes.keys()[type]].instantiate()
	
	match type:
		segment_types.CURVED_TUBE:
			segment_rotation = add_y_rotation(segment_rotation,90)
		segment_types.VERTICAL_TUBE:
			depth -= 1

	if curr_segment!=null:
		curr_segment.type = type
		curr_segment.id = segment_index+1
		add_child(curr_segment)
		adjust_to_ideal_position(curr_segment,0,(segment_rotation/90)%4)
		segments.append(curr_segment)
		segment_index += 1
			
func get_segment_types(n,min_type = segment_types.CURVED_TUBE,max_type = segment_types.VERTICAL_TUBE):
	#even number of curved tubes cannot be together, odd is fine 
	#index of curved tube is 1
	if n == 0:
		return []
		
	var types = []
	for i in range(n):
		var type = randi_range(min_type,max_type)
		if type == segment_types.CURVED_TUBE and types.count(segment_types.CURVED_TUBE) < max_curved_per_chunk:
			types.append(type)
		elif type == segment_types.VERTICAL_TUBE and types.count(segment_types.VERTICAL_TUBE) < max_vertical_per_chunk:
			types.append(type)
		else:
			types.append(segment_types.STRAIGHT_TUBE)
	
	types[0] = segment_types.STRAIGHT_TUBE
	for i in range(n-2):
		var slice = types.slice(i, i+3)
		if slice[0] == slice[1] and slice[0] == segment_types.CURVED_TUBE:
			types[i+1] = segment_types.STRAIGHT_TUBE
		if slice[1] == slice[2] and slice[0] == segment_types.CURVED_TUBE:
			types[i+2] = segment_types.STRAIGHT_TUBE
	
	return types

func spawn_new_segments(with_type:segment_types = segment_types.ARENA):
	#first chunk
	if num_chunks == 0:
		for i in range(initial_straight_speed_tubes):
			create_segment(segment_types.STRAIGHT_TUBE)
		num_chunks += 1
	
	#reward chunk
	elif num_chunks == max_chunks:
		var num_speed_tubes = randi_range(min_speed_tubes_per_chunk,max_speed_tubes_per_chunk)
		var segment_types_to_spawn = get_segment_types(num_speed_tubes,segment_types.CURVED_TUBE,segment_types.VERTICAL_TUBE)
		for i in range(num_speed_tubes):
			create_segment(segment_types_to_spawn[i])
		create_segment(segment_types.REWARD)
		segments_this_chunk = num_speed_tubes + 1
		num_chunks += 1
	
	#other
	elif num_chunks < max_chunks:
		var num_speed_tubes = randi_range(min_speed_tubes_per_chunk,max_speed_tubes_per_chunk)
		var segment_types_to_spawn = get_segment_types(num_speed_tubes,segment_types.CURVED_TUBE,segment_types.VERTICAL_TUBE)
		for i in range(num_speed_tubes):
			create_segment(segment_types_to_spawn[i])
		create_segment(with_type)
		segments_this_chunk = num_speed_tubes + 1
		num_chunks += 1

func _on_new_chunk(chunk_type = "misc"):
	match chunk_type:
		"arena":
			spawn_new_segments(segment_types.ARENA)
		"misc":
			spawn_new_segments(randi_range(segment_types.ARENA,segment_types.CHROMA))
