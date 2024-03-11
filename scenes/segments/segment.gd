extends Node

@onready var segment_manager_ref = get_tree().get_first_node_in_group("SegmentManager")
@onready var spawn_manager_ref = get_tree().get_first_node_in_group("SpawnManager")
@onready var player_ref = get_tree().get_first_node_in_group("Player")


@export var inactive_segment:bool = false

@export var spawners:Array[Node3D]
@export var timer_node : Timer
@export var time_multiplier : float

@export_category("pivots")
@export var up : Marker3D
@export var left : Marker3D
@export var down : Marker3D
@export var right : Marker3D

var id:int
var type:int
var depth:int
var timer:float

func _ready():
	pass

func destruct():
	await get_tree().create_timer(1,false).timeout
	for spawner in spawners:
		spawn_manager_ref.spawners.erase(spawner)
	call_deferred("queue_free")

func update_on_entry():
	if not inactive_segment:
		segment_manager_ref.player_segment_index = id
		segment_manager_ref.player_depth = depth
		timer_node.start()
		player_ref.can_use_movement_ability = true

func update_on_exit():
	if not inactive_segment:
		segment_manager_ref.player_segment_index = id+1
		
func _process(_delta):
	pass

func on_timer_timeout():
	#if segment_manager_ref.segments[segment_manager_ref.player_segment_index].id == id:
	timer -= 1
	if timer == 0:
		timer_node.paused = true
		segment_manager_ref.destroy_behind_segment(id)
