extends Node2D

const HERO_TEXTURE_PATH_PREFIX = "res://asset/_hero_23x32_0525_PIPOYA/tile"
var hero_id = 0
var atk
var hp
var max_hp
var level

func _ready():
	var texture_path="res://asset/hero/hero_0.png"
	texture_path = HERO_TEXTURE_PATH_PREFIX + ("%03d"%hero_id) +".png"
	print(texture_path)
	$CenterContainer/Sprite.texture = load(texture_path)
	update_hero_info_display(Global.equiped_hero)

func update_hero_info_display(_hero_id):
	hero_id = _hero_id
	var texture_path="res://asset/hero/hero_0.png"
	texture_path = HERO_TEXTURE_PATH_PREFIX + ("%03d"%hero_id) +".png"
	print(texture_path)
	$CenterContainer/Sprite.texture = load(texture_path)
