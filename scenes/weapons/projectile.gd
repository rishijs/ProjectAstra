extends Area3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")

var velocity = Vector3.ZERO
var projectile_stats = {}
var weapon

signal hit(damage)

func _ready():
	aim_shot()
	apply_jitter()

func apply_jitter():
	self.transform = self.transform.rotated_local(Vector3.UP, randf_range(-projectile_stats["jitter"], projectile_stats["jitter"]))
	self.transform = self.transform.rotated_local(Vector3.RIGHT, randf_range(-projectile_stats["jitter"], projectile_stats["jitter"]))
	
func aim_shot():
	var max_inaccuracy =  projectile_stats["max_spread"] * (100-projectile_stats["accuracy"])/100.0
	var offsetx = randf_range(-max_inaccuracy,max_inaccuracy)
	var offsety = randf_range(-max_inaccuracy,max_inaccuracy)
	var offsetz = randf_range(-max_inaccuracy,max_inaccuracy)
	
	var new_target = Vector3(player_ref.target.global_position.x+offsetx,
							player_ref.target.global_position.y+offsety,
							player_ref.target.global_position.z+offsetz)
							
	look_at(new_target)
	transform = player_ref.transform
	velocity = global_position.direction_to(new_target) * projectile_stats["bullet_speed"]

func _process(_delta):
	pass

func damage_enemy(enemy):
	if enemy.has_method("on_hit"):
		hit.connect(enemy.on_hit)
		hit.emit(projectile_stats["bullet_damage"])
		sdestruct()
	
func sdestruct():
	call_deferred("queue_free")
	
func _physics_process(delta):
	global_position += velocity * delta