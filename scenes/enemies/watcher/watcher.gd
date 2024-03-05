extends "res://scenes/enemies/enemy.gd"

var ramp_interval = 1
var ramp = 0.5

func _ready():
	%Ramp.wait_time = ramp_interval
	max_health = 500
	health = 500
	speed = 2
	
	#watcher spawned warning extra logic required to decide if anomaly is spawned

func hit_player():
	super()
	
func _physics_process(delta):
	super(delta)


func _on_close_body_entered(body):
	if body == player_ref:
		player_ref.aberration_close = true


func _on_warning_body_entered(body):
	if body == player_ref:
		player_ref.aberration_close = true


func _on_close_body_exited(body):
	if body == player_ref:
		player_ref.aberration_close = false


func _on_warning_body_exited(body):
	if body == player_ref:
		player_ref.aberration_warning = false


func _on_kill_body_entered(body):
	if body == player_ref:
		hit_player()


func _on_ramp_timeout():
	speed += ramp
