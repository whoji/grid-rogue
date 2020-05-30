extends Node2D

const TILE_SIZE = 32
const token_type = 0
const ENEMY_TEXTURE_PATH_PREFIX = "res://asset/_enemy_32x32_0525_andhegames/tile"

var grid_position = Vector2(0,0)

onready var tween = get_node("Tween")
onready var game = get_tree().get_root().get_node("Game")

var hp = 5
var atk = 2
var enemy_type = 0 #TODO: later change this to enemy_id

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = Conf.enemy[enemy_type]["hp"]
	atk = Conf.enemy[enemy_type]["atk"]
	# grid_position = position / TILE_SIZE
	$HP_Label.text = str(hp)
	$ATK_Label.text = str(atk)
	$Sprite.texture = load(ENEMY_TEXTURE_PATH_PREFIX+str(enemy_type)+".png")
	print(enemy_type)
	if $Sprite.texture == null:
		$Sprite.texture = load("res://asset/enemy/enemy_0.png")	
	position = (grid_position + game.MAP_OFFSET) * TILE_SIZE

func move_grid_simple(dir):
	if dir == "left":
		move_grid(-1, 0)
	elif dir == "right":
		move_grid(1, 0)
	elif dir == "up":
		move_grid(0, -1)
	elif dir == "down":
		move_grid(0, 1)
	else:
		move_grid(0, 0)
	
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
	
	game.map[grid_position.x][grid_position.y] = 2
	game.map[grid_position.x-dx][grid_position.y-dy] = 0 # FIXME

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

func take_damage(val):
	hp -= val
	$HP_Label.text = str(max(0, hp))
	
func die():
	queue_free()

