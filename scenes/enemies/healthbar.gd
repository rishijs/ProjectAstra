extends CanvasLayer

@export var owner_ref:CharacterBody3D
@export var healthbar:ProgressBar

func _ready():
	pass

func _on_update_timeout():
	if is_instance_valid(owner_ref) and owner_ref.max_health != null:
		healthbar.max_value = owner_ref.max_health
		healthbar.value = owner_ref.health
