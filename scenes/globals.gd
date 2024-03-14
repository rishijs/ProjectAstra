extends Node

var player_preferences = {
	"mouse_sensitivity" = 0.005
}

var prestige = 1

var in_game = false
var is_paused = false

var time_elapsed = 0
var time_string = "00:00"

func _input(_event):
	if Input.is_action_just_pressed("pause") and in_game:
		if get_tree().paused:
			get_tree().paused = false
			get_tree().get_first_node_in_group("PauseMenu").hide()
			get_tree().get_first_node_in_group("Interface").show()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			get_tree().paused = true

func convert_time_to_string(mins,seconds):
	var result:String
	if seconds < 10 and mins < 10:
		result = "0%d:0%d"%[mins,seconds]
	elif seconds < 10 and mins >= 10:
		result = "%d:0%d"%[mins,seconds]
	elif seconds >= 10 and mins < 10:
		result = "0%d:%d"%[mins,seconds]
	else:
		result = "%d:%d"%[mins,seconds]
	return result

func tick_time():
	time_elapsed += 1
	var mins = time_elapsed / 60
	var seconds = time_elapsed % 60
	time_string = convert_time_to_string(mins,seconds)
	
func _on_timer_timeout():
	if in_game:
		tick_time()
