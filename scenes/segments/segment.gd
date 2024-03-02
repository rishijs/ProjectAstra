extends Node

@onready var segment_manager_ref = get_tree().get_first_node_in_group("SegmentManager")
@onready var player_ref = get_tree().get_first_node_in_group("Player")

@export var spawners:Array[Node3D]

var id:int

func _ready():
	pass


func _process(_delta):
	pass
