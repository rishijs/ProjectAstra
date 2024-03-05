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


func _on_victory_body_entered(body):
	if body == player_ref:
		SceneLoader.load_scene("res://interface/menus/main_menu.tscn", true)
		SceneLoader.change_scene_to_loading_screen()


func _on_lifetime_timeout():
	on_timer_timeout()
