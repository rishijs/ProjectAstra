extends "res://scenes/enemies/enemy.gd"

@export var crystal_sprite:AnimatedSprite3D
@export var melee_target:Marker3D
@export var laser_target:Marker3D

var melee_attack = preload("res://scenes/enemies/crystal_man/crystal_explode/melee_attack.tscn")
var laser_attack = preload("res://scenes/enemies/crystal_man/laser_eyes/laser_attack.tscn")

var laser_man = false
var punch_man = false
var training_man = false

var melee_range = false
var can_attack = true
var attacking = false

var locking_on = false
var locked_position

var attack_speed

func _ready():
	super()
	if training_man:
		max_health = 200
		health = 200
		speed = 0
	elif laser_man:
		max_health = 100
		health = 100
		speed = 0
		damage = 2
		attack_speed = 5
	elif punch_man:
		max_health = 150
		health = 150
		speed = 10
		damage = 10
		attack_speed = 2
		
	crystal_sprite.play("idle")

func _physics_process(delta):
	
	if locking_on:
		lock_on()
		
	if threat_detected and laser_man and can_attack and not attacking:
		launch_laser_attack()
		can_attack = false
		attacking = true
		locking_on = true
		%LaserAttackWarning.show()
		%LaserAttackWarningClose.hide()
		%LockOnTimer.start()
		%AttackTimer.wait_time = attack_speed
		%AttackTimer.start()
		
	elif threat_detected and punch_man and not melee_range and not attacking:
		velocity = global_position.direction_to(player_ref.global_position) * speed
		crystal_sprite.play("walk")
		move_and_slide()
	
	elif threat_detected and punch_man and melee_range and can_attack:
		launch_melee_attack()
		can_attack = false
		attacking = true
		%AttackTimer.wait_time = attack_speed
		%AttackTimer.start()
		
	elif not attacking:
		crystal_sprite.play("idle")
		
	
func launch_melee_attack():
	melee_target.show()
	crystal_sprite.play("explode")
	
func launch_laser_attack():
	laser_target.show()
	crystal_sprite.play("laser")

func lock_on():
	if locking_on:
		var dist_to_player = laser_target.global_position.distance_to(player_ref.global_position)
		
		%LaserAttackWarningClose.mesh.height = dist_to_player*25.0
		%LaserAttackWarning.mesh.height = dist_to_player*25.0
		
		laser_target.look_at(player_ref.global_position)
		locked_position = player_ref.global_position

func die():
	super()


func _on_attack_timer_timeout():
	can_attack = true


func _on_melee_range_body_entered(body):
	if body == player_ref:
		melee_range = true


func _on_melee_range_body_exited(body):
	if body == player_ref:
		melee_range = false


func _on_crystalman_animation_finished():
	attacking = false
	%LaserAttackWarningClose.hide()
	if punch_man:
		melee_target.hide()
		var atk = melee_attack.instantiate()
		atk.damage = damage
		add_child(atk)
		atk.global_position = melee_target.global_position
		
	if laser_man:
		laser_target.hide()
		var atk = laser_attack.instantiate()
		atk.damage = damage
		add_child(atk)
		atk.global_position = locked_position


func _on_lock_on_timer_timeout():
	locking_on = false
	%LaserAttackWarning.hide()
	%LaserAttackWarningClose.show()
