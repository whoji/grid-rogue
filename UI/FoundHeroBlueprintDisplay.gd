extends Node2D

var hero_id = 0
const HERO_TEXTURE_PATH_PREFIX = "res://asset/_hero_23x32_0525_PIPOYA/tile"

enum BP_RARITY {
	COMMON, RARE, EPIC, LEGENDARY
}


func _ready():
	display_hero_bp_rarity()
	
func update_hero_icon(_hero_id):
	self.hero_id = _hero_id
	var hero_texure_path = HERO_TEXTURE_PATH_PREFIX + ("%03d"%_hero_id) +".png"
	$SpriteReveal.texture = load(hero_texure_path)
			
func show_money():
	$SpriteGold.visible = true
	$SpriteArrow2.visible = true
	var gold_val = round(Conf.hero[self.hero_id]["cost"] / Global.DUPLICATE_HERO_WORTH_FACTOR)
	$GoldValLabel.text = "+"+str(gold_val)+"g"
	$GoldValLabel.visible = true
	$DupLabel.visible = true

func display_hero_bp_rarity():
	var hero_bp_rarity = get_hero_bp_rarity(hero_id)
	if hero_bp_rarity == BP_RARITY.COMMON:
		$SpriteMysteryHero/CommonHeroBP.visible = true
	elif hero_bp_rarity == BP_RARITY.RARE:
		$SpriteMysteryHero/RareHeroBP.visible = true
	elif hero_bp_rarity == BP_RARITY.EPIC:
		$SpriteMysteryHero/EpicHeroBP.visible = true
	elif hero_bp_rarity == BP_RARITY.LEGENDARY:
		$SpriteMysteryHero/LegendaryHeroBP.visible = true			

func get_hero_bp_rarity(hero_id):
	if hero_id <= 6:
		return BP_RARITY.COMMON
	elif hero_id <= 12:
		return BP_RARITY.RARE
	elif hero_id <= 18:
		return BP_RARITY.EPIC
	elif hero_id <= 24:
		return BP_RARITY.LEGENDARY	
	else:
		return BP_RARITY.COMMON
