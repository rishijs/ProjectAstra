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
	regular_hit(body)


func _on_area_entered(area):
	headshot_hit(area)
