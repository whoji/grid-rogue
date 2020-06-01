extends Node

const MAP_SIZE = Vector2(4,4)
const TOTAL_HEROES_NUM = 25
const IF_USE_GRIM_REAPER = true

var current_level = 0 #setget set_current_level
var gold = 0 setget set_gold
var exp_ = 0
var levels = [0, 1, 2, 3, 4]
var TitleScreen = "res://UI/TitleScreen.tscn"
var GameOverScreen = "res://UI/GameOverScreen.tscn"
var GameFinishedScreen = "res://UI/GameFinishedScreen.tscn"
var GameScene = "res://board/Game.tscn"
var ShopScene = "res://shop/shop.tscn"
var equiped_hero = 0 # this is hero_id
var prevous_scene = ""

onready var player_progression = Conf.player_progression

signal gold_changed
signal level_changed

var game 

func next_level():
	game = get_tree().get_root().get_node("Game")
	print(game)
	
	current_level += 1
	emit_signal("level_changed", current_level)
	if current_level < levels.size():
		# get_tree().change_scene(levels[current_level])
		
		game.dark_out()
		game.set_process_input(0)
		game.player.set_process_input(0)
		yield(game.tween, "tween_completed")
		
		game.clear_board()
		game.restart_board()
		
		game.light_on()
		yield(game.tween, "tween_completed")
		game.set_process_input(1)
		game.player.set_process_input(1)
		
		game.steps = -1		
		Conf.save_player_progression()	
	else:
		game_finish()

func game_start():
	print("game starting ...")
	current_level = 0
	gold = 0
	exp_ = 0
	get_tree().change_scene(GameScene)

func game_finish():
	print("game finished ...")
	# current_level = 0
	# gold = 0
	# exp_ = 0
	get_tree().change_scene(GameFinishedScreen)

func game_restart():
	print("game restarting ...")
	Conf.save_player_progression()
	current_level = 0
	gold = 0
	exp_ = 0
	get_tree().change_scene(GameOverScreen)

func game_over():
	print("game over ...")	
	Conf.save_player_progression()		
	# current_level = 0
	# gold = 0
	# exp_ = 0
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

func go_to_shop(from_scene="title"):
	print("Go to shop from :" + from_scene)
	self.prevous_scene = from_scene
	Conf.save_player_progression()	
	print(get_tree().change_scene(ShopScene))

func go_to_title_screen(from_scene=""):
	print("Go to title screen from :" + from_scene)
	Conf.save_player_progression()		
	get_tree().change_scene(TitleScreen)
	
