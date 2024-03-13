extends "res://scenes/segments/segment.gd"

@onready var game_manager_ref = get_tree().get_first_node_in_group("GameManager")

@export var connection_end:Array[Marker3D]
@export var door:Node3D
@export var doorLock:Node3D
@export var doorLockCol:CollisionShape3D
@export var checkpoint_flag:MeshInstance3D

var checkpoint_texture = preload("res://scenes/segments/shops/checkpoint_active.tres")
var checkpoint_active = false


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
		if not checkpoint_active:
			#if game_manager_ref.segment_ref != null:
				#segment_manager_ref.erase(game_manager_ref.segment_ref)
				#game_manager_ref.segment_ref.destruct()
			checkpoint_flag.material_override = checkpoint_texture
			game_manager_ref.checkpoint_ref = checkpoint_flag
			game_manager_ref.segment_ref = self
			game_manager_ref.rotation_at_checkpoint = segment_manager_ref.segment_rotation
			game_manager_ref.depth_at_checkpoint = segment_manager_ref.player_depth

func _on_segment_exit_body_entered(body):
	if body == player_ref:
		update_on_exit()


func _on_segment_door_body_entered(body):
	if body == player_ref and not inactive_segment:
		door.hide()
		


func _on_lifetime_timeout():
	on_timer_timeout()

