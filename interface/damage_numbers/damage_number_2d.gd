extends CanvasLayer

var parent
var dmg = 0
var crit = false
var headshot = false

#specific icon descripters
var icon 

func update():
	%dmg.text = str(dmg)
