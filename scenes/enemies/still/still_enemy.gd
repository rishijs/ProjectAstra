extends "res://scenes/enemies/enemy.gd"

func _ready():
	super()
	max_health = 200
	health = 200
	speed = 0

func _physics_process(delta):
	super(delta)

func die():
	super()
