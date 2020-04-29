extends Node

const MAP_SIZE = Vector2(4,4)

var current_level = 0 #setget set_current_level
var gold = 0 setget set_gold
var exp_ = 0
var levels = [0, 1, 2, 3, 4]
var TitleScreen = "res://UI/TitleScreen.tscn"
var GameOverScreen = "res://UI/GameOverScreen.tscn"
var GameScene = "res://board/Game.tscn"

signal gold_changed
signal level_changed

onready var game = get_tree().get_root().get_node("Game")

func next_level():
	print(game)
	
	current_level += 1
	emit_signal("level_changed", current_level)
	if current_level < levels.size():
		# get_tree().change_scene(levels[current_level])
		game.clear_board()
		game.restart_board()
	else:
		game_restart()


func game_restart():
	print("game restarting ...")
	current_level = 0
	emit_signal("level_changed", current_level)	
	gold = 0
	exp_ = 0
	game.clear_board()
	game.restart_board()
	print("game restarted")
	print(game)
	

func game_over():
	
	get_tree().change_scene(GameOverScreen)
	
func set_gold(val):
	gold = val
	emit_signal("gold_changed", gold)

#func set_current_level(val):
#	current_level = val
#	emit_signal("level_changed", current_level)
	
func get_rand_gpos():
	randomize() #seed
	var x = randi() % int(MAP_SIZE.x)
	var y = randi() % int(MAP_SIZE.y)
	return Vector2(x,y)
