extends Node

class_name RandSpawnDecider

#const SPAWN_CHANCE = [10, 5, 5, 1] # enemy / HP / gold / relic
const SPAWN_TYPE = [0, 1, 2, 3, 4] # enemy / HP / gold / relic / stair
const SPAWN_CHANCE = [10, 5, 5, 0, 5] # enemy / HP / gold / relic / stair
const REAPER_START_STEPS = 10

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

func get_random_spawn_token_type():
	return get_random_spawn_type(SPAWN_TYPE, SPAWN_CHANCE)

func get_random_spawn_enemy_type(steps=0):
	var enemy_spawn = [] + Conf.level[Global.current_level]["spawn_enemy"]
	var enemy_spawn_chance = [] + Conf.level[Global.current_level]["spawn_chance"]
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
		
