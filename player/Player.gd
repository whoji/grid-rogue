# reference : https://www.youtube.com/watch?time_continue=14&v=9laHKHYNyXc&feature=emb_logo

extends Node2D

enum TOKEN_TYPE  {
	ENEMY, HP, GOLD, RUNE, STAIR, HERO_BP 
}

enum RUNE {
	GREEN, BLUE, PURPLE, RED
}

const TILE_SIZE = 32
const HERO_TEXTURE_PATH_PREFIX = "res://asset/_hero_23x32_0525_PIPOYA/tile"

var grid_position = Vector2(1,1) setget set_grid_position

onready var tween = get_node("Tween")
onready var game = get_tree().get_root().get_node("Game")
onready var hero_info_display = get_tree().get_root().get_node("Game/HeroInfoDisplay")
onready var is_alive = true
onready var anim = $anim

var level = 1
var hp = 16
var max_hp = 16
var atk = 4
var hero_id = 0
var expr = 0
var rune_movement_counter = 0
var rune_effect = null
var mod_atk = 1 # modifier
var mod_dmg_taken = 1 # modifier
var mod_expr_gain = 1 # modifier

signal player_moved
signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	hero_id = Global.equiped_hero
	max_hp = Conf.hero[hero_id]['max_hp']
	hp = max_hp
	atk = Conf.hero[hero_id]['atk']
	expr = 0
	print("Equiped hero: %d (atk: %d, hp: %d)" % [hero_id, atk, hp])
	var texture_path="res://asset/hero/hero_0.png"
	texture_path = HERO_TEXTURE_PATH_PREFIX + ("%03d"%hero_id) +".png"
	print(texture_path)
	$Sprite.texture = load(texture_path)
	# grid_position = position / TILE_SIZE
	$HP_Label.text = str(hp)
	$ATK_Label.text = str(atk)
	position = (grid_position + game.MAP_OFFSET) * TILE_SIZE

func _input(event):
	if !event.is_pressed(): 
		return
	if event.is_action("ui_left"):
		move_grid(-1, 0)
	elif event.is_action("ui_right"):
		move_grid(1, 0)
	elif event.is_action("ui_up"):
		move_grid(0, -1)
	elif event.is_action("ui_down"):
		move_grid(0, 1)

func move_grid(dx, dy):
	
	if not check_move_valid(dx, dy):
		return
	
	var fight_result = fight_with(grid_position.x+dx, grid_position.y+dy)
	
	if fight_result == 2:
		print("FIGHT_RESULT: TIE !!!!")
		play_shake_anim(dx, dy)
		hero_info_display.update_hero_info_display_in_game()
		return	
	elif fight_result == 0:
		print("FIGHT_RESULT: LOSE !!!!")
		play_shake_anim(dx, dy)
		hero_info_display.update_hero_info_display_in_game()
		die()
		return	
	elif fight_result == 1: # kill enemy
		print("FIGHT_RESULT: WIN !!!!")
		expr += 1 * Conf.hero[hero_id]['exp_gain'] * mod_expr_gain
		if expr >= 100:
			player_level_up()
	elif fight_result == -1: # non-enemy (e.g. eat the hp bottle)
		print("FIGHT_RESULT: NOT ENEMY !!!!")
		
		
	emit_signal("player_moved",grid_position.x, grid_position.y, dx, dy)
	
	grid_position.x += dx 
	grid_position.y += dy
	
	var dest_position = (grid_position + game.MAP_OFFSET) * TILE_SIZE
	
	tween.interpolate_property(self, "position",
		position, dest_position, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	position = grid_position * TILE_SIZE
	
	game.map[grid_position.x][grid_position.y] = 1
	game.map[grid_position.x-dx][grid_position.y-dy] = 0 # FIXME
	print(game.map)

func check_move_valid(dx, dy):
	if not is_alive:
		return false
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

func fight_with(tgpos_x, tgpos_y):
	apply_rune_effect()
	# fight_result: [0,1,2,3] == player lose / player win / tie / other case
	var token = game.map_enemy[tgpos_x][tgpos_y]
	print("token type :", token.token_type)
	if token.token_type == TOKEN_TYPE.ENEMY: # enemy
		hp -= token.atk * mod_dmg_taken
		$HP_Label.text = str(max(0, hp))
		token.take_damage(atk * mod_atk)
		
		if hp > 0 and token.hp <=0: # case player win
			return 1
		elif hp > 0 and token.hp > 0: # case tie
			return 2
		elif hp <= 0: # player lose, but this case should trigger gg mechanism
			return 0 
		
	elif token.token_type == TOKEN_TYPE.HP: # red potion
		hp += token.val
		hp = min(hp, max_hp)
		$HP_Label.text = str(hp)
		return -1
	elif token.token_type == TOKEN_TYPE.GOLD: # gold
		Global.gold += token.val
		#$HP_Label.text = str(hp)
		return -1
	elif token.token_type == TOKEN_TYPE.STAIR: # stair
		game.has_stair = false
		Global.next_level()
		return -1
	elif token.token_type == TOKEN_TYPE.HERO_BP: # hero_blueprint
		# Global.find_hero_blue_print(token.val)
		Global.found_heroes.append(token.val)
		return -1
	elif token.token_type == TOKEN_TYPE.RUNE:
		self.apply_rune_effect(token.rune_type)
		return -1
			
	
func die():
	is_alive = false
	emit_signal("dead")
	#yield(get_tree().create_timer(1.0), "timeout")
	#queue_free()

func set_grid_position(gpos):
	grid_position = gpos
	position = (gpos + game.MAP_OFFSET) * TILE_SIZE

func play_shake_anim(dx, dy):
	if dx == -1 and dy == 0:
		anim.play("shake_left")
	elif dx == 1 and dy == 0:
		anim.play("shake_right")
	elif dx == 0 and dy == -1:
		anim.play("shake_up")
	elif dx == 0 and dy == 1:
		anim.play("shake_down")
	yield(anim,"animation_finished")
	return
	
func player_level_up():
	if level >= Conf.hero[hero_id]['cap_level']:
		expr=100
		return
	var max_hp_inc = 1
	var atk_inc = 1
	if Conf.hero[hero_id]['atk_gain'].size() >= level-1:
		atk_inc = Conf.hero[hero_id]['atk_gain'][level-1]
	if Conf.hero[hero_id]['max_hp_gain'].size() >= level-1:
		max_hp_inc = Conf.hero[hero_id]['max_hp_gain'][level-1]
	expr = 0
	level += 1
	max_hp += max_hp_inc
	atk += atk_inc
	$HP_Label.text = str(hp)
	$ATK_Label.text = str(atk)
	if mod_atk > 1:
		$ATK_Label.text = str(atk)+"x"+str(mod_atk)
		
func apply_rune_effect(rune_type=null):
	"""
	put some of these conf into a conf file
	"""
	print("RUNE status: ", rune_effect, " ",rune_movement_counter)
	if rune_type != null: # new rune
		self.rune_effect = rune_type
		self.rune_movement_counter = 6 # actually allow 5 times effect
		match rune_type:
			RUNE.GREEN:
				hp += (0.1*hp) 
				hp = min(hp, max_hp)
				$HP_Label.text = str(hp)
			RUNE.BLUE:
				mod_atk = 2
				$ATK_Label.text = str(atk)+"x"+str(mod_atk)
			RUNE.PURPLE:
				mod_dmg_taken = 0
			RUNE.RED:
				mod_expr_gain = 2
				
	elif self.rune_movement_counter > 0: # effecting rune
		self.rune_movement_counter -= 1
		match self.rune_effect:
			RUNE.GREEN:
				hp += (0.1*max_hp) 
				hp = min(hp, max_hp)
				$HP_Label.text = str(hp)
				if self.rune_movement_counter == 0:
					self.rune_effect = null
			RUNE.BLUE:
				if self.rune_movement_counter == 0:
					self.rune_effect = null
					mod_atk = 1
					$ATK_Label.text = str(atk)
			RUNE.RED:
				if self.rune_movement_counter == 0:
					self.rune_effect = null
					mod_expr_gain = 1
			RUNE.PURPLE:
				if self.rune_movement_counter == 0:
					self.rune_effect = null
					mod_dmg_taken = 1
					
			
