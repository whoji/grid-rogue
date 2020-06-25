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
		get_tree().change_scene(TitleScreen)	
	elif event.is_action_pressed("ui_up"):
		$ScrollContainer.scroll_vertical += 30
	elif event.is_action_pressed("ui_down"):
		$ScrollContainer.scroll_vertical -= 30

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
		var sprite_enemy_killed = Sprite.new()
		sprite_enemy_killed.texture = load(ENEMY_TEXTURE_PATH_PREFIX+str(enemy_killed)+".png")
		$ScrollContainer/GridContainer.add_child(sprite_enemy_killed)
		#self.add_child(sprite_enemy_killed)
