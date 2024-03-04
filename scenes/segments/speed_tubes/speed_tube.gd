extends "res://scenes/segments/segment.gd"

@export_category("connections")
@export var connection_end:Array[Marker3D]

func _ready():
	super()


func _process(delta):
	super(delta)


func _on_segment_entry_body_entered(body):
	if body == player_ref:
		segment_manager_ref.player_segment_index = id
		segment_manager_ref.player_depth = depth
