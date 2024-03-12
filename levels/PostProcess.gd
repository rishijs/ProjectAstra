extends CanvasLayer

@onready var player_ref = get_tree().get_first_node_in_group("Player")

@export_category("canvas_shaders")
@export var dither:ColorRect
@export var chromatic:ColorRect
@export var shading:ColorRect
@export var grid:ColorRect
@export var sharpen:ColorRect

var colorize_duration = 0
var colorize_max_duration = 1
var chromatic_time = 0.5

var grid_min = 0.2
var grid_max = 0.7

var chroma_anim_time = 0.5

var primary_fire_pressed = false

signal weapon_swapped(active_weapon_index)

func _ready():
	grid.material.set_shader_parameter("intensity",grid_min)

func _input(_event):
	if Input.is_action_pressed("primary_fire"):
		primary_fire_pressed = true
		grid.material.set_shader_parameter("intensity",grid_max)
	
	#if using chronos
	if Input.is_action_just_pressed("primary_fire") and player_ref.active_weapon_index == 3:
		trigger_chromatic()
		
	if Input.is_action_just_released("primary_fire"):
		primary_fire_pressed = false
		grid.material.set_shader_parameter("intensity",grid_min)
		
func _process(delta):
	colorize(delta)

func trigger_chromatic():
	chromatic.show()
	await get_tree().create_timer(chromatic_time).timeout
	chromatic.hide()
	
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
