extends CanvasLayer

@onready var player_ref = get_tree().get_first_node_in_group("Player")

@export_category("canvas_shaders")
@export var grain:ColorRect
@export var chromatic:ColorRect
@export var shading:ColorRect
@export var grid:ColorRect

var colorize_duration = 0
var colorize_max_duration = 1

var grid_min = 0.1
var grid_max = 0.5

var chroma_anim_time = 0.5

var primary_fire_pressed = false

signal weapon_swapped(active_weapon_index)

func _ready():
	grid.material.set_shader_parameter("intensity",grid_min)

func _input(_event):
	if Input.is_action_pressed("primary_fire"):
		primary_fire_pressed = true
		grid.material.set_shader_parameter("intensity",grid_max)
	if Input.is_action_just_released("primary_fire"):
		primary_fire_pressed = false
		grid.material.set_shader_parameter("intensity",grid_min)
		
func _process(delta):
	colorize(delta)

func colorize(delta):
	if primary_fire_pressed:
		colorize_duration += delta
	if primary_fire_pressed and player_ref.weapons[player_ref.active_weapon_index].magazine > 0:
		shading.show()
		grid.material.set_shader_parameter("speed",clampi(100+colorize_duration*100,0,1000))
	elif colorize_duration >= colorize_max_duration:
		shading.hide()
		primary_fire_pressed = false
		grid.material.set_shader_parameter("speed",100)
		colorize_duration = 0


func _on_weapon_swapped(active_weapon_index):
	if active_weapon_index < 4:
		shading.material.set_shader_parameter("type", active_weapon_index)
	
	if player_ref.num_swaps!= 0:
		chromatic.show()
		await get_tree().create_timer(chroma_anim_time,false).timeout
		chromatic.hide()
