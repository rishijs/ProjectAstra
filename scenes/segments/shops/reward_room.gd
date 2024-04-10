extends "res://scenes/segments/segment.gd"


func _ready():
	pass


func _process(_delta):
	pass

func on_timer_timeout():
	super()

func update_on_entry():
	super()
	
func _on_segment_entry_body_entered(body):
	if body == player_ref:
		update_on_entry()
		player_ref.speed = player_ref.base_speed/3.0
		player_ref.movement_energy = 0
		player_ref.movement_ability = false
		player_ref.can_use_movement_ability = false
		player_ref.gravity += 200
		player_ref.game_manager_ref.score += player_ref.game_manager_ref.player_time_seconds * 25


func _on_victory_body_entered(body):
	if body == player_ref:
		#should have a menu on completion here
		player_ref.invincible = true
		get_tree().get_first_node_in_group("Success").show()


func _on_lifetime_timeout():
	pass
