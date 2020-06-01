extends Node

# this is my IDLE

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var a = [1, 2 ,3 ]
	print(a) 
	print(len(a))
	print(a.size())
	var str11 = "%d != %d " % [1,2]
	print(str11)
	print("%d != %d " % [1,2])
	
	if 100 > 20:
		print("xxxxx")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
