extends AnimatedSprite2D
var speed = 600
var direction : Vector2
var impact = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	global_position += direction*speed*delta
	if impact == false:
		play('fire')
		
	#look_at(get_global_mouse_position())
func bullet_impact():
	impact = true
	#print('boom')
	$Timer.start()
	play('impact')
	
func is_out_of_screen() -> bool:
	var screen_size = get_viewport_rect().size
	return global_position.x < 0 or global_position.y < 0 or global_position.x > screen_size.x or global_position.y > screen_size.y		


func _on_timer_timeout():
	queue_free() # Replace with function body.
