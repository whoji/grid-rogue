extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAP_SIZE = Vector2(4,4)
const MAP_OFFSET = Vector2(3,2)
onready var map = [] # 1 for player 2 for enemy
onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(MAP_SIZE.x):
		map.append([])
		for j in range(MAP_SIZE.y):
			map[i].append(0)

	map[player.grid_position.x][player.grid_position.y] = 1

	print(map)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
