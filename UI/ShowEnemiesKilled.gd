extends Control

const ENEMY_DISPLAY_WIDTH = 48
const ENMEY_DISPLAY_OFFSET = Vector2(24, 48)
const ENEMY_TEXTURE_PATH_PREFIX = "res://asset/_enemy_32x32_0525_andhegames/tile"

var TitleScreen = "res://UI/TitleScreen.tscn"
onready var killed_enemies = Global.killed_enemies
onready var killed_enemies_count = {} # k:v = enemy_id:count

func _ready():
	#$msg_gold.text = "Gold Earned This Run: " + str(Global.gold)
	count_killed_enemies()
	display_killed_enemies()
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		pass
		#get_tree().change_scene(TitleScreen)	
	elif event.is_action_pressed("ui_up"):
		$ScrollContainer.scroll_vertical -= 30
	elif event.is_action_pressed("ui_down"):
		$ScrollContainer.scroll_vertical += 30
	

func count_killed_enemies():
	#print(killed_enemies)
	for hero_id in killed_enemies:
		if hero_id in killed_enemies_count:
			killed_enemies_count[hero_id] += 1
		else:
			killed_enemies_count[hero_id] = 1
	print(killed_enemies_count)
			
# dsa
# https://www.reddit.com/r/godot/comments/9h8r70/how_to_make_a_scrollable_grid_i_can_place_boxes_on/
func display_killed_enemies():
	for enemy_killed in killed_enemies_count:
		print(enemy_killed)
		var control_node_enemy_killed = Control.new()
		var sprite_enemy_killed = Sprite.new()
		var label_enemy_killed = Label.new()
		sprite_enemy_killed.texture = load(ENEMY_TEXTURE_PATH_PREFIX+str(enemy_killed)+".png")
		sprite_enemy_killed.centered = false
		label_enemy_killed.text = "x"+str(killed_enemies_count[enemy_killed])
		label_enemy_killed.set_position(Vector2(32,16))
		control_node_enemy_killed.add_child(sprite_enemy_killed)
		control_node_enemy_killed.add_child(label_enemy_killed)
		$ScrollContainer/GridContainer.add_child(control_node_enemy_killed)
		#self.add_child(sprite_enemy_killed)
	
	## to add some empty control node. so that scroll can function correctly...
	for i in range(4):
		var useless_control_node = Control.new()
		$ScrollContainer/GridContainer.add_child(useless_control_node)
