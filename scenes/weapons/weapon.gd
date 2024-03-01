extends Node3D

@onready var projectile_manager_ref = get_tree().get_first_node_in_group("ProjectileManager")
var projectile
var muzzle
var weapon_stats = {}
var initialized = false

func _ready():
	muzzle = %muzzle

func _process(_delta):
	pass

func initialize_weapon(weapon):
	weapon_stats["bullet_speed"] = Data.get_weapon_attr(weapon,Data.weapon_attributes.PROJECTILE_SPEED)
	initialized = true
	
func fire():
	if initialized and is_instance_valid(projectile_manager_ref) and is_instance_valid(muzzle):
		var this_projectile = projectile.instantiate()
		this_projectile.bullet_speed = weapon_stats["bullet_speed"]
		projectile_manager_ref.add_child(this_projectile)
		this_projectile.global_position = muzzle.global_position
	else:
		printerr("references not set")
