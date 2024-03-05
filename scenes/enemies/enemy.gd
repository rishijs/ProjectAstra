extends CharacterBody3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")

var threat_detected = false
var max_health
var health
var speed
var damage

func _ready():
	pass


func _process(_delta):
	pass

func on_hit(incoming_damage):
	health -= incoming_damage
	health = clampf(health,0,max_health)
	if health == 0:
		die()
	
func die():
	if is_instance_valid(player_ref.arena_ref):
		if player_ref.arena_ref.defeats_required > 0:
			player_ref.arena_ref.defeats_required -= 1
	player_ref.enemies_defeated += 1
	call_deferred("queue_free")

func _physics_process(_delta):
	if threat_detected:
		#transform = player_ref.transform
		velocity = global_position.direction_to(player_ref.global_position) * speed
		move_and_slide()

func hit_player():
	player_ref.hit.emit(damage)

func _on_detection_body_entered(body):
	if body == player_ref:
		threat_detected = true


func _on_range_body_exited(body):
	if body == player_ref:
		threat_detected = false
