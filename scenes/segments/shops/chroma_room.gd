extends "res://scenes/segments/segment.gd"

@export var connection_end:Array[Marker3D]
@export var door:Area3D

func _ready():
	super()


func _process(delta):
	super(delta)

func on_timer_timeout():
	super()

func update_on_entry():
	super()
	
func _on_segment_entry_body_entered(body):
	if body == player_ref:
		update_on_entry()


func _on_segment_door_body_entered(body):
	if body == player_ref:
		if segment_manager_ref.enable:
			segment_manager_ref.new_chunk.emit()
		door.queue_free()
		


func _on_lifetime_timeout():
	on_timer_timeout()
