extends Node2D

# Keep in mind that section and property names can’t contain spaces.
# Anything after a space will be ignored on save and on load.

var conf_file = "res://misc/everything.cfg"
var conf_file_enemy = "res://conf/enemy.cfg"
var conf_file_level = "res://conf/level.cfg"
var conf_file_hero = "res://conf/hero.cfg"
var save_file = "res://misc/save_file.cfg" # for player progression only
var conf = ConfigFile.new()
var conf_enemy = ConfigFile.new()
var conf_level = ConfigFile.new()
var conf_hero = ConfigFile.new()
var player_save = ConfigFile.new()
var err = conf.load(conf_file)
var err_enemy = conf_enemy.load(conf_file_enemy)
var err_level = conf_level.load(conf_file_level)
var err_hero = conf_hero.load(conf_file_hero)
var err_save = player_save.load(save_file)

var level = {}
var enemy = {}
var hero = {}
var player_progression = {}

func _ready():
	if err != OK or err_enemy != OK or err_level != OK or err_hero != OK:
		print("CANNOT OPEN THE config file !!!")
		print(err)
		print(err_enemy)
		print(err_level)
		print(err_hero)
	else:
		loadConf(conf, "section_example_003", "some_key")
		print(conf)
		print("ConfDataCenter self testing ... ok !")
		
		load_enemy_conf()
		load_level_conf()
		load_hero_conf()

		#print(enemy)
		#print(level)
		#print(hero)
		print("ConfDataCenter LOADING ... FINISHED !")
		print("==========")
		
	if err_save != OK:
		print("CANNOT OPEN THE PLAYER SAVE FILE !!!!!!")
		print(err_save)
	else:
		load_save_file()

func saveValue(_conf, section, key, value):
	_conf.set_value(section, key, value)
	_conf.save(conf_file)

func loadConf(_conf, section, key, default_value=0):
	var _val = _conf.get_value(section, key, default_value)
	
func load_enemy_conf():
	var sections = conf_enemy.get_sections()
	for i in range(sections.size()):
		var section_key = "enemy_"+str(i)
		var lvl = conf_enemy.get_value(section_key, "level" , -1)
		var atk = conf_enemy.get_value(section_key, "atk" , -1)
		var hp  = conf_enemy.get_value(section_key, "hp" , -1)
		#self.enemy.append({"level":lvl, "atk":atk, "hp":hp})
		self.enemy[i] = {"level":lvl, "atk":atk, "hp":hp}
		
func load_level_conf():
	var sections = conf_level.get_sections()
	for i in range(sections.size()):
		var section_key = "level_"+str(i)
		var spawn_enemy = conf_level.get_value(section_key, "spawn_enemy" , [])
		var spawn_chance= conf_level.get_value(section_key, "spawn_chance" , [])
		#self.level.append({"spawn_enemy":spawn_enemy, "spawn_chance":spawn_chance})
		self.level[i] = {"spawn_enemy":spawn_enemy, "spawn_chance":spawn_chance}
	Global.levels = self.level.keys()
	
func load_hero_conf():
	var sections = conf_hero.get_sections()
	#print(sections)
	for i in range(sections.size()):
		var section = "hero_"+str(i)
		var id = conf_hero.get_value(section, "id" , -1)
		self.hero[id] = {}
		var keys = conf_hero.get_section_keys(section)
		for key in keys:
			self.hero[id][key] = conf_hero.get_value(section, key , -1)
		
	#print(self.hero.size())
			
func load_save_file():
	# print("NOT IMPLEMENTED YET: LOAD SAVE FILE...")
	# pass
	var _sections = player_save.get_sections()
	var owned_heroes = player_save.get_value("unlocks", "owned_heroes" , get_default_owned_heroes_string())
	var found_heroes = player_save.get_value("unlocks", "found_heroes" , get_default_owned_heroes_string())
	var owned_items = player_save.get_value("unlocks", "owned_items" , get_default_owned_heroes_string())
	player_progression["owned_heroes"] = owned_heroes
	player_progression["found_heroes"] = found_heroes
	player_progression["owned_items"] = owned_items
	Global.equiped_hero =  player_save.get_value("basics", "equiped_hero" , 0)
	Global.gold =  player_save.get_value("basics", "gold" , 0)
	Global.found_heroes =  player_save.get_value("basics", "found_heroes =" , [])
	#print("xx")
	#print(player_progression)

func get_default_owned_heroes_string():
	var _ret = ""
	for _i in range(Global.TOTAL_HEROES_NUM):
		_ret += "0"
	return _ret

func save_player_progression():
	print("save_player_progression()")
	save_player_basics()
	#saveValue(player_save, "unlocks", "test001","1234")
	player_save.set_value("unlocks", "owned_heroes",player_progression["owned_heroes"])
	player_save.set_value("unlocks", "found_heroes",player_progression["found_heroes"])
	player_save.set_value("unlocks", "owned_items",player_progression["owned_items"])
	player_save.save(save_file)

func save_player_basics():
	player_save.set_value("basics", "gold", Global.gold)
	player_save.set_value("basics", "found_heroes", Global.found_heroes)
	player_save.set_value("basics", "equiped_hero", Global.equiped_hero)
	player_save.save(save_file)
	
	
