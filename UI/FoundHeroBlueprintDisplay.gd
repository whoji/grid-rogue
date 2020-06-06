extends Node2D

var hero_id = 0
const HERO_TEXTURE_PATH_PREFIX = "res://asset/_hero_23x32_0525_PIPOYA/tile"



func _ready():
	pass # Replace with function body.

func update_hero_icon(_hero_id):
	self.hero_id = _hero_id
	var hero_texure_path = HERO_TEXTURE_PATH_PREFIX + ("%03d"%_hero_id) +".png"
	$SpriteReveal.texture = load(hero_texure_path)
			
func show_money():
	$SpriteGold.visible = true
	$SpriteArrow2.visible = true
