extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@export var damage_number_2d : CanvasLayer
var damage
var crit
var headshot

var float_time = 0.5
var speed = 5
var offset_range = 0.1
var fall = false

func _ready():
	damage_number_2d.dmg = damage
	damage_number_2d.crit = crit
	damage_number_2d.headshot = headshot
	damage_number_2d.update()
	await get_tree().create_timer(float_time,false).timeout
	fall = true

func move_to_player_loc():
	var offset_loc = Vector3( randf_range(-offset_range,offset_range), 0, randf_range(-offset_range,offset_range))
	global_position = global_position+offset_loc
	global_position += global_position.direction_to(player_ref.position)
	
func _physics_process(delta):
	if fall:
		global_position.y -= speed * delta


func _on_timer_timeout():
	call_deferred("queue_free")
