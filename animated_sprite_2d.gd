extends AnimatedSprite2D

@export var start : bool

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = 	get_parent().get_node('player').global_position
	if start == true:
		
		animation_finished.emit() 
