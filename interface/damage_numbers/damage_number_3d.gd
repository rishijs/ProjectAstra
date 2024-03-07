extends Node3D

@onready var player_ref = get_tree().get_first_node_in_group("Player")
@export var damage_number : Label3D
var damage
var crit
var headshot

var float_time = 0.5
var speed = 5
var offset_range = 0.1
var fall = false

var colors = [Color.RED,Color.GREEN,Color.BLUE]
var change_colors = false
var timer = 0.1


func _ready():
	update()
	#look_at(player_ref.global_position)
	await get_tree().create_timer(float_time,false).timeout
	fall = true


func move_to_player_loc():
	var offset_loc = Vector3( randf_range(-offset_range,offset_range), 0, randf_range(-offset_range,offset_range))
	global_position = global_position+offset_loc
	global_position += global_position.direction_to(player_ref.position)
	
func _physics_process(delta):
	if fall:
		global_position.y -= speed * delta


func _on_timer_timeout():
	call_deferred("queue_free")


func update():
	move_to_player_loc()
	damage_number.text = str(snapped(damage,0.1))
	if headshot and crit:
		change_colors = true
		damage_number.modulate = colors[randi_range(0,2)]
		damage_number.font_size = 75
	elif headshot:
		#damage_number.modulate = Color.RED
		damage_number.font_size = 60
	elif crit:
		#damage_number.modulate = Color.GOLDENROD
		damage_number.font_size = 60


func _process(delta):
	look_at(player_ref.global_position)
	timer -= delta
	if timer <= 0:
		if change_colors:
			damage_number.modulate = colors[randi_range(0,2)]
		timer = 0.1
