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


func _on_victory_body_entered(body):
	if body == player_ref:
		#should have a menu on completion here
		if Globals.prestige <= 3:
			Globals.prestige += 1
			get_tree().reload_current_scene()
		else:
			get_tree().change_scene_to_file("res://interface/menus/main_menu.tscn")


func _on_lifetime_timeout():
	pass
