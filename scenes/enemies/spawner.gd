extends Node3D

enum enemy_type{DEFAULT,STILL,WATCHER}
@export_category("spawn criteria")
@export var active = true
@export var spawn_points : Array[Marker3D]
@export var type : enemy_type = enemy_type.STILL
@export var spawn_chance = 0.2
@export var frequency_based = false
@export var frequency = 10.0

var spawned = false
var enemies = {
	default_enemy = preload("res://scenes/enemies/default/default_enemy.tscn"),
	still_enemy = preload("res://scenes/enemies/still/still_enemy.tscn"),
	watcher = preload("res://scenes/enemies/watcher/watcher.tscn")
}

func spawn_enemies():
	for spawn_point in spawn_points:
		var rspawn = randf_range(0.01,1)
		if rspawn <= spawn_chance and is_instance_valid(spawn_point):
			var enemy = enemies[enemies.keys()[type]].instantiate()
			add_child(enemy)
			enemy.global_position = spawn_point.global_position
