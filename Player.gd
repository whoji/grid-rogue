# reference : https://www.youtube.com/watch?time_continue=14&v=9laHKHYNyXc&feature=emb_logo

extends Node2D

const TILE_SIZE = 32

var grid_position = Vector2(0,0)

onready var tween = get_node("Tween")


# Called when the node enters the scene tree for the first time.
func _ready():
	grid_position = position / TILE_SIZE

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
	grid_position.x += dx 
	grid_position.y += dy
	
	tween.interpolate_property(self, "position",
		position, grid_position * TILE_SIZE, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	position = grid_position * TILE_SIZE


