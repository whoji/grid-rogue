extends Node2D

enum SPAWN  {
	ENEMY, HP, GOLD, RUNE, STAIR, HERO_BP 
}
enum RUNE {
	GREEN, BLUE, PURPLE, RED
}
enum BP_RARITY {
	COMMON, RARE, EPIC, LEGENDARY
}

const TILE_SIZE = 32
var token_type = 1

var grid_position = Vector2(0,0)

onready var tween = get_node("Tween")
onready var game = get_tree().get_root().get_node("Game")

var val = 5
var buji_type = SPAWN.HP
var rune_type = RUNE.GREEN
var hero_bp_rarity = BP_RARITY.COMMON

const RandSpawnDecider = preload("res://RandSpawnDecider.gd")
onready var rand_spawn_decider = RandSpawnDecider.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# grid_position = position / TILE_SIZE
	if buji_type == SPAWN.HP:
		val = get_hp_amount()
		$Label.text = str(val)
		$Sprite.region_rect = Rect2(32, 224, 32, 32)
	elif buji_type == SPAWN.GOLD:
		val = get_gold_amount()
		$Label.text = str(val)
		#$Sprite.region_rect = Rect2(128, 224, 32, 32)
		$Sprite.visible = false
		$SpriteGold.visible = true
	elif buji_type == SPAWN.HERO_BP:
		$Sprite.visible = false
		val = rand_spawn_decider.get_new_hero_blueprint()
		# $Label.visible = false # NOTE: For test purpose, we don't hide it for me
		$Label.text = "["+str(val)+"]"
		self.hero_bp_rarity = get_hero_bp_rarity(val)
		print("RARITY ",self.hero_bp_rarity)
		if hero_bp_rarity == BP_RARITY.COMMON:
			$SpriteHeroBP/CommonHeroBP.visible = true
		elif hero_bp_rarity == BP_RARITY.RARE:
			$SpriteHeroBP/RareHeroBP.visible = true
		elif hero_bp_rarity == BP_RARITY.EPIC:
			$SpriteHeroBP/EpicHeroBP.visible = true
		elif hero_bp_rarity == BP_RARITY.LEGENDARY:
			$SpriteHeroBP/LegendaryHeroBP.visible = true
	elif buji_type == SPAWN.RUNE:
		rune_type = rand_spawn_decider.get_random_spawn_run_type()
		$Label.visible = false
		match rune_type:
			RUNE.GREEN:
				$Rune/Green.visible = true
			RUNE.RED:
				$Rune/Red.visible = true
			RUNE.PURPLE:
				$Rune/Purple.visible = true
			RUNE.BLUE:
				$Rune/Blue.visible = true
		
	position = (grid_position + game.MAP_OFFSET) * TILE_SIZE
	
func move_grid_simple(dir):
	if dir == "left":
		move_grid(-1, 0)
	elif dir == "right":
		move_grid(1, 0)
	elif dir == "up":
		move_grid(0, -1)
	elif dir == "down":
		move_grid(0, 1)
	else:
		move_grid(0, 0)
	
func move_grid(dx, dy):
	if not check_move_valid(dx, dy):
		return
	
	grid_position.x += dx 
	grid_position.y += dy
	
	var dest_position = (grid_position + game.MAP_OFFSET) * TILE_SIZE
	
	tween.interpolate_property(self, "position",
		position, dest_position, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	position = grid_position * TILE_SIZE
	
	game.map[grid_position.x][grid_position.y] = 2
	game.map[grid_position.x-dx][grid_position.y-dy] = 0 # FIXME

func check_move_valid(dx, dy):
	var _dest_grid_position = grid_position + Vector2(dx, dy)
	if _dest_grid_position.x < 0:
		return false
	elif _dest_grid_position.y < 0:
		return false
	elif _dest_grid_position.x >= game.MAP_SIZE.x:
		return false
	elif _dest_grid_position.y >= game.MAP_SIZE.y:
		return false
	else:
		return true

func die():
	queue_free()

func get_gold_amount():
	var a = 1.3
	var b = 1.5
	return int(1 + pow(rand_range(1.3,1.5), (Global.current_level+1)))

func get_hp_amount():
	var a = randi()%10+2
	var b = randi()%3
	var _hp = Global.game.player.hp
	return max(int(_hp/a + b),1)

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
