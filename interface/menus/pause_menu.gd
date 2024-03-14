extends CanvasLayer


func _ready():
	pass


func _process(delta):
	pass


func _on_settings_pressed():
	hide()
	%Settings.show()


func _on_menu_pressed():
	Globals.is_paused = false
	get_tree().paused = false
	hide()
	get_tree().change_scene_to_file("res://interface/menus/main_menu.tscn")


func _on_resume_pressed():
	hide()
	Globals.is_paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	get_tree().get_first_node_in_group("Interface").show()


func _on_visibility_changed():
	pass
