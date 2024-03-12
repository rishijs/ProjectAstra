extends CharacterBody3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@export var health_sprite:Sprite3D

var death_particles = preload("res://art/vfx/death_particles.tscn")

var threat_detected = false
var is_training
var trainer_ref
var max_health
var health
var speed
var damage

var pending_die
var death_called = false

func _ready():
	pass

func _process(_delta):
	pass

func on_hit(incoming_damage):
	health -= incoming_damage
	health = clampf(health,0,max_health)
	health_sprite.show()
	if health == 0 and not pending_die:
		pending_die = true
		die()
	
func die():
	if not death_called:
		player_ref.enemy_defeated.emit()
		death_called = true
		var particles = death_particles.instantiate()
		get_tree().get_first_node_in_group("GameManager").add_child(particles)
		particles.global_position = global_position
		if is_training:
			trainer_ref.empty = true
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
