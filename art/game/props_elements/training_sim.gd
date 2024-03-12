extends Node3D

enum enemy_type{DEFAULT,STILL,CRYSTAL}
enum crystal_types{TRAINING,PUNCH,LASER}

@export var enemy:enemy_type
@export var crystal_type:crystal_types
@export var marker:Marker3D

var enemies = {
	default_enemy = preload("res://scenes/enemies/default/default_enemy.tscn"),
	still_enemy = preload("res://scenes/enemies/still/still_enemy.tscn"),
	crystal_enemy = preload("res://scenes/enemies/crystal_man/crystal_enemy.tscn"),
}
var empty = true

func spawn_enemy():
	var curr
	curr = enemies[enemies.keys()[enemy]].instantiate()
	curr.is_training = true
	curr.trainer_ref = self
	
	match crystal_type:
		crystal_types.TRAINING:
			curr.training_man = true
		crystal_types.PUNCH:
			curr.punch_man = true
		crystal_types.LASER:
			curr.laser_man = true
				
	add_child(curr)
	curr.global_position = marker.global_position
	
func _on_timer_timeout():
	if empty == true:
		spawn_enemy()
		empty = false
