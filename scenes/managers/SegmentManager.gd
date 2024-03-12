extends Node3D

@onready var game_manager_ref = get_tree().get_first_node_in_group("GameManager")

@export_category("refs")
@export var start:Marker3D

@export_category("procedural_generation_params")
@export var enable = true
@export var initial_straight_speed_tubes = 5
@export var min_speed_tubes_per_chunk = 10
@export var max_speed_tubes_per_chunk = 15
@export var max_curved_per_depth = 3
@export var max_vertical_per_chunk = 2
@export var possible_chroma_per_chunk = 1
@export var max_chunks = 5
@export var player_starting_depth = 10
@export var depth_variance = 0.75
@export var segment_lifetime = 20
@export var segment_deletion_threshold = 5
@export var ignore_limits = false

@export var segments : Array[Node3D]
var player_segment_index = -1
var segment_index = -1
var segment_rotation = 0
var reward_room_spawned = false
var segments_this_chunk = 0
var num_chunks = 0
var initial_chunks = 2
var player_depth = player_starting_depth
var depth = player_starting_depth
var arena_index = initial_chunks

enum segment_types{PLANE,CURVED_TUBE,STRAIGHT_TUBE,VERTICAL_TUBE,CHROMA,ARENA,REWARD,MISC}
enum curved_tube_variants{RIGHT,LEFT}
enum seg_dir{UP,LEFT,DOWN,RIGHT}

var segment_scenes = {
	plane = preload("res://scenes/segments/plane.tscn"),
	curved_tube = {
		curved_tube_right = preload("res://scenes/segments/speed_tubes/curved_speed_tube_right.tscn"),
		curved_tube_left = preload("res://scenes/segments/speed_tubes/curved_speed_tube_left.tscn")
	},
	straight_tube = preload("res://scenes/segments/speed_tubes/straight_speed_tube.tscn"),
	vertical_tube = preload("res://scenes/segments/speed_tubes/vertical_speed_tube.tscn"),
	chroma = preload("res://scenes/segments/shops/chroma_room.tscn"),
	arena = preload("res://scenes/segments/combat_arenas/combat_arena.tscn"),
	reward = preload("res://scenes/segments/shops/reward_room.tscn"),
}
var door_scene = preload("res://scenes/segments/spawned_door.tscn")

signal new_chunk(chunk_type,at_index)

func _ready():
	if enable:
		for i in range(initial_chunks):
			new_chunk.emit(segment_types.ARENA)

func _process(_delta):
	destroy_past_segments()

func destroy_past_segments():
	for segment in segments:
		if segment.id + segment_deletion_threshold < player_segment_index:
			if segment.type != segment_types.CHROMA:
				segments.erase(segment)
				segment.destruct()
				segment_index = clampi(segment_index - 1,0,segments.size())
				player_segment_index = clampi(player_segment_index - 1,0,segments.size())
				for i in range(segments.size()):
					segments[i].id = i
			
				create_door(segments.filter(remove_chroma)[0])

func remove_chroma(segment):
	return segment.type != segment_types.CHROMA

func create_door(segment):
	if is_instance_valid(segment.segment_start):
		var this_door = door_scene.instantiate()
		segment.add_child(this_door)
		this_door.global_position = segment.segment_start.global_position
	
func reset_segments():
	for segment in segments:
		if segment.type!= segment_types.CHROMA:
			segment.destruct()
			segments.erase(segment)
	segments.clear()
	segments.append(game_manager_ref.segment_ref)
	game_manager_ref.segment_ref.id = 0
	create_door(game_manager_ref.segment_ref)	
	
	num_chunks -= 1
	segment_rotation = game_manager_ref.rotation_at_checkpoint
	player_depth = game_manager_ref.depth_at_checkpoint
	depth = game_manager_ref.depth_at_checkpoint
	player_segment_index = 0
	segment_index = 0		
	segments_this_chunk = 0		
	
	new_chunk.emit(segment_types.ARENA,0,1.0,true)
	
func destroy_behind_segment(_at_index):
	#legacy method / overcomplicates too much
	"""
	if segments.size() > at_index:
		for i in range(at_index,0,-1):
			var segment_to_delete = segments[i]
			if segment_to_delete.type != segment_types.CHROMA:
				segments.erase(segment_to_delete)
				segment_to_delete.destruct()
				segment_index = clampi(segment_index - 1,0,segments.size())
				player_segment_index = clampi(player_segment_index - 1,0,segments.size())
				for j in range(segments.size()):
					segments[j].id = j
	else:
		printerr("Segment index not found: ",at_index)
	"""
	pass
	
func get_current_segment_end_position(index) -> Vector3:
	if segment_index == -1:
		return start.global_position
	else:
		if segments[segment_index].type == segment_types.ARENA:
			return segments[segment_index].connection_end[index].global_position
		else:
			return segments[segment_index].connection_end[0].global_position

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
	
func create_segment(type:segment_types,end_index):
	var segment_type_index : String
	var segment_variant : int
	var curr_segment
	if segment_scenes[segment_scenes.keys()[type]] is Dictionary:
		var segment_variants = segment_scenes[segment_scenes.keys()[type]]
		match type:
			segment_types.CURVED_TUBE:
				segment_variant = randi_range(curved_tube_variants.RIGHT,curved_tube_variants.LEFT)
				curr_segment = segment_variants[segment_variants.keys()[segment_variant]].instantiate()
			
	else:
		segment_type_index = segment_scenes.keys()[type]
		curr_segment = segment_scenes[segment_type_index].instantiate()
	
	match type:
		segment_types.CURVED_TUBE:
			match segment_variant:
				curved_tube_variants.RIGHT:
					segment_rotation = add_y_rotation(segment_rotation,90)
				curved_tube_variants.LEFT:
					segment_rotation = add_y_rotation(segment_rotation,-90)
		segment_types.VERTICAL_TUBE:
			depth -= 1

	if curr_segment!=null:
		curr_segment.type = type
		curr_segment.id = segment_index+1
		if num_chunks == 0 and type == segment_types.ARENA:
			curr_segment.first = true
		#if num_chunks == 0 or type == segment_types.REWARD:
		#	curr_segment.timer = segment_lifetime * 99
		else:
			curr_segment.timer = segment_lifetime
		add_child(curr_segment)
		adjust_to_ideal_position(curr_segment,end_index,(segment_rotation/90)%4)
		segments.append(curr_segment)
		segment_index += 1
			
func get_segment_types(n,min_type = segment_types.CURVED_TUBE,max_type = segment_types.CHROMA,reduced_verticals = 1.0):
	#even number of curved tubes cannot be together, odd is fine 
	#index of curved tube is 1
	if n == 0:
		return []
		
	var types = []
	var max_verticals = max_vertical_per_chunk * reduced_verticals
	var curved_this_depth = 0
		
	for i in range(n):
		var type = randi_range(min_type,max_type)
		if type == segment_types.CURVED_TUBE and curved_this_depth < max_curved_per_depth:
			types.append(type)
			curved_this_depth += 1
		elif type == segment_types.VERTICAL_TUBE and types.count(segment_types.VERTICAL_TUBE) < max_verticals:
			types.append(type)
			curved_this_depth = 0
		else:
			if ignore_limits:
				types.append(randi_range(min_type,max_type))
			else:
				types.append(segment_types.STRAIGHT_TUBE)
	
	types[0] = segment_types.STRAIGHT_TUBE
	for i in range(n-2):
		var slice = types.slice(i, i+3)
		if slice[0] == slice[1] and slice[0] == segment_types.CURVED_TUBE:
			types[i+1] = segment_types.STRAIGHT_TUBE
		if slice[1] == slice[2] and slice[0] == segment_types.CURVED_TUBE:
			types[i+2] = segment_types.STRAIGHT_TUBE
	
	for i in range(possible_chroma_per_chunk):
		var chroma_position = randi_range(0,n-1)
		types[chroma_position] = segment_types.CHROMA
	
	return types

func spawn_new_segments(with_type:segment_types = segment_types.ARENA, with_index = 0, reduced_verticals = false):
	#first chunk
	if num_chunks == 0:
		for i in range(initial_straight_speed_tubes):
			create_segment(segment_types.STRAIGHT_TUBE,with_index)
		num_chunks += 1
	
	#reward chunk
	elif num_chunks == max_chunks:
		var num_speed_tubes = randi_range(min_speed_tubes_per_chunk,max_speed_tubes_per_chunk)
		var segment_types_to_spawn = get_segment_types(num_speed_tubes,segment_types.CURVED_TUBE,segment_types.VERTICAL_TUBE,reduced_verticals)
		for i in range(num_speed_tubes):
			create_segment(segment_types_to_spawn[i],with_index)
		create_segment(segment_types.REWARD,with_index)
		segments_this_chunk = num_speed_tubes + 1
		num_chunks += 1
	
	#other
	elif num_chunks < max_chunks:
		var num_speed_tubes = randi_range(min_speed_tubes_per_chunk,max_speed_tubes_per_chunk)
		var segment_types_to_spawn = get_segment_types(num_speed_tubes,segment_types.CURVED_TUBE,segment_types.VERTICAL_TUBE)
		for i in range(num_speed_tubes):
			create_segment(segment_types_to_spawn[i],with_index)
		create_segment(with_type,with_index)
		segments_this_chunk = num_speed_tubes + 1
		num_chunks += 1

func spawn_anomaly():
	#powerful monster called the watcher as a virus
	#not implemented
	pass
	
func _on_new_chunk(chunk_type = segment_types.MISC, at_index = 0, reduced_verticals = 1.0):
	match chunk_type:
		segment_types.ARENA:
			spawn_new_segments(segment_types.ARENA,at_index,reduced_verticals)
			arena_index += 1
		segment_types.MISC:
			spawn_new_segments(segment_types.ARENA,at_index,reduced_verticals)
			arena_index += 1
