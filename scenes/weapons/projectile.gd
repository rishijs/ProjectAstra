extends Area3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")

var velocity = Vector3.ZERO
var weapon_stats = []
var weapon
var target
var headshot = false

signal hit(damage,headshot)

func _ready():
	aim_shot()
	apply_jitter()

func apply_jitter():
	self.transform = self.transform.rotated_local(Vector3.UP, randf_range(-weapon_stats[Data.wattr.JITTER], weapon_stats[Data.wattr.JITTER]))
	self.transform = self.transform.rotated_local(Vector3.RIGHT, randf_range(-weapon_stats[Data.wattr.JITTER], weapon_stats[Data.wattr.JITTER]))
	
func aim_shot():
	var max_inaccuracy = weapon_stats[Data.wattr.MAX_SPREAD] * (100-weapon_stats[Data.wattr.ACCURACY])/100.0
	var offsetx = randf_range(-max_inaccuracy,max_inaccuracy)
	var offsety = randf_range(-max_inaccuracy,max_inaccuracy)
	var offsetz = randf_range(-max_inaccuracy,max_inaccuracy)
	
	var new_target = Vector3(target.global_position.x+offsetx,
							target.global_position.y+offsety,
							target.global_position.z+offsetz)
							
	look_at(new_target)
	transform = player_ref.transform
	velocity = global_position.direction_to(new_target) * weapon_stats[Data.wattr.PROJECTILE_SPEED]

func _process(_delta):
	pass

func damage_enemy(enemy,headshot):
	if enemy.has_method("on_hit"):
		hit.connect(enemy.on_hit)
		if headshot:
			hit.emit(weapon_stats[Data.wattr.DAMAGE]*weapon_stats[Data.wattr.HEADSHOT_MULTIPLIER])
		else:
			hit.emit(weapon_stats[Data.wattr.DAMAGE])
		sdestruct()
	
func sdestruct():
	call_deferred("queue_free")
	
func _physics_process(delta):
	global_position += velocity * delta
