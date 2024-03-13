extends "res://scenes/segments/segment.gd"

@export_category("connections")
@export var connection_end:Array[Marker3D]

func _ready():
	super()
	spawn_spawners()

func _process(delta):
	super(delta)
	if id == 0 and segment_manager_ref.player_segment_index > 2:
		%SpawnedDoor.enable_col()

func _on_segment_entry_cr_body_entered(body):
	if body == player_ref:
		update_on_entry()	
func _on_segment_exit_cr_body_entered(body):
	if body == player_ref:
		update_on_exit()
func _on_lifetime_cr_timeout():
	on_timer_timeout()


func _on_segment_entry_s_body_entered(body):
	if body == player_ref:
		update_on_entry()
func _on_segment_exit_s_body_entered(body):
	if body == player_ref:
		update_on_exit()
func _on_lifetime_s_timeout():
	on_timer_timeout()


func _on_segment_entry_cl_body_entered(body):
	if body == player_ref:
		update_on_entry()
func _on_segment_exit_cl_body_entered(body):
	if body == player_ref:
		update_on_exit()
func _on_lifetime_cl_timeout():
	on_timer_timeout()


func _on_segment_entry_v_body_entered(body):
	if body == player_ref:
		update_on_entry()
		player_ref.gravity += 100
func _on_segment_exit_v_body_entered(body):
	if body == player_ref:
		update_on_exit()
		player_ref.gravity -= 100
func _on_lifetime_v_timeout():
	on_timer_timeout()
