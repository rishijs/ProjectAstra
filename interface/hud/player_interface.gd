extends CanvasLayer

@export_category("refs")
@export var fps_text:Label
@export var time_text:Label

func _ready():
	pass


func _process(_delta):
	pass


func _on_update_timeout():
	fps_text.text = "%d FPS" % Engine.get_frames_per_second()
	time_text.text = "%s" % Globals.time_string
