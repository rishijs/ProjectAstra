extends Node

@onready var segment_manager_ref = get_tree().get_first_node_in_group("SegmentManager")
@onready var spawn_manager_ref = get_tree().get_first_node_in_group("SpawnManager")
@onready var player_ref = get_tree().get_first_node_in_group("Player")


@export var inactive_segment:bool = false

@export var spawn_arrangements:Array[Node3D]
#changes based on depth after first arena
var spawn_chance_change = 0
#scaling depth flat
@export var depth_spawn_scaling_flat = 0.2
#scaling depth multiplied
@export var depth_spawn_scaling_mult = 0.05
#changes on prestige
var num_waves_change = Globals.prestige - 1


@export var timer_node : Timer
@export var time_multiplier : float

var forced_arrangement : bool = false
var specific_arrangement : int = 0

@export_category("pivots")
@export var up : Marker3D
@export var left : Marker3D
@export var down : Marker3D
@export var right : Marker3D

"""
too complex for spawning
var arrangements = {
	"P":{},
	"CT":{},
	"ST":{},
	"VT":{},
	"CH":{},
	"A":{
		0: preload("res://levels/enemy_arrangements/arena/default_arena_a_0.tscn")
	},
	"R":{},
	"M":{}
}
"""

var id:int
var type:int
var depth:int
var timer:float

func _ready():
	#choose_enemy_arrangement(forced_arrangement,specific_arrangement)
	pass

func spawn_spawners():
	spawn_chance_change += -segment_manager_ref.player_depth * depth_spawn_scaling_mult + depth_spawn_scaling_flat
	for arrangement in spawn_arrangements:
		for spawner in arrangement.get_children():
			if spawner.chance_to_spawn != 1.0:
				spawner.chance_to_spawn = clampf(spawner.chance_to_spawn+spawn_chance_change,0,1)
			spawner.num_waves += num_waves_change
			var chance = randf_range(0.01,1.0)
			if chance > spawner.chance_to_spawn:
				spawner.queue_free()
			else:
				spawner.activate()

"""
func choose_enemy_arrangement(forced, specific):
	if not forced:
		var arrangement_selection = arrangements[arrangements.keys()[type]]
		var arrangement_number = arrangement_selection.keys().size()
		if arrangement_number > 0:
			var arrangement = arrangement_selection[randi_range(0,arrangement_number)].instantiate()
			add_child(arrangement)
			arrangement.global_position = self.global_position
	else:
		var arrangement_selection = arrangements[arrangements.keys()[type]]
		if specific < arrangement_selection.keys().size():
			var arrangement = arrangement_selection[specific].instantiate()
			add_child(arrangement)
			arrangement.global_position = self.global_position
"""

func destruct():
	queue_free()

func update_on_entry():
	if not inactive_segment:
		segment_manager_ref.player_segment_index = id
		segment_manager_ref.player_depth = depth
		timer_node.start()
		player_ref.can_use_movement_ability = true

func update_on_exit():
	if not inactive_segment:
		segment_manager_ref.player_segment_index = id+1
		
func _process(_delta):
	pass

func on_timer_timeout():
	#timer no longer active
	#if segment_manager_ref.segments[segment_manager_ref.player_segment_index].id == id:
	timer -= 1
	if timer == 0:
		timer_node.paused = true
		#segment_manager_ref.destroy_behind_segment(id)
