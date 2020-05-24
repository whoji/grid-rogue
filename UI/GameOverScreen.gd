extends Control

var GameScene = "res://board/Game.tscn"
var TitleScreen = "res://UI/TitleScreen.tscn"

func _ready():
	$msg_gold.text = "Gold Earned This Run: " + str(Global.gold)

func _input(event):
	if event.is_action_pressed("ui_select"):
		get_tree().change_scene(TitleScreen)	

