extends Node2D
var pickup = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	 # Replace with function body.
	pass	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#global_position = Vector2(randi_range(player.health_pos_1.x,player.health_pos_2.x) , randi_range(player.health_pos_1.y,player.health_pos_2.y))
	$AnimatedSprite2D.play("default")


func _on_area_2d_area_entered(area):
	if area.is_in_group('player'):
		Health.inc_health(pickup)
		queue_free() # Replace with function body.


func _on_timer_timeout():
	queue_free() # Replace with function body.
