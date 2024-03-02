extends "res://scenes/segments/segment.gd"


func _ready():
	pass


func _process(delta):
	pass


func _on_segment_entry_body_entered(body):
	if body == player_ref:
		segment_manager_ref.player_segment_index = id


func _on_victory_body_entered(body):
	if body == player_ref:
		SceneLoader.load_scene("res://interface/menus/main_menu.tscn", true)
		SceneLoader.change_scene_to_loading_screen()
