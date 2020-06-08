extends Control

const TILE_SIZE = 35
const TILE_OFFSET = Vector2(3,1)
const ROWS = 5
const COLS = 5
const ShopItemGrayOutBox = preload("res://UI/ShopItemGrayOutBox.tscn")
const EquipedFrame = preload("res://UI/EquipedFrame.tscn")
const HERO_TEXTURE_PATH_PREFIX = "res://asset/_hero_23x32_0525_PIPOYA/tile"
const IF_SELECTOR_RECT_INTIAL_ON_EQUIPED = true

onready var total_items = Conf.hero.size()
onready var selector = $SelectorRect
onready var selector_gpos = Vector2(0,0)
onready var tween = get_node("Tween")
onready var flag_if_dialog_on = false

func _ready():
	
	print("XXXX")
	print("XXXX")
	print(Conf.hero.size())
	print(total_items)
	
	#pass # Replace with function body.
	var i = 0
	var j = 0
	for item_id in range(total_items):
		if int(Conf.player_progression["found_heroes"][item_id]) == 0:
			# case 1: not found, not owned.
			add_item(i,j, "res://asset/enemy/enemy_0.png", false)
		elif int(Conf.player_progression["owned_heroes"][item_id]) == 0:
			# case 2:  found, but not owned yet.
			var hero_id = get_hero_id(Vector2(i,j))
			var hero_texure_path = HERO_TEXTURE_PATH_PREFIX + ("%03d"%hero_id) +".png"
			add_item(i,j, hero_texure_path, true)
		else:
			# case3:  owned
			var hero_id = get_hero_id(Vector2(i,j))
			var hero_texure_path = HERO_TEXTURE_PATH_PREFIX + ("%03d"%hero_id) +".png"
			if item_id == Global.equiped_hero:
				if IF_SELECTOR_RECT_INTIAL_ON_EQUIPED:
					selector_gpos = Vector2(i,j)
				add_item(i,j, hero_texure_path, false, true)
			else:			
				add_item(i,j, hero_texure_path, false, false)
		i += 1
		if i >= COLS:
			j += 1
			i = 0
	
	if IF_SELECTOR_RECT_INTIAL_ON_EQUIPED:
		selector.rect_position = (selector_gpos + TILE_OFFSET) * TILE_SIZE
	
	if Global.prevous_scene == "game_board":
		$ShopHUD.queue_free()
		$SelectorRect.visible = false

# grid position to read pixel position
func gpos_2_pos(gpos):
	var pos = (gpos + TILE_OFFSET) * TILE_SIZE
	return pos
	
func _input(event):
	if Global.prevous_scene != "game_board":
		if !event.is_pressed(): 
			return
		if event.is_action("ui_left") and selector_gpos.x > 0:
			move_grid(-1, 0)
		elif event.is_action("ui_right") and selector_gpos.x < COLS-1:
			move_grid(1, 0)
		elif event.is_action("ui_up") and selector_gpos.y > 0:
			move_grid(0, -1)
		elif event.is_action("ui_down")  and selector_gpos.y < ROWS-1:
			move_grid(0, 1)
		elif event.is_action("ui_select"):
			if flag_if_dialog_on:
				$PopupDialog/ColorRect.visible = false
				flag_if_dialog_on = false	
			else:
				buy_hero()
		elif event.is_action("ui_cancel"):
			Global.go_to_title_screen()

			
func move_grid(dx, dy):
	selector_gpos.x += dx 
	selector_gpos.y += dy
	#var dest_position = (selector_gpos + TILE_OFFSET) * TILE_SIZE
	var dest_position = gpos_2_pos(selector_gpos)
	tween.interpolate_property(selector, "rect_position",
		selector.rect_position, dest_position, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	selector.rect_position = selector_gpos * TILE_SIZE
	# print(get_hero_id(selector_gpos))
	
	$HeroInfoDisplay.update_hero_info_display_in_shop(get_hero_id(selector_gpos))
	
func buy_hero():
	var hero_id = get_hero_id(selector_gpos)
	#print(hero_id)
	#return 
	
#	print("XXXXXXXXXXXXXXXXX")
#	print(Conf.hero)
#	print(Conf.hero[0])
#	print("XXXXXXXXXXXXXXXXX")
#
	# Global.gold = 200

	var hero = Conf.hero[hero_id]
	
	if int(Conf.player_progression["owned_heroes"][hero_id]):
		# Equip hero
		equip_hero(hero_id)
		print("hero equiped: " + str(hero_id))
	elif int(Conf.player_progression["found_heroes"][hero_id]) and \
		int(Conf.player_progression["owned_heroes"][hero_id]) == 0:
		# Buy hero
		if Global.gold >= Conf.hero[hero_id]["cost"]:
			print("YOU BOUGHT THIS SHITTY HERO !!!...")
			Global.buy_hero_blue_print(hero_id)
			remove_grey_out(hero_id)
		else:
			print("YOU CANNOT AFFORD BUY THIS THING !!!...")
			$PopupDialog/ColorRect.visible = true
			flag_if_dialog_on = true
	
func get_hero_id(_selector_gpos):
	var adj_selector_gpos = _selector_gpos #- TILE_OFFSET
	return int(adj_selector_gpos.y  * COLS + adj_selector_gpos.x)
	
func add_item(i,j,texture_path="res://asset/hero/hero_0.png",greyed_out=false,equiped=false):
	print("adding shop item ...")
	var item_node = Sprite.new()
	var item_gpos = Vector2(i,j)
	item_node.centered = false
	item_node.position = gpos_2_pos(item_gpos)
	item_node.texture = load(texture_path)
	if greyed_out:
		var graybox = ShopItemGrayOutBox.instance()
		#graybox.rect_position = item_node.position
		item_node.add_child(graybox)
	if equiped:
		item_node.add_child(EquipedFrame.instance())
		
	$DisplayedItems.add_child(item_node)

func equip_hero(hero_id):
	if Global.equiped_hero != null:
		var prev_equipied_hero_id = Global.equiped_hero
		var prev_equipied_hero_display_node = $DisplayedItems.get_child(prev_equipied_hero_id)
		# prev_equipied_hero_display_node.flip_v = false
		# prev_equipied_hero_display_node.set_scale(Vector2(1,1))
		for n in prev_equipied_hero_display_node.get_children():
			#if n.get_type() == EquipedFrame:
			prev_equipied_hero_display_node.remove_child(n)
			n.queue_free()
		#prev_equipied_hero_display_node.remove_child()
	Global.equiped_hero = hero_id
	#$DisplayedItems.get_child(hero_id).flip_v = true
	# $DisplayedItems.get_child(hero_id).set_scale(Vector2(1.2,1.2))
	$DisplayedItems.get_child(hero_id).add_child(EquipedFrame.instance())
	
func remove_grey_out(hero_id):
	$DisplayedItems.get_child(hero_id).get_child(0).queue_free()
