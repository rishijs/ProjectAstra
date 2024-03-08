extends Node3D

@export var lifetime = 0.5

func _ready():
	%Timer.wait_time = lifetime
	%Timer.start()

func _on_timer_timeout():
	call_deferred("queue_free")
