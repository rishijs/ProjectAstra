extends CanvasLayer


func _ready():
	pass


func _process(_delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://interface/menus/introduction.tscn")


func _on_settings_pressed():
	%Settings.show()
