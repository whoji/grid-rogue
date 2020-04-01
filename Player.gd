# reference : https://www.youtube.com/watch?time_continue=14&v=9laHKHYNyXc&feature=emb_logo

extends Node2D

const TILE_SIZE = 32

var grid_position = Vector2(0,0)

onready var tween = get_node("Tween")
onready var game = get_tree().get_root().get_node("Game")

# Called when the node enters the scene tree for the first time.
func _ready():
	# grid_position = position / TILE_SIZE
	pass

func _input(event):
	if !event.is_pressed(): 
		return
	if event.is_action("ui_left"):
		move_grid(-1, 0)
	elif event.is_action("ui_right"):
		move_grid(1, 0)
	elif event.is_action("ui_up"):
		move_grid(0, -1)
	elif event.is_action("ui_down"):
		move_grid(0, 1)

func move_grid(dx, dy):
	
	if not check_move_valid(dx, dy):
		return
	
	grid_position.x += dx 
	grid_position.y += dy
	
	var dest_position = (grid_position + game.MAP_OFFSET) * TILE_SIZE
	
	tween.interpolate_property(self, "position",
		position, dest_position, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	position = grid_position * TILE_SIZE

func check_move_valid(dx, dy):
	var _dest_grid_position = grid_position + Vector2(dx, dy)
	if _dest_grid_position.x < 0:
		return false
	elif _dest_grid_position.y < 0:
		return false
	elif _dest_grid_position.x >= game.MAP_SIZE.x:
		return false
	elif _dest_grid_position.y >= game.MAP_SIZE.y:
		return false
	else:
		return true

