extends Node3D

@export_category("refs")
@export var start:Marker3D

@export_category("procedural_generation_params")
@export var enable = true
@export var initial_straight_speed_tubes = 5
@export var min_speed_tubes_per_chunk = 3
@export var max_speed_tubes_per_chunk = 10
@export var initial_chunks = 1
@export var max_segments = 20

var segments = []
var player_segment_index = 0
var segment_index = -1
var segment_rotation = 0
var reward_room_spawned = false
var segments_this_chunk = 0

enum segment_types{PLANE,CURVED_TUBE,STRAIGHT_TUBE,ARENA,CHROMA,REWARD}
enum dir{UP,LEFT,DOWN,RIGHT}
var plane = preload("res://scenes/segments/plane.tscn")
var curved_tube = preload("res://scenes/segments/speed_tubes/curved_speed_tube.tscn")
var straight_tube = preload("res://scenes/segments/speed_tubes/straight_speed_tube.tscn")
var arena = preload("res://scenes/segments/combat_arenas/combat_arena.tscn")
var chroma = preload("res://scenes/segments/shops/chroma_room.tscn")
var reward = preload("res://scenes/segments/shops/reward_room.tscn")

signal new_chunk(type)

func _ready():
	if enable:
		for i in range(initial_chunks):
			new_chunk.emit(segment_types.ARENA)

func _process(_delta):
	#spawn_next_chunk()
	pass

func spawn_next_chunk():
	if enable and segment_index!= -1 and player_segment_index == segment_index - segments_this_chunk:
		#if not max segments
		new_chunk.emit(segment_types.ARENA)
		#elif not reward_room_spawned:
		#	reward_room_spawned = true
		#	enable = false
		#	new_chunk.emit(segment_types.REWARD)

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
			segment.global_position.z = segment.up.global_position.z
			segment.global_rotation.y = segment.up.global_rotation.y
		1:
			segment.global_position.x = segment.left.global_position.x
			segment.global_rotation.y = segment.left.global_rotation.y
		2:
			segment.global_position.z = segment.down.global_position.z
			segment.global_rotation.y = segment.down.global_rotation.y
		3:
			segment.global_position.x = segment.right.global_position.x
			segment.global_rotation.y = segment.right.global_rotation.y
		
func add_y_rotation(angle):
	
	segment_rotation += angle
	if segment_rotation < 0:
		segment_rotation += 360
	if segment_rotation >= 360:
		segment_rotation -= 360
	
func create_segment(type:segment_types):
	var curr_segment
	match type:
		segment_types.PLANE:
			curr_segment = plane.instantiate()
		segment_types.CURVED_TUBE:
			curr_segment = curved_tube.instantiate()
			add_y_rotation(90)
		segment_types.STRAIGHT_TUBE:
			curr_segment = straight_tube.instantiate()
		segment_types.ARENA:
			curr_segment = arena.instantiate()
		segment_types.CHROMA:
			curr_segment = chroma.instantiate()
		segment_types.REWARD:
			curr_segment = reward.instantiate()
	if curr_segment!=null:
		curr_segment.type = type
		curr_segment.id = segment_index+1
		add_child(curr_segment)
		adjust_to_ideal_position(curr_segment,0,(segment_rotation/90)%4)
		print(segment_rotation," ",(segment_rotation/90)%4)
		#if segment_index != -1:
			#curr_segment.transform.basis = segments[segment_index].transform.basis
			#curr_segment.rotate_y(segment_rotation)
		#if type == segment_types.CURVED_TUBE:
			#add_y_rotation(90)
		segments.append(curr_segment)
		segment_index += 1
			
func get_segment_types(n,min = 1,max = 2):
	#even number of curved tubes cannot be together, odd is fine 
	#index of curved tube is 1
	if n == 0:
		return []
		
	var types = []
	for i in range(n):
		types.append(randi_range(min,max))
	
	types[0] = 2
	for i in range(n-2):
		var slice = types.slice(i, i+3)
		if slice[0] == slice[1]:
			types[i+1] = 2
		if slice[1] == slice[2]:
			types[i+2] = 2
	
	return types
	
func spawn_new_segments(with_type:segment_types = segment_types.ARENA):
	#speed tubes
	var num_speed_tubes = randi_range(min_speed_tubes_per_chunk,max_speed_tubes_per_chunk)
	var segment_types_to_spawn = get_segment_types(num_speed_tubes,1,2)
	for i in range(num_speed_tubes):
		match segment_types_to_spawn[i]:
			segment_types.CURVED_TUBE:
				create_segment(1)
			segment_types.STRAIGHT_TUBE:
				create_segment(2)
	#specific one
	#match with_type:
	#	segment_types.ARENA:
	#		create_segment(3)
	#	segment_types.CHROMA:
	#		create_segment(4)
	#	segment_types.REWARD:
	#		create_segment(5)
	#segments_this_chunk = num_speed_tubes + 1

func _on_new_chunk(type):
	spawn_new_segments(type)
