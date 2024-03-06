extends Node3D

#var speed = 10
@export var damage_number_2d : CanvasLayer
var damage
var crit
var headshot
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	await damage != null
	damage_number_2d.dmg = damage
	damage_number_2d.crit = crit
	damage_number_2d.headshot = headshot
	damage_number_2d.update()

func _physics_process(delta):
	global_position.y -= gravity * delta


func _on_timer_timeout():
	call_deferred("queue_free")
