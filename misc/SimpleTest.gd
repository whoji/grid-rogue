extends Node

# this is my IDLE

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum TEST1 {GAME, BOY, ADVANCED}

# Called when the node enters the scene tree for the first time.
func _ready():
	var a = [1, 2 ,3 ]
	print(a) 
	print(len(a))
	print(a.size())
	var str11 = "%d != %d " % [1,2]
	print(str11)
	print("%d != %d " % [1,2])
	
	if 100 > 20:
		print("xxxxx")
	
	print(Conf.level)
	print(Conf.level.keys())

	print(rand_range(1.3,1.5))
	print(pow(2,10))
	
	print("--------------")
	var ret_type = get_random_spawn_type([0,1,2],[10,5,0.5])
	print(ret_type)
	
	print("--------------2")
	var alist = [1,2,3,4]
	if 1 in alist:
		print("1 is in alist")
	if not 8 in alist:
		print("8 is not in alist")
		
	print("---enum test --------")
	print(TEST1.GAME)
	print(TEST1.BOY)
	print(TEST1.GAME == 0)
	print(TEST1.BOY == 1)
	print(TEST1)
	

func _input(event):
	if event.is_action_pressed("ui_right"):
		$ScrollContainer.scroll_horizontal += 30
	elif event.is_action_pressed("ui_left"):
		$ScrollContainer.scroll_horizontal -= 30

func get_random_spawn_type(spawn_type, spawn_chance):
	assert (len(spawn_type) == len(spawn_chance),	"%d != %d " % [len(spawn_type),len(spawn_chance)])
	var chance_sum = 0
	for chance_weight in spawn_chance:
		chance_sum += chance_weight
	var random_float = rand_range(0, chance_sum)
	
	var SPAWN_CHANCE_cumulative = [spawn_chance[0]]
	for i in range(1,spawn_chance.size()):
		SPAWN_CHANCE_cumulative.append(SPAWN_CHANCE_cumulative[-1] + spawn_chance[i])
	
	for i in range(SPAWN_CHANCE_cumulative.size()):
		if chance_sum < SPAWN_CHANCE_cumulative[i]:
			# return i
			return spawn_type[i]
	return spawn_type[SPAWN_CHANCE_cumulative.size() - 1]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
