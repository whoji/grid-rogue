extends Node2D


onready var player = get_tree().get_root().find_node("Player")


func _ready():
	pass

func connect_player(_player):
	self.player = _player
	player.connect("dead", self, "die")
	player.connect("eat_hero_bp", self, "eat_hero_bp")
	player.connect("eat_gold", self, "eat_gold")

func die():
	$DieSound.play()

func eat_hero_bp():
	$PickUpSound.play()
	
func eat_gold():
	$GoldSound.play()
