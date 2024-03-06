extends CanvasLayer


@export var dmg_label : RichTextLabel
@export var big_dmg_label : RichTextLabel

var parent
var dmg = 0
var crit = false
var headshot = false

var colors = [Color.RED,Color.GREEN,Color.BLUE]

#specific icon descripters
var icon 

func update():
	dmg = snappedf(dmg,0.1)
	dmg_label.text = str(dmg)
	big_dmg_label.text = str(dmg)
	if headshot and crit:
		big_dmg_label.show()
		dmg_label.hide()
		big_dmg_label.modulate = Color.WHITE
	elif headshot:
		dmg_label.modulate = Color.RED 
	elif crit:
		dmg_label.modulate = Color.GOLDENROD
	else:
		%ChangeColors.start()

func update_text():
	dmg_label.clear()
	for digit in len(str(dmg)):
		if (digit+1) % 3 == 0:
			dmg_label.push_color(colors[randi_range(0,2)])
			dmg_label.append_text(str(dmg)[digit])
			dmg_label.pop() 
		if (digit+1) % 2 == 0:
			dmg_label.push_color(colors[randi_range(0,2)])
			dmg_label.append_text(str(dmg)[digit])
			dmg_label.pop() 
		else:
			dmg_label.push_color(colors[randi_range(0,2)])
			dmg_label.append_text(str(dmg)[digit])
			dmg_label.pop() 
	
func _on_change_colors_timeout():
	update_text()
