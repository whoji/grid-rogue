extends Node2D

const HERO_TEXTURE_PATH_PREFIX = "res://asset/_hero_23x32_0525_PIPOYA/tile"
var hero_id = 0
var atk
var hp
var max_hp
var level
var cost = 23

func _ready():
	var texture_path="res://asset/hero/hero_0.png"
	texture_path = HERO_TEXTURE_PATH_PREFIX + ("%03d"%hero_id) +".png"
	print(texture_path)
	$CenterContainer/Sprite.texture = load(texture_path)
	update_hero_info_display_in_shop(Global.equiped_hero)

func update_hero_info_display_in_shop(_hero_id):
	hero_id = _hero_id
	var texture_path="res://asset/hero/hero_0.png"
	texture_path = HERO_TEXTURE_PATH_PREFIX + ("%03d"%hero_id) +".png"
	print(texture_path)
	$CenterContainer/Sprite.texture = load(texture_path)
	$CenterContainer/VBoxContainer/NameLabel.text = 'No: '+str(hero_id)
	$CenterContainer/VBoxContainer/ATKLabel.text = 'ATK: '+str(Conf.hero[hero_id]['atk'])
	$CenterContainer/VBoxContainer/HPLabel.text = 'MaxHP: '+str(Conf.hero[hero_id]['max_hp'])
	$CenterContainer/LabelCost.text = "$"+str(Conf.hero[hero_id]['cost'])
	if Global.player_progression['found_heroes'][hero_id] == '1' \
			and Global.player_progression['owned_heroes'][hero_id] == '0':
		$CenterContainer/SpriteLock.visible = true
		$CenterContainer/LabelCost.visible = true
	else:
		$CenterContainer/SpriteLock.visible = false
		$CenterContainer/LabelCost.visible = false
		

func update_hero_info_display_in_game():
	$CenterContainer/VBoxContainer/NameLabel.text = 'Lvl: '+str(Global.game.player.level)
	$CenterContainer/VBoxContainer/ATKLabel.text = 'ATK: '+str(Global.game.player.atk)
	$CenterContainer/VBoxContainer/HPLabel.text = 'HP: '+str(max(Global.game.player.hp,0))+'/'+str(Global.game.player.max_hp)
	
