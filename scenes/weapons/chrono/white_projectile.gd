extends "res://scenes/weapons/projectile.gd"

func _ready():
	super()

func _process(delta):
	super(delta)

func _physics_process(delta):
	super(delta)
	
func _on_self_destruct_timeout():
	sdestruct()

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		damage_enemy(body,false)
	if body != player_ref:
		sdestruct()


func _on_area_entered(area):
	if area.is_in_group("HeadshotCol"):
		damage_enemy(area,true)
		headshot = true
