extends Node

@export_file("*.tscn") var _loading_screen : String
@export_file("*.tscn") var _next_scene : String
@export var _use_loading_screen : bool = false

func _load_next_scene():
	if _use_loading_screen:
		SceneLoader.load_scene(_next_scene)
	else:
		get_tree().change_scene_to_file(_next_scene)

func _ready():
	SceneLoader.set_loading_screen(_loading_screen)
	call_deferred("_load_next_scene")
