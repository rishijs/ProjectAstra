extends CanvasLayer

var move_on = false

func _input(event):
	if event.is_pressed() and move_on:
		SceneLoader.load_scene("res://levels/gamelvl.tscn", true)
		SceneLoader.change_scene_to_loading_screen()
		
func _ready():
	await get_tree().create_timer(3.0).timeout
	%Label.show()
	move_on = true
