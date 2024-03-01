extends "res://scenes/weapons/weapon.gd"

func _ready():
	super()
	projectile = preload("res://scenes/weapons/default/default_projectile.tscn")
	initialize_weapon("default")

func _process(delta):
	super(delta)

func fire():
	super()
