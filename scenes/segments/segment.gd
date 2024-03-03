extends Node

@onready var segment_manager_ref = get_tree().get_first_node_in_group("SegmentManager")
@onready var spawn_manager_ref = get_tree().get_first_node_in_group("SpawnManager")
@onready var player_ref = get_tree().get_first_node_in_group("Player")

@export var spawners:Array[Node3D]

@export_category("pivots")
@export var up : Marker3D
@export var left : Marker3D
@export var down : Marker3D
@export var right : Marker3D

var id:int
var type:int
var depth:int

func _ready():
	pass

func destruct():
	await get_tree().create_timer(1,false).timeout
	for spawner in spawners:
		spawn_manager_ref.spawners.erase(spawner)
	call_deferred("queue_free")

func _process(_delta):
	pass
