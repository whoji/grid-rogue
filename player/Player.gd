# reference : https://www.youtube.com/watch?time_continue=14&v=9laHKHYNyXc&feature=emb_logo

extends Node2D

const TILE_SIZE = 32
const HERO_TEXTURE_PATH_PREFIX = "res://asset/_hero_23x32_0525_PIPOYA/tile"

var grid_position = Vector2(1,1) setget set_grid_position

onready var tween = get_node("Tween")
onready var game = get_tree().get_root().get_node("Game")
onready var is_alive = true
onready var anim = $anim

var hp = 16
var atk = 4
var hero_id = 0

signal player_moved
signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	hero_id = Global.equiped_hero
	hp = Conf.hero[hero_id]['hp']
	atk = Conf.hero[hero_id]['atk']
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
		return	
	elif fight_result == 0:
		print("FIGHT_RESULT: LOSE !!!!")
		play_shake_anim(dx, dy)
		die()
		return	
		
	print("FIGHT_RESULT: WIN !!!!")
		
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
	# fight_result: [0,1,2,3] == player lose / player win / tie / other case
	var token = game.map_enemy[tgpos_x][tgpos_y]
	print("token type :", token.token_type)
	if token.token_type == 0: # enemy
		hp -= token.atk
		$HP_Label.text = str(hp)
		token.take_damage(atk)
		
		if hp > 0 and token.hp <=0: # case player win
			return 1
		elif hp > 0 and token.hp > 0: # case tie
			return 2
		elif hp <= 0: # player lose, but this case should trigger gg mechanism
			return 0 
		
	elif token.token_type == 1: # red potion
		hp += token.val
		$HP_Label.text = str(hp)
		return 1
	elif token.token_type == 2: # gold
		Global.gold += token.val
		#$HP_Label.text = str(hp)
		return 1
	elif token.token_type == 4: # stair
		game.has_stair = false
		Global.next_level()
		return 1
			
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
