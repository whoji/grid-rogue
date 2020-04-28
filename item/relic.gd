extends "res://item/buji.gd"


var relic_type = 0

func _init():
	token_type = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	# grid_position = position / TILE_SIZE
	if relic_type == 1:
		#$Label.text = str(val)
		$Sprite.region_rect = Rect2(128, 192, 32, 32)
	elif relic_type == 2:
		#$Label.text = str(val)
		$Sprite.region_rect = Rect2(96, 288, 32, 32)
	position = (grid_position + game.MAP_OFFSET) * TILE_SIZE
	
