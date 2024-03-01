extends CharacterBody3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")

enum enemy_type{DEFAULT,STILL}
@export var type : enemy_type

var threat_detected = false
var max_health = 100
var health = 100
var speed = 0

func _ready():
	match type:
		enemy_type.DEFAULT:
			speed = 5
		enemy_type.STILL:
			speed = 0


func _process(_delta):
	health = clampf(health,0,max_health)
	if health == 0:
		die()

func die():
	call_deferred("queue_free")

func _physics_process(delta):
	if threat_detected:
		velocity = position.direction_to(player_ref.position) * speed
		move_and_slide()


func _on_detection_body_entered(body):
	if body == player_ref:
		threat_detected = true


func _on_range_body_exited(body):
	if body == player_ref:
		threat_detected = false
