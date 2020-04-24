extends Node

var current_level = 0
var gold = 0 setget set_gold
var exp_ = 0
var levels = [0, 1, 2, 3, 4]
var TitleScreen = "res://UI/TitleScreen.tscn"
var GameOverScreen = "res://UI/GameOverScreen.tscn"
var GameScene = "res://board/Game.tscn"

signal gold_changed

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
	
func set_gold(val):
	gold = val
	emit_signal("gold_changed", gold)
