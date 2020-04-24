# reference : https://www.youtube.com/watch?time_continue=14&v=9laHKHYNyXc&feature=emb_logo

extends Node2D

const TILE_SIZE = 32

var grid_position = Vector2(0,0)

onready var tween = get_node("Tween")
onready var game = get_tree().get_root().get_node("Game")
onready var is_alive = true

var hp = 16
var atk = 4

signal player_moved
signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	# grid_position = position / TILE_SIZE
	$HP_Label.text = str(hp)
	$ATK_Label.text = str(atk)

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
	
	fight_with(grid_position.x+dx, grid_position.y+dy)
	
	emit_signal("player_moved",grid_position.x, grid_position.y, dx, dy)
	
	grid_position.x += dx 
	grid_position.y += dy
	
	var dest_position = (grid_position + game.MAP_OFFSET) * TILE_SIZE
	
	tween.interpolate_property(self, "position",
		position, dest_position, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	position = grid_position * TILE_SIZE
	
	game.map[grid_position.x][grid_position.y] = 1
	game.map[grid_position.x-dx][grid_position.y-dy] = 0 # FIXME
	print(game.map)

func check_move_valid(dx, dy):
	if not is_alive:
		return false
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

func fight_with(tgpos_x, tgpos_y):
	var token = game.map_enemy[tgpos_x][tgpos_y]
	print("token type :", token.token_type)
	if token.token_type == "Enemy":
		hp -= token.atk
		$HP_Label.text = str(hp)
	elif token.token_type == "Buji":
		hp += token.val
		$HP_Label.text = str(hp)
			
func die():
	is_alive = false
	emit_signal("dead")
	#yield(get_tree().create_timer(1.0), "timeout")
	#queue_free()
