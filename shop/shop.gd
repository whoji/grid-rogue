extends Control

const TILE_SIZE = 35
const TILE_OFFSET = Vector2(1,1)
const ROWS = 5
const COLS = 7
const TOTAL_ITEMS = 20
#const TOTAL_ITEMS = Conf.hero.size()
onready var selector = $SelectorRect
onready var selector_gpos = Vector2(0,0)
onready var tween = get_node("Tween")
onready var flag_if_dialog_on = false

func _ready():
	#pass # Replace with function body.
	var i = 0
	var j = 0
	for x in range(TOTAL_ITEMS):
		add_item(i,j)
		i += 1
		if i >= COLS:
			j += 1
			i = 0

# grid position to read pixel position
func gpos_2_pos(gpos):
	var pos = (gpos + TILE_OFFSET) * TILE_SIZE
	return pos
	
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
	if Global.gold >= Conf.hero[hero_id]["cost"]:
		print("YOU BOUGHT THIS SHITTY HERO !!!...")
		Global.gold -= hero["cost"]
		Global.player_progression["owned_heroes"][hero_id] = "1"
		print(Global.player_progression)
		## TODO check if already bought....
		Conf.save_player_progression()	
	else:
		print("YOU CANNOT AFFORD BUY THIS THING !!!...")
		$PopupDialog/ColorRect.visible = true
		flag_if_dialog_on = true
	
func get_hero_id(selector_gpos):
	var adj_selector_gpos = selector_gpos - TILE_OFFSET
	return int(adj_selector_gpos.y  * COLS + adj_selector_gpos.x)
	
	
func add_item(i,j,texture_path="res://asset/hero/hero_0.png"):
	print("adding shop item ...")
	var item_node = Sprite.new()
	var item_gpos = Vector2(i,j)
	item_node.centered = false
	item_node.position = gpos_2_pos(item_gpos)
	item_node.texture = load(texture_path)
	$DisplayedItems.add_child(item_node)

