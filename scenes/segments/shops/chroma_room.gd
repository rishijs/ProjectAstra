extends "res://scenes/segments/segment.gd"

@export var connection_start:Marker3D
@export var connection_end:Array[Marker3D]
@export var door:Area3D

func _ready():
	super()


func _process(delta):
	super(delta)


func _on_segment_entry_body_entered(body):
	if body == player_ref:
		segment_manager_ref.player_segment_index = id


func _on_segment_door_body_entered(body):
	if body == player_ref:
		segment_manager_ref.new_chunk.emit(randi_range(3,4))
		door.queue_free()
		
