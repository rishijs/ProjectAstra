extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
enum light_status{LOW,BASE,HIGH,FLICKER,OSC}

@export var light:OmniLight3D
@export var light_range:float = 40
@export var light_radius:float = 20
@export var flickering:bool = false
@export var oscillating:bool = true

@export var base_energy = 20
@export var high_energy = 40
@export var low_energy = 2
@export var osc_duration = 1

@export var flicker_interval_min = 0.1
@export var flicker_interval_max = 0.1

@export var color = Color("#e1aa74")

var current_range = light_range

func _ready():
	light.distance_fade_begin = light_range

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
	
