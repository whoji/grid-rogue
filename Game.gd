extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAP_SIZE = Vector2(4,4)
const MAP_OFFSET = Vector2(3,2)
const ENEMY = [1, 2, 4, 8]
const EnemyScene = preload("res://enemy/Enemy.tscn")

onready var map = [] # 1 for player 2 for enemy
onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() #seed
	for i in range(MAP_SIZE.x):
		map.append([])
		for j in range(MAP_SIZE.y):
			map[i].append(0)

	map[player.grid_position.x][player.grid_position.y] = -1

	fill_enemy_to_map()
	print(map)
	render_board()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func fill_enemy_to_map():
	for i in range(MAP_SIZE.x):
		for j in range(MAP_SIZE.y):
			if map[i][j] == 0:
				map[i][j] = ENEMY[randi()%4]
	
func render_board():
	for i in range(MAP_SIZE.x):
		for j in range(MAP_SIZE.y):
			if map[i][j] > 0:
				var enemy_node = EnemyScene.instance()
				enemy_node.enemy_type = map[i][j]
				enemy_node.grid_position = Vector2(i,j)
				add_child(enemy_node)
				
