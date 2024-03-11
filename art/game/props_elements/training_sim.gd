extends Node3D

enum enemy_type{DEFAULT,STILL}
@export var enemy:enemy_type
@export var marker:Marker3D

var enemies = {
	default_enemy = preload("res://scenes/enemies/default/default_enemy.tscn"),
	still_enemy = preload("res://scenes/enemies/still/still_enemy.tscn"),
}
var empty = true

func spawn_enemy():
	var curr
	curr = enemies[enemies.keys()[enemy]].instantiate()
	curr.is_training = true
	curr.trainer_ref = self
	add_child(curr)
	curr.global_position = marker.global_position
	
func _on_timer_timeout():
	if empty == true:
		spawn_enemy()
		empty = false
