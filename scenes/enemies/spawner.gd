extends Node3D

enum enemy_types{DEFAULT,STILL,CRYSTAL}
enum crystal_types{PUNCHER,LASER}

@onready var spawn_manager = get_tree().get_first_node_in_group("SpawnManager")
@export_category("spawn criteria")

@export var spawn_type : crystal_types
@export var num_waves = 0
@export var spawn_rate = 10.0
@export var chance_to_spawn = 1.0

var spawned = false
var enemies = {
	default_enemy = preload("res://scenes/enemies/default/default_enemy.tscn"),
	still_enemy = preload("res://scenes/enemies/still/still_enemy.tscn"),
	crystal_enemy = preload("res://scenes/enemies/crystal_man/crystal_enemy.tscn")
}
var curr_enemy = null

func _ready():
	%Timer.wait_time = spawn_rate

func activate():
	%Timer.start()
	
func spawn_enemy():
	var enemy = enemies.crystal_enemy.instantiate()
	match spawn_type:
		crystal_types.PUNCHER:
			enemy.punch_man = true
		crystal_types.LASER:
			enemy.laser_man = true
	spawn_manager.add_child(enemy)
	enemy.global_position = %spawn.global_position
	curr_enemy = enemy


func _on_timer_timeout():
	if num_waves == 0:
		%Timer.stop()
	elif not is_instance_valid(curr_enemy) or curr_enemy == null:
		spawn_enemy()
		num_waves -= 1
