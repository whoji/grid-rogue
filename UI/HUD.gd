extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelLabel.text = "Level: "+str(Global.current_level)
	$GoldLabel.text = "Level: "+str(Global.gold)
	$ExpLabel.text = "Level: "+str(Global.exp_)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
