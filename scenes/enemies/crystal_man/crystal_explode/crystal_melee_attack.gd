extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")

var damage

func _on_body_entered(body):
	if body == player_ref:
		player_ref.hit.emit(damage)
		queue_free()


func _on_timer_timeout():
	call_deferred("queue_free")
