extends CanvasLayer


onready var game = get_tree().get_root().get_node("Game")


# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelLabel.text = "Level: "+str(Global.current_level)
	$GoldLabel.text = "Gold: "+str(Global.gold)
	$ExpLabel.text = "Exp: "+str(Global.exp_)
	$StepLabel.text = "Step: "+str(game.steps)
	Global.connect("gold_changed", self,"set_GoldLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_GoldLabel(val):
	$GoldLabel.text = "Gold: "+str(Global.gold)
