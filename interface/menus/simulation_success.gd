extends CanvasLayer

@onready var game_manager_ref = get_tree().get_first_node_in_group("GameManager")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://interface/menus/main_menu.tscn")


func _on_prestige_pressed():
	get_tree().change_scene_to_file("res://levels/gamelvl.tscn")


func _on_visibility_changed():
	get_tree().get_first_node_in_group("Interface").hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	%Prestige.text = "PRESTIGE: %d"%Globals.prestige
	%Score.text = "SCORE: %d"%game_manager_ref.score
