extends CanvasLayer

@export var owner_ref:CharacterBody3D
@export var instant_healthbar:ProgressBar
@export var tweeening_healthbar:ProgressBar

@export var tween_duration = 1

signal health_changed

func _ready():
	pass

func _on_update_timeout():
	if is_instance_valid(owner_ref) and owner_ref.max_health != null:
		instant_healthbar.max_value = owner_ref.max_health
		tweeening_healthbar.max_value = owner_ref.max_health
		if owner.health != instant_healthbar.value:
			health_changed.emit()


func _on_health_changed():
	instant_healthbar.value = owner_ref.health
	var tween = get_tree().create_tween()
	tween.tween_property(tweeening_healthbar,"value",owner_ref.health,tween_duration)
