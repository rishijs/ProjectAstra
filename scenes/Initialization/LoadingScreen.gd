extends CanvasLayer

const LOADING_COMPLETE_TEXT = "Loading Complete!"
const LOADING_COMPLETE_TEXT_WAITING = "Any Moment Now..."
const LOADING_TEXT = "Loading..."
const LOADING_TEXT_WAITING = "Still Loading..."

enum StallStage{STARTED, WAITING, GIVE_UP}
var _stall_stage : StallStage = StallStage.STARTED
var _loading_complete : bool = false
var delay : float = 1.5
var _loading_progress : float = 0.0 :
	set(value):
		if value == _loading_progress:
			return
		_loading_progress = value
		%ProgressBar.value = _loading_progress
		_reset_loading_stage()
var _changing_to_next_scene : bool = false

func _reset_loading_stage():
	_stall_stage = StallStage.STARTED
	%LoadingTimer.start()

func _load_next_scene():
	if _changing_to_next_scene:
		return
	_changing_to_next_scene = true
	await get_tree().create_timer(delay).timeout
	SceneLoader.change_scene_to_resource()

func _process(_delta):
	if _loading_complete:
		call_deferred("_load_next_scene")
	var status = SceneLoader.get_status()
	match(status):
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			_loading_progress = SceneLoader.get_progress()
			match _stall_stage:
				StallStage.STARTED:
					%Title.text = LOADING_TEXT
				StallStage.WAITING:
					%Title.text = LOADING_TEXT_WAITING
		ResourceLoader.THREAD_LOAD_LOADED:
			_loading_progress = 1.0
			_loading_complete = true
			match _stall_stage:
				StallStage.STARTED:
					%Title.text = LOADING_COMPLETE_TEXT
				StallStage.WAITING:
					%Title.text = LOADING_COMPLETE_TEXT_WAITING
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			set_process(false)

func _on_loading_timer_timeout():
	var prev_stage : StallStage = _stall_stage
	match prev_stage:
		StallStage.STARTED:
			_stall_stage = StallStage.WAITING
			%LoadingTimer.start()
		StallStage.WAITING:
			_stall_stage = StallStage.GIVE_UP

func _on_error_message_confirmed():
	var err = get_tree().change_scene_to_file(ProjectSettings.get_setting("application/run/main_scene"))
	if err:
		print("failed to load main scene: %d" % err)
		get_tree().quit()
