extends "res://scenes/segments/segment.gd"

@export var connection_end:Array[Marker3D]
@export var defeats_required = 1

@export_category("doors")
@export var doorE:StaticBody3D
@export var doorC:StaticBody3D
@export var doorL:StaticBody3D
@export var doorR:StaticBody3D

var locked = false

func _ready():
	super()
	init_arena()

func on_timer_timeout():
	super()

func update_on_entry():
	super()
	
func _process(delta):
	super(delta)
	if locked:
		%EntryDoorCol.disabled = false
	unlock_arena()


func _on_segment_entry_body_entered(body):
	if body == player_ref:
		update_on_entry()
		timer_node.start()
		if defeats_required > 0:
			lock_arena()

func init_arena():
	doorE.hide()
	%EntryDoorCol.disabled = true

func lock_arena():
	locked = true
	doorE.show()
	player_ref.arena_ref = self

func unlock_arena():
	if defeats_required == 0 and locked:
		doorE.queue_free()
		player_ref.arena_ref = null
		locked = false
		%CL.show()
		%LL.show()
		%RL.show()


func _on_segment_door_r_body_entered(body):
	#higher diff right
	if body == player_ref and defeats_required == 0:
		segment_manager_ref.segment_rotation = segment_manager_ref.add_y_rotation(segment_manager_ref.segment_rotation,-90)
		if segment_manager_ref.enable:
			segment_manager_ref.new_chunk.emit(segment_manager_ref.segment_types.MISC,2,1+segment_manager_ref.depth_variance)
		doorR.call_deferred("queue_free")


func _on_segment_door_l_body_entered(body):
	#lower diff left
	if body == player_ref and defeats_required == 0:
		segment_manager_ref.segment_rotation = segment_manager_ref.add_y_rotation(segment_manager_ref.segment_rotation,90)
		if segment_manager_ref.enable:
			segment_manager_ref.new_chunk.emit(segment_manager_ref.segment_types.MISC,1,clampf(1-segment_manager_ref.depth_variance,0.1,1))
		doorL.call_deferred("queue_free")


func _on_segment_door_c_body_entered(body):
	#same diff middle
	if body == player_ref and defeats_required == 0:
		if segment_manager_ref.enable:
			segment_manager_ref.new_chunk.emit(segment_manager_ref.segment_types.MISC,0,1)
		doorC.call_deferred("queue_free")


func _on_lifetime_timeout():
	on_timer_timeout()
