extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAP_SIZE = Vector2(4,4)
const MAP_OFFSET = Vector2(3,2)
const ENEMY = [1, 2, 4, 8]
const EnemyScene = preload("res://enemy/Enemy.tscn")
const BujiScene = preload("res://item/buji.tscn")
const StairScene = preload("res://item/Stair.tscn")
#const SPAWN_CHANCE = [10, 5, 5, 1] # enemy / HP / gold / relic
const SPAWN_TYPE = [0, 1, 2, 3, 4] # enemy / HP / gold / relic / stair
const SPAWN_CHANCE = [10, 0, 0, 0, 20] # enemy / HP / gold / relic / stair

var steps = 0
onready var has_stair = 0
onready var map = [] # 1 for player 2 for enemy
onready var map_enemy = []
onready var player
# onready var player = $Player
var enemy_spawn
var enemy_spawn_chance


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() #seed	
	restart_board()
	player.connect("player_moved",self, "post_player_move_fill")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# FOR test and debug only !!!
func _input(event):
	if event.is_action_pressed("ui_test"):
		#get_tree().reload_current_scene()
		#clear_board(); restart_board()
		Global.next_level()

func clear_board():
	steps = 0
	$HUD/StepLabel.text = "Step: "+str(steps)
	map = []
	for i in range(MAP_SIZE.x):
		for j in range(MAP_SIZE.y):
			if map_enemy[i][j] != null:
				map_enemy[i][j].die()

#func restart_board(player.gpos): # restart or initialize the board when the game start. or next level
func restart_board(): # restart or initialize the board when the game start. or next level
	# load the enemy spawn conf
	enemy_spawn = Conf.level[Global.current_level]["spawn_enemy"]
	enemy_spawn_chance = Conf.level[Global.current_level]["spawn_chance"]
	# fill the player
	if player == null:
		player = $Player
		player.grid_position = Global.get_rand_gpos()
	map = []
	for i in range(MAP_SIZE.x):
		map.append([])
		map_enemy.append([])
		for j in range(MAP_SIZE.y):
			map[i].append(0)
			map_enemy[i].append(null)
	map[player.grid_position.x][player.grid_position.y] = -1
	fill_enemy_to_map()
	print(map)

func fill_enemy_to_map():
	for i in range(MAP_SIZE.x):
		for j in range(MAP_SIZE.y):
			if map[i][j] == 0:
				#map[i][j] = ENEMY[randi()%4]
				add_rand_enemy(i,j)
	
func add_rand_enemy(i,j):
	print("adding enemey ...")
	#var enemy_type = ENEMY[randi()%4]
	var enemy_type = get_random_spawn_type(enemy_spawn, enemy_spawn_chance)
	var enemy_node = EnemyScene.instance()
	map[i][j] = enemy_type
	enemy_node.enemy_type = enemy_type
	enemy_node.grid_position = Vector2(i,j)
	add_child(enemy_node)
	map_enemy[i][j] = enemy_node

func add_buji(i,j, token_type):
	print("adding buji ...")	
	var buji_type = token_type # ENEMY[randi()%4]
	var buji_node = BujiScene.instance()
	map[i][j] = 1000 + buji_type
	buji_node.token_type = token_type
	buji_node.buji_type = buji_type
	buji_node.grid_position = Vector2(i,j)
	add_child(buji_node)
	map_enemy[i][j] = buji_node

func add_stair(i,j):
	print("adding stair !!!")
	var stair_node = StairScene.instance()
	map[i][j] = 2000
	stair_node.grid_position = Vector2(i,j)
	add_child(stair_node)
	map_enemy[i][j] = stair_node

func post_player_move_fill(x,y, dx, dy):
	steps +=  1
	$HUD/StepLabel.text = "Step: "+str(steps)
	print("steps:  "+str(steps))
	var player_dest_grid_pos = Vector2(player.grid_position.x+dx, player.grid_position.y+dy)
	# STEP -1: check if player_die
	#fight_with(player_dest_grid_pos)
	
	# STEP 0: Get enemie grid_pos behind player.
	var enemy_behind_gpos = [] # xxx
	var empty_gpos = Vector2.ZERO
	if dx == -1 and dy == 0: # left
		empty_gpos = Vector2(MAP_SIZE.x-1,y)
		for _x in range(x+1,MAP_SIZE.x):
			enemy_behind_gpos.append(Vector2(_x,y))
	elif dx == 1 and dy == 0: # right
		empty_gpos = Vector2(0,y)
		for _x in range(0,x):
			enemy_behind_gpos.push_front(Vector2(_x,y))	
	elif dx == 0 and dy == -1: # up
		empty_gpos = Vector2(x,MAP_SIZE.y-1)
		for _y in range(y+1,MAP_SIZE.y):
			enemy_behind_gpos.append(Vector2(x,_y))
	elif dx == 0 and dy == 1: # down
		empty_gpos = Vector2(x,0)
		for _y in range(0,y):
			enemy_behind_gpos.push_front(Vector2(x,_y))
	else:
		print("ERROR !!")

	print(enemy_behind_gpos)
	print(empty_gpos)	
	print("qqqqqqqqqqqqqqqqqqqq")	

	# STEP 1: move the enemies.
	for enemy_gpos in enemy_behind_gpos:
		var enemy = map_enemy[enemy_gpos.x][enemy_gpos.y]
		map_enemy[enemy.grid_position.x][enemy.grid_position.y] = null		
		enemy.move_grid(dx, dy)
		map_enemy[enemy.grid_position.x][enemy.grid_position.y] = enemy
	
	# STEP 2: with 50% chance. move the other enemies.
	if randi() % 2 == 0:
		assert(empty_gpos.x == 0 or empty_gpos.y == 0 or 
			empty_gpos.x == MAP_SIZE.x-1 or empty_gpos.y == MAP_SIZE.y-1)
		var _ret_val = get_valid_enemy_behind_gpos_orth_set(empty_gpos, player_dest_grid_pos)
		var enemy_behind_gpos_orth = _ret_val[0] 
		var dir_orth = _ret_val[1]
		print(enemy_behind_gpos_orth)	
		print(dir_orth)	
		print("wwwwwwwwwwwwwwwwwwwwww")	
	
		#STEP 2b: move the orth token.
		for enemy_gpos in enemy_behind_gpos_orth:
			var enemy = map_enemy[enemy_gpos.x][enemy_gpos.y]
			map_enemy[enemy.grid_position.x][enemy.grid_position.y] = null		
			enemy.move_grid(dir_orth.x, dir_orth.y)
			map_enemy[enemy.grid_position.x][enemy.grid_position.y] = enemy

	# STEP 3: handle the map_enemy
	if map_enemy[player.grid_position.x+dx][player.grid_position.y+dy]:
		map_enemy[player.grid_position.x+dx][player.grid_position.y+dy].die()
		map_enemy[player.grid_position.x+dx][player.grid_position.y+dy] = null
	
	# STEP 4: ADD NEW TOKEN (ENMEY or ITEMS, etc) to the board
	for i in range(MAP_SIZE.x):
		for j in range(MAP_SIZE.y):
			#if map[i][j] == 0:
			if map_enemy[i][j] == null and Vector2(i,j)!= player_dest_grid_pos:
				var token_type = get_random_spawn_type(SPAWN_TYPE, SPAWN_CHANCE)
				print("adding token type-",token_type," at ",i,j)
				if token_type == 0: # for enemy
					add_rand_enemy(i,j)
				elif token_type == 1 or token_type == 2: # for buji (HP)
					add_buji(i,j,token_type)
				elif token_type == 4 and not has_stair: # for stair
					has_stair = 1
					add_stair(i,j)
				else:
					add_rand_enemy(i,j)
					
	
	# STEP 5: check if player die
	if player.hp <= 0:
		player.die()
	print("---------------------")

func get_valid_enemy_behind_gpos_orth_set(empty_gpos, player_dest_grid_pos):
	var dir_orth_0 = Vector2.DOWN
	var dir_orth_1 = Vector2.UP
	var dir_orth_2 = Vector2.RIGHT
	var dir_orth_3 = Vector2.LEFT
	
	var set_0 =  []
	var set_1 =  []
	var set_2 =  []
	var set_3 =  []
	
	for _y in range(0, empty_gpos.y):
		set_0.push_front(Vector2(empty_gpos.x, _y))
	for _y in range(empty_gpos.y+1, MAP_SIZE.y):
		set_1.append(Vector2(empty_gpos.x, _y))
	for _x in range(0, empty_gpos.x):
		set_2.push_front(Vector2(_x, empty_gpos.y))
	for _x in range(empty_gpos.x+1, MAP_SIZE.x):
		set_3.append(Vector2(_x, empty_gpos.y))
	
	if player_dest_grid_pos in set_0:
		set_0 = []
	if player_dest_grid_pos in set_1:
		set_1 = []
	if player_dest_grid_pos in set_2:
		set_2 = []
	if player_dest_grid_pos in set_3:
		set_3 = []
		
	var max_set_size = 0
	max_set_size = max(max_set_size, set_0.size())
	max_set_size = max(max_set_size, set_1.size())
	max_set_size = max(max_set_size, set_2.size())
	max_set_size = max(max_set_size, set_3.size())

	if max_set_size == set_0.size():
		return [set_0, dir_orth_0]
	elif  max_set_size == set_1.size():
		return [set_1, dir_orth_1]
	elif  max_set_size == set_2.size():
		return [set_2, dir_orth_2]
	elif  max_set_size == set_3.size():
		return [set_3, dir_orth_3]
	else:
		assert(1 == 0)

func get_random_spawn_type(spawn_type, spawn_chance):
	assert (len(spawn_type) == len(spawn_chance),	"%d != %d " % [len(spawn_type),len(spawn_chance)])
	var chance_sum = 0
	for chance_weight in spawn_chance:
		chance_sum += chance_weight
	var random_int = randi() % chance_sum
	
	var SPAWN_CHANCE_cumulative = [spawn_chance[0]]
	for i in range(1,spawn_chance.size()):
		SPAWN_CHANCE_cumulative.append(SPAWN_CHANCE_cumulative[-1] + spawn_chance[i])
	
	for i in range(SPAWN_CHANCE_cumulative.size()):
		if random_int < SPAWN_CHANCE_cumulative[i]:
			# return i
			return spawn_type[i]
	return spawn_type[SPAWN_CHANCE_cumulative.size() - 1]

#func has_stair_on_board():
#	print("checking if already has stair ...")
#	for i in range(MAP_SIZE.x):
#		for j in range(MAP_SIZE.y):
#			print( map_enemy[i][j])
#			if map_enemy[i][j] != null and map_enemy[i][i].token_type == 4:
#				print("already 1 stair on board !!!")
#				return true
#	return false

func _on_Player_dead():
	yield(get_tree().create_timer(1.0), "timeout")
	player.queue_free()
	Global.game_over()
	
