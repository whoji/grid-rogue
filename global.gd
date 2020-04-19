extends Node

var current_level = 0
var levels = [0, 1, 2, 3, 4]
# var levels = ["res://ui/TitleScreen.tscn", "res://maps/Map01.tscn"]


func restart():
	current_level = 0
	# get_tree().change_scene(levels[current_level])

func next_level():
	current_level += 1
	if current_level < levels.size():
		get_tree().change_scene(levels[current_level])
	else:
		restart()
