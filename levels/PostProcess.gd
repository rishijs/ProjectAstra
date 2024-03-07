extends CanvasLayer

@export_category("canvas_shaders")
@export var grain:ColorRect
@export var chromatic:ColorRect
@export var shading:ColorRect

signal weapon_swapped(active_weapon_index)

func _ready():
	pass


func _process(_delta):
	pass


func _on_weapon_swapped(active_weapon_index):
	if active_weapon_index < 4:
		shading.material.set_shader_parameter("type", active_weapon_index)
