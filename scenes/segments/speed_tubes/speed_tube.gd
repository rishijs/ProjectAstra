extends "res://scenes/segments/segment.gd"

@export_category("connections")
@export var connection_end:Array[Marker3D]

func _ready():
	super()

func _process(delta):
	super(delta)

func _on_segment_entry_cr_body_entered(body):
	if body == player_ref:
		update_on_entry()	
func _on_lifetime_cr_timeout():
	on_timer_timeout()


func _on_segment_entry_s_body_entered(body):
	if body == player_ref:
		update_on_entry()
func _on_lifetime_s_timeout():
	on_timer_timeout()


func _on_segment_entry_cl_body_entered(body):
	if body == player_ref:
		update_on_entry()
func _on_lifetime_cl_timeout():
	on_timer_timeout()


func _on_segment_entry_v_body_entered(body):
	if body == player_ref:
		update_on_entry()
func _on_lifetime_v_timeout():
	on_timer_timeout()
