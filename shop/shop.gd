extends Control

const TILE_SIZE = 35
const TILE_OFFSET = Vector2(1,1)
onready var selector = $SelectorRect
onready var selector_gpos = Vector2(1,1)
onready var tween = get_node("Tween")
onready var flag_if_dialog_on = false

func _ready():
	pass # Replace with function body.

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
		
func move_grid(dx, dy):
	selector_gpos.x += dx 
	selector_gpos.y += dy
	var dest_position = (selector_gpos + TILE_OFFSET) * TILE_SIZE
	tween.interpolate_property(selector, "position",
		selector.rect_position, dest_position, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	selector.rect_position = selector_gpos * TILE_SIZE
	
func buy_hero():
	var hero_id = get_hero_id(selector_gpos)
#	if Global.gold >= Conf.heroes[hero_id]["gold"]:
#		pass
#	else:
#		print("YOU CANNOT AFFORD BUY THIS THING !!!...")
#		$PopupDialog/ColorRect.visible = true
	$PopupDialog/ColorRect.visible = true
	flag_if_dialog_on = true
	
func get_hero_id(selector_gpos):
	pass
