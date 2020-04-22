extends Node

var current_level = 0
var gold = 0
var exp_ = 0
var levels = [0, 1, 2, 3, 4]
var TitleScreen = "res://TitleScreen.tscn"
var GameOverScreen = "res://GameOverScreen.tscn"
var GameScene = "res://Game.tscn"

func restart():
	current_level = 0
	gold = 0
	exp_ = 0
	get_tree().change_scene(TitleScreen)

func next_level():
	current_level += 1
	if current_level < levels.size():
		# get_tree().change_scene(levels[current_level])
		pass
	else:
		restart()

func game_over():
	get_tree().change_scene(GameOverScreen)
	
