extends Node3D

enum enemy_type{DEFAULT,STILL}
@export_category("spawn criteria")
@export var active = true
@export var spawn_points : Array[Marker3D]
@export var type : enemy_type = enemy_type.STILL
@export var spawn_chance = 0.2
@export var frequency_based = false
@export var frequency = 10.0

var spawned = false
var default_enemy = preload("res://scenes/enemies/default_enemy.tscn")
var still_enemy = preload("res://scenes/enemies/still_enemy.tscn")

func spawn_enemies():
	for spawn_point in spawn_points:
		var rspawn = randf_range(0.01,1)
		if rspawn <= spawn_chance and is_instance_valid(spawn_point):
			match type:
				enemy_type.DEFAULT:
					var enemy = default_enemy.instantiate()
					add_child(enemy)
					enemy.global_position = spawn_point.global_position
				enemy_type.STILL:
					var enemy = still_enemy.instantiate()
					add_child(enemy)
					enemy.global_position = spawn_point.global_position
