extends Control


const all_cursor_pos = [Vector2(32, 96),Vector2(32, 128),Vector2(32, 160),Vector2(32, 192)]
onready var cursor_pos_idx = 0
onready var rect = $Rect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if !event.is_pressed(): 
		return
	elif event.is_action("ui_up"):
		cursor_pos_idx -= 1
		cursor_pos_idx = max(cursor_pos_idx, 0)
		move_rect()
	elif event.is_action("ui_down"):
		cursor_pos_idx += 1
		cursor_pos_idx = min(cursor_pos_idx, 3)
		move_rect()		
	elif event.is_action("ui_select"):
		if cursor_pos_idx == 0:
			Global.game_start()
		elif cursor_pos_idx == 3:
			get_tree().quit()
		elif cursor_pos_idx == 1:
			Global.go_to_shop("title")
	elif event.is_action("ui_secret_dev"):
		print("SECRET KEY PRESSED !!!!")
		print("SECRET KEY PRESSED !!!!")
		Global.gold = 0
		Global.found_heroes = []
		Global.killed_enemies = []

func move_rect():
	print(cursor_pos_idx)
	rect.rect_position = all_cursor_pos[cursor_pos_idx] + Vector2(10, 0)
