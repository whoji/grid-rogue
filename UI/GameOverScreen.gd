extends Control


func _input(event):
	if event.is_action_pressed("ui_select"):
		Global.game_restart()

