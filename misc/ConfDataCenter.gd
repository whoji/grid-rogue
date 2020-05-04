extends Node2D

# Keep in mind that section and property names can’t contain spaces.
# Anything after a space will be ignored on save and on load.

var conf_file = "res://misc/everything.cfg"
var conf_file_enemy = "res://conf/enemy.cfg"
var conf_file_level = "res://conf/level.cfg"
var conf = ConfigFile.new()
var conf_enemy = ConfigFile.new()
var conf_level = ConfigFile.new()
var err = conf.load(conf_file)
var err_enemy = conf_enemy.load(conf_file_enemy)
var err_level = conf_level.load(conf_file_level)

var level = {}
var enemy = {}

func _ready():
	if err != OK or err_enemy != OK or err_level != OK:
		print("CANNOT OPEN THE config file !!!")
		print(err)
		print(err_enemy)
		print(err_level)
	else:
		loadConf(conf, "section_example_003", "some_key")
		print(conf)
		print("ConfDataCenter self testing ... ok !")
		
		load_enemy_conf()
		load_level_conf()
		print(enemy)
		print(level)
		print("ConfDataCenter LOADING ... FINISHED !")
		print("==========")
		

func saveValue(_conf, section, key, value):
	_conf.set_value(section, key, value)
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
		
