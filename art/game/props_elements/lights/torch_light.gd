extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
enum light_status{LOW,BASE,HIGH,FLICKER,OSC}

@export var light:OmniLight3D
@export var light_range:float = 40
@export var light_fade_dist:float = 20
@export var light_radius:float = 20

@export var flickering:bool = false
@export var oscillating:bool = true

@export var base_energy = 10
@export var high_energy = 40
@export var low_energy = 0.5
@export var osc_duration = 1

@export var flicker_interval_min = 0.1
@export var flicker_interval_max = 0.1

@export var color = Color("#e1aa74")
@export var alt_color = Color("#76bdfd")
@export var colors = [Color.RED,Color.BLUE,Color.GREEN,Color.WHITE]

var current_range = light_range

func _ready():
	light.omni_range = light_radius
	light.light_color = color
	light.light_energy = base_energy
	light.distance_fade_begin = light_range
	light.distance_fade_length = light_fade_dist
	

func lower_light():
	pass

func higher_light():
	pass

func base_light():
	pass

func flicker_light():
	pass

func _process(_delta):
	pass


func _on_timer_timeout():
	current_range = light_range+player_ref.speed
	light.distance_fade_begin = current_range
	if player_ref.movement_ability:
		light.omni_range = light_radius+10
		light.light_color = alt_color
		light.light_energy = low_energy
		#light.light_color = colors[player_ref.active_weapon_index]
	else:
		light.light_energy = base_energy
		light.omni_range = light_radius
		light.light_color = color
	
