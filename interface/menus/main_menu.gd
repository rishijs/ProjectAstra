extends CanvasLayer


func _ready():
	%AnimatedSprite2D.play("laser")


func _process(_delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://interface/menus/introduction.tscn")


func _on_settings_pressed():
	%Settings.show()


func _on_animated_sprite_2d_animation_finished():
	%AnimatedSprite2D.play("laser")
