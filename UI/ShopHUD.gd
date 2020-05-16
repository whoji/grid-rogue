extends CanvasLayer

#onready var game = get_tree().get_root().get_node("Game")

func _ready():
	#$LevelLabel.text = "Level: "+str(Global.current_level)
	$GoldLabel.text = "Gold: "+str(Global.gold)
	#$ExpLabel.text = "Exp: "+str(Global.exp_)
	#$StepLabel.text = "Step: "+str(game.steps)
	Global.connect("gold_changed", self,"set_GoldLabel")
	#Global.connect("level_changed", self,"set_LevelLabel")

func set_GoldLabel(val):
	$GoldLabel.text = "Gold: "+str(Global.gold)
