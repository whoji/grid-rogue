extends Node

class_name RandSpawnDecider

enum SPAWN  {
	ENEMY, HP, GOLD, RUNE, STAIR, HERO_BP 
}

const SPAWN_TYPE = [0, 1, 2, 3, 4, 5] # enemy / HP / gold / rune / stair / hero_blueprint
const SPAWN_CHANCE = [10, 5, 5, 1, 5, 100] # enemy / HP / gold / rune / stair / hero_blueprint
const RUNE_TYPE = [0, 1, 2, 3] 
const RUNE_CHANCE = [1, 1, 1, 1]
const REAPER_START_STEPS = 10


func _ready():
	randomize()

func get_random_spawn_type(spawn_type, spawn_chance):
	assert (len(spawn_type) == len(spawn_chance),	"%d != %d " % [len(spawn_type),len(spawn_chance)])
	var chance_sum = 0
	for chance_weight in spawn_chance:
		chance_sum += chance_weight
	# var random_int = randi() % chance_sum
	var random_float = rand_range(0, chance_sum)
	
	var SPAWN_CHANCE_cumulative = [spawn_chance[0]]
	for i in range(1,spawn_chance.size()):
		SPAWN_CHANCE_cumulative.append(SPAWN_CHANCE_cumulative[-1] + spawn_chance[i])
	
	for i in range(SPAWN_CHANCE_cumulative.size()):
		# if random_int < SPAWN_CHANCE_cumulative[i]:
		if random_float < SPAWN_CHANCE_cumulative[i]:
			# return i
			return spawn_type[i]
	return spawn_type[SPAWN_CHANCE_cumulative.size() - 1]

func get_random_spawn_token_type():
	return get_random_spawn_type(SPAWN_TYPE, SPAWN_CHANCE)

func get_random_spawn_run_type():
	return get_random_spawn_type(RUNE_TYPE, RUNE_CHANCE)

func get_random_spawn_enemy_type(steps=0):
	#var enemy_spawn = [] + Conf.level[Global.current_level]["spawn_enemy"]
	#var enemy_spawn_chance = [] + Conf.level[Global.current_level]["spawn_chance"]
	var enemy_spawn = Conf.level[Global.current_level]["spawn_enemy"].duplicate()
	var enemy_spawn_chance = Conf.level[Global.current_level]["spawn_chance"].duplicate()
	if Global.IF_USE_GRIM_REAPER:
		enemy_spawn.append(1313)
		var reaper_spawn_chance = get_reaper_spawn_chance(steps)
		enemy_spawn_chance.append(reaper_spawn_chance)
	return get_random_spawn_type(enemy_spawn, enemy_spawn_chance)

func get_reaper_spawn_chance(steps):
	print("steps/REAPER_START_STEPS")
	print(steps)
	print(REAPER_START_STEPS)
	if steps <= REAPER_START_STEPS:
		return 0
	elif steps <= 2*REAPER_START_STEPS:
		return int(steps/20)
	elif steps <= 3*REAPER_START_STEPS:
		return int(steps/10)
	elif steps <= 4*REAPER_START_STEPS:
		return int(steps/5)
	elif steps > 4*REAPER_START_STEPS:
		return steps
	else:
		# assert(false)
		push_error("reaper chance error")
		
func get_new_hero_blueprint():
	"""
	HERE is the hero blueprint drop rate logic. 
	(6.4.2020 this function is NOT tested yet)
	"""
	var _max_floors = 100 # this should go to conf or global. temp put here.
	var _max_hero = Conf.hero.size() # this should go to conf or global. temp put here.
	var _base_chace_weight = 0.5 # this should go to conf or global. temp put here.
	var hero_id_list = []
	var hero_chance_list = []
	for _i in range(_max_hero):
		hero_id_list.append(_i)
		if _i < _max_hero / 2:
			hero_chance_list.append(_base_chace_weight)
		else:
			hero_chance_list.append(_base_chace_weight / 2)
	var _level = Global.current_level
	var center_ind = max(int(_level / _max_floors * _max_hero) - 1, 0)
	
	hero_chance_list[center_ind] += 20
	if center_ind+1 < _max_hero:
		hero_chance_list[center_ind+1] += 10 
	if center_ind+2 < _max_hero:
		hero_chance_list[center_ind+2] += 5 
	if center_ind-1 >= 0:
		hero_chance_list[center_ind-1] += 10 
	if center_ind-2 >= 0:
		hero_chance_list[center_ind-2] += 5 
	
	hero_chance_list[0] = 0
	var ret_hero_id = get_random_spawn_type(hero_id_list, hero_chance_list)
	print("RANDOM_HERO_BLUEPRINT_DROP: ", center_ind)
	print("RANDOM_HERO_BLUEPRINT_DROP: ", hero_chance_list)
	print("RANDOM_HERO_BLUEPRINT_DROP: ", ret_hero_id)
	return ret_hero_id
