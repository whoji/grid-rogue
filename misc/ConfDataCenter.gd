extends Node2D

# Keep in mind that section and property names can’t contain spaces.
# Anything after a space will be ignored on save and on load.



var conf_file = "res://misc/everything.cfg"
var config = ConfigFile.new()
var err = config.load(conf_file)
var enemy_conf 

func _ready():
	if err != OK:
		print("CANNOT OPEN THE config file !!!")
	else:
		loadConf("section_example_003", "some_key")
		print(enemy_conf)

func saveValue(section, key, value):
	config.set_value(section, key, value)
	config.set_value(section, key, value)
	config.save(conf_file)

func loadConf(section, key, default_value=0):
	enemy_conf = config.get_value(section, key, default_value)
	
