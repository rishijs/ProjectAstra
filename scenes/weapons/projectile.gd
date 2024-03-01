extends Area3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
var bullet_speed = 0
var velocity = Vector3.ZERO

func _ready():
	transform = player_ref.transform
	velocity = -player_ref.transform.basis.z * bullet_speed

func _process(_delta):
	pass

func sdestruct():
	call_deferred("queue_free")
	
func _physics_process(delta):
	global_position += velocity * delta
