extends CanvasLayer


func _ready():
	pass


func _on_back_pressed():
	hide()
	if is_instance_valid(get_tree().get_first_node_in_group("PauseMenu")):
		get_tree().get_first_node_in_group("PauseMenu").show()


func _on_sens_value_changed(value):
	if visible:
		Globals.player_preferences["mouse_sensitivity"] = value


func _on_audio_vol_value_changed(value):
	if visible:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))


func _on_music_vol_value_changed(value):
	if visible:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambience"), linear_to_db(value))
