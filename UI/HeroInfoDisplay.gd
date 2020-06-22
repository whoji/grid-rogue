extends Node2D

enum RUNE {
	GREEN, BLUE, PURPLE, RED
}

const HERO_TEXTURE_PATH_PREFIX = "res://asset/_hero_23x32_0525_PIPOYA/tile"
const HERO_TEXTURE_PATH_DEFAULT = "res://asset/enemy/enemy_0.png"
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
	elif Global.player_progression['found_heroes'][hero_id] == '0' \
			and Global.player_progression['owned_heroes'][hero_id] == '0':
		texture_path=HERO_TEXTURE_PATH_DEFAULT
		$CenterContainer/Sprite.texture = load(texture_path)
		$CenterContainer/VBoxContainer/NameLabel.text = 'No: ???'
		$CenterContainer/VBoxContainer/ATKLabel.text = 'ATK: ???'
		$CenterContainer/VBoxContainer/HPLabel.text = 'MaxHP: ???'
		$CenterContainer/LabelCost.text = "$???"
		$CenterContainer/SpriteLock.visible = false
	else:
		$CenterContainer/SpriteLock.visible = false
		$CenterContainer/LabelCost.visible = false
		

func update_hero_info_display_in_game():
	$CenterContainer/VBoxContainer/NameLabel.text = 'Lvl: '+str(Global.game.player.level)
	$CenterContainer/VBoxContainer/ATKLabel.text = 'ATK: '+str(Global.game.player.atk)
	$CenterContainer/VBoxContainer/HPLabel.text = 'HP: '+str(max(Global.game.player.hp,0))+'/'+str(Global.game.player.max_hp)
	$CenterContainer/VBoxContainer/ExpLabel.text = 'exp: '+str(Global.game.player.expr)+'/'+str(100)
	$CenterContainer/VBoxContainer/ExpLabel.visible = true
	update_rune_effect()

func update_rune_effect():
	var rune_type = Global.game.player.rune_effect
	if rune_type == null:
		$CenterContainer/SpriteRuneEffect.visible = false
		return 
	else:
		$CenterContainer/SpriteRuneEffect.visible = true		
	var turns_left = Global.game.player.rune_movement_counter - 1
	match rune_type:
		RUNE.GREEN:
			$CenterContainer/SpriteRuneEffect.region_rect = Rect2(32,48,16,16)
		RUNE.RED:
			$CenterContainer/SpriteRuneEffect.region_rect = Rect2(48,48,16,16)
		RUNE.PURPLE:
			$CenterContainer/SpriteRuneEffect.region_rect = Rect2(64,48,16,16)
		RUNE.BLUE:
			$CenterContainer/SpriteRuneEffect.region_rect = Rect2(16,48,16,16)
	$CenterContainer/SpriteRuneEffect/Label.text = str(turns_left)
		
