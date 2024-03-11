extends "res://scenes/enemies/enemy.gd"

@export var crystal_sprite:AnimatedSprite3D

func _ready():
	super()
	max_health = 100
	health = 100
	speed = 0
	crystal_sprite.play("idle")

func _physics_process(delta):
	super(delta)

func die():
	super()
