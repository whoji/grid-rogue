extends Control

const HERO_DISPLAY_WIDTH = 48
const HERO_DISPLAY_OFFSET = Vector2(24, 48)

var GameScene = "res://board/Game.tscn"
var TitleScreen = "res://UI/TitleScreen.tscn"
var FoundHeroBlueprintDisplay = preload("res://UI/FoundHeroBlueprintDisplay.tscn")
var num_hero_display = 0
var new_found_list = []


func _ready():
	$msg_gold.text = "Gold Earned This Run: " + str(Global.gold)
	# Global.found_heroes = [17, 18, 19,20]
	jiesuan_all_found_hero_blue_prints()
	#Global.unpack_all_found_hero_blue_prints()
	Global.unpack_uinque_found_hero_blue_prints(new_found_list)

func _input(event):
	if event.is_action_pressed("ui_select"):
		get_tree().change_scene(TitleScreen)	

func jiesuan_all_found_hero_blue_prints():
	print("========================= JIESUAN ==============")	
	print("FOUND HEROES: ", Global.found_heroes)
	for hero_id in Global.found_heroes:
		print("ADD hero_id %d" % [hero_id])
		var found_hero_bp_display = FoundHeroBlueprintDisplay.instance()
		found_hero_bp_display.position = HERO_DISPLAY_OFFSET + Vector2(num_hero_display*HERO_DISPLAY_WIDTH,0)
		found_hero_bp_display.update_hero_icon(hero_id)
		$FoundHeroes.add_child(found_hero_bp_display)
		num_hero_display += 1
		if Global.player_progression["found_heroes"][hero_id] == "0" and not hero_id in new_found_list:
			new_found_list.append(hero_id)
		else:
			found_hero_bp_display.show_money()		
	#print(Global.player_progression)
	#Conf.save_player_progression()	
