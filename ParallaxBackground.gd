extends ParallaxBackground

# Speed at which the background will move (in pixels per second)
var parallax_speed = Vector2(50, 0)  # Adjust the x and y values as needed

func _process(delta: float) -> void:
	# Move the background by adjusting the scroll_offset
	scroll_offset += parallax_speed * delta
