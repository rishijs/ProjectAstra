extends "res://scenes/segments/segment.gd"

@onready var game_manager_ref = get_tree().get_first_node_in_group("GameManager")
@export var connection_end:Array[Marker3D]

@export_category("doors")
@export var doorE:StaticBody3D
@export var doorC:StaticBody3D
@export var doorL:StaticBody3D
@export var doorR:StaticBody3D

@export var time_modifier_flat_gain = 30
@export var time_modifier_multiplied_loss = 0.9

var locked = false
var door_chosen = false
var first = false
var defeats_required

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
	if body == player_ref and not inactive_segment:
		update_on_entry()
		timer_node.start()
		calculate_num_elims()
		if defeats_required > 0:
			lock_arena()

func init_arena():
	doorE.hide()
	%EntryDoorCol.disabled = true

func calculate_num_elims():
	defeats_required = 0
	for arrangement in spawn_arrangements:
		for spawner in arrangement.get_children():
			spawner.num_waves += num_waves_change
			spawner.activate()
			if spawner.spawn_at_arena_index <= segment_manager_ref.arena_index:
				defeats_required += spawner.num_waves
			else:
				spawner.queue_free()
		arrangement.show()

func lock_arena():
	locked = true
	doorE.show()
	player_ref.arena_ref = self

func unlock_arena():
	if defeats_required == 0 and locked:
		player_ref.arena_ref = null
		locked = false
		#%CL.show()
		#%LL.show()
		#%RL.show()


func _on_segment_door_r_body_entered(body):
	#higher diff right
	if body == player_ref and defeats_required == 0 and not door_chosen:
		#segment_manager_ref.segment_rotation = segment_manager_ref.add_y_rotation(segment_manager_ref.segment_rotation,-90)
		if segment_manager_ref.enable:
			segment_manager_ref.new_chunk.emit(segment_manager_ref.segment_types.MISC,2,1+segment_manager_ref.depth_variance)
		door_chosen = true
		player_ref.aberrate_weapon("successful")
		game_manager_ref.player_time_seconds *= time_modifier_multiplied_loss
		update_on_exit()
		doorR.call_deferred("queue_free")


func _on_segment_door_l_body_entered(body):
	#lower diff left
	if body == player_ref and defeats_required == 0 and not door_chosen:
		#segment_manager_ref.segment_rotation = segment_manager_ref.add_y_rotation(segment_manager_ref.segment_rotation,90)
		if segment_manager_ref.enable:
			segment_manager_ref.new_chunk.emit(segment_manager_ref.segment_types.MISC,0,clampf(1-segment_manager_ref.depth_variance,0.1,1))
		door_chosen = true
		player_ref.aberrate_weapon("unstable")
		game_manager_ref.player_time_seconds += time_modifier_flat_gain
		update_on_exit()
		doorL.call_deferred("queue_free")


func _on_segment_door_c_body_entered(body):
	#same diff middle
	if body == player_ref and defeats_required == 0 and not door_chosen:
		if segment_manager_ref.enable:
			segment_manager_ref.new_chunk.emit(segment_manager_ref.segment_types.MISC,1,1)
		door_chosen = true
		player_ref.aberrate_weapon("stable")
		update_on_exit()
		doorC.call_deferred("queue_free")


func _on_lifetime_timeout():
	on_timer_timeout()
