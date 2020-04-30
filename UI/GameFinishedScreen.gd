extends Control

var GameScene = "res://board/Game.tscn"

func _input(event):
	if event.is_action_pressed("ui_select"):
		get_tree().change_scene(GameScene)	

