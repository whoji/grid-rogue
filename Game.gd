extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAP_SIZE = Vector2(4,4)
const MAP_OFFSET = Vector2(3,2)
const ENEMY = [1, 2, 4, 8]
const EnemyScene = preload("res://enemy/Enemy.tscn")

onready var map = [] # 1 for player 2 for enemy
onready var map_enemy = []
onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() #seed
	for i in range(MAP_SIZE.x):
		map.append([])
		map_enemy.append([])
		for j in range(MAP_SIZE.y):
			map[i].append(0)
			map_enemy[i].append(null)

	map[player.grid_position.x][player.grid_position.y] = -1

	fill_enemy_to_map()
	print(map)
	
	player.connect("player_moved",self, "post_player_move_fill")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fill_enemy_to_map():
	for i in range(MAP_SIZE.x):
		for j in range(MAP_SIZE.y):
			if map[i][j] == 0:
				#map[i][j] = ENEMY[randi()%4]
				add_rand_enemy(i,j)
	
func add_rand_enemy(i,j):
	var enemy_type = ENEMY[randi()%4]
	var enemy_node = EnemyScene.instance()
	map[i][j] = enemy_type
	enemy_node.enemy_type = enemy_type
	enemy_node.grid_position = Vector2(i,j)
	add_child(enemy_node)
	map_enemy[i][j] = enemy_node

func post_player_move_fill(x,y, dx, dy):
	# get enemie grid_pos behind player.
	var enemy_behind_gpos = [] # xxx
	if dx == -1 and dy == 0: # left
		for _x in range(x+1,MAP_SIZE.x):
			enemy_behind_gpos.append(Vector2(_x,y))
	elif dx == 1 and dy == 0: # right
		for _x in range(0,x):
			enemy_behind_gpos.append(Vector2(_x,y))	
	elif dx == 0 and dy == -1: # up
		for _y in range(y+1,MAP_SIZE.y):
			enemy_behind_gpos.append(Vector2(x,_y))
	elif dx == 0 and dy == 1: # down
		for _y in range(0,y):
			enemy_behind_gpos.append(Vector2(x,_y))
	else:
		print("ERROR !!")

	print(enemy_behind_gpos)

#	for enemy_gpos in enemy_behind_gpos:
#		var enemy = map_enemy[enemy_gpos.x][enemy_gpos.y]
#		map_enemy[enemy.grid_position.x][enemy.grid_position.y] = null		
#		enemy.move_grid(dx, dy)
#		map_enemy[enemy.grid_position.x][enemy.grid_position.y] = enemy
#
#	
	if map_enemy[player.grid_position.x+dx][player.grid_position.y+dy]:
		map_enemy[player.grid_position.x+dx][player.grid_position.y+dy].die()
		map_enemy[player.grid_position.x+dx][player.grid_position.y+dy] = null
	
	
#	for i in range(MAP_SIZE.x):
#		for j in range(MAP_SIZE.y):
#			#if map[i][j] == 0:
#			if map_enemy[i][j] == null:
#				print("adding enemy at ",i,j)
#				add_rand_enemy(i,j)

