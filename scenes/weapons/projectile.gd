extends Area3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
var bullet_speed = 0
var velocity = Vector3.ZERO
var damage = 10

func _ready():
	if player_ref.movement_ability:
		bullet_speed *= player_ref.movement_boost
	transform = player_ref.transform
	velocity = -player_ref.transform.basis.z * bullet_speed

func _process(_delta):
	pass

func damage_enemy(enemy):
	enemy.health -= damage
	sdestruct()
	
func sdestruct():
	call_deferred("queue_free")
	
func _physics_process(delta):
	global_position += velocity * delta
