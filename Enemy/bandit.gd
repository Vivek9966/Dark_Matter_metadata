extends CharacterBody2D
var avoidance_vector = Vector2(0,0)
var health = 25
var speed = 400
var motion = Vector2()
var bullet 
var player 
@export var fire_rate = 0.6
var time_since_last_shot = 0.0
var lerp_speed = 0.04
var bullet_direction
var bullet_pos_1
var bullet_pos_2
var is_alive = true
@onready var healthbar = $E_health_bar

func _ready():
	player = get_parent().get_parent().get_child(2).get_child(0)
	healthbar._init_health(health)
	bullet = preload("res://Bullets/enemy_bullet.tscn")
	global_position = Vector2(0, 0)
	
	$Timer.connect("timeout", Callable(self, "_on_timer_timeout"))  # Correct signal connection

func _physics_process(delta):
	
	if  not is_alive:
		return  # Stop actions if player or enemy is dead
	if is_instance_valid(player):
		var enemies = get_tree().get_nodes_in_group("enemy")
	################################################
		for enemy in enemies:
			if enemy != self:
				var distance = global_position.distance_to(enemy.global_position)
				if distance < 50:  # 50 is the minimum distance you want to maintain
					avoidance_vector = (global_position - enemy.global_position).normalized()
				
	#####################################################			
		time_since_last_shot += delta
		$AnimatedSprite2D.play('default')
		$AnimatedSprite2D2.play('default')
		global_position = global_position.lerp(player.global_position+avoidance_vector, lerp_speed)
		look_at(player.global_position)
		
		fire()
		speed = 200
		
		bullet_pos_1 = $Marker2D.global_position
		bullet_pos_2 = $Marker2D/Marker2D2.global_position
		bullet_direction = (player.global_position - bullet_pos_1).normalized()

		if health <= 0 and is_alive:
			is_alive = false
			die()

		if player.global_position.distance_to(global_position) > 400:
			speed = 500
			lerp_speed = 0.04
		else:
			speed = 300
			lerp_speed = 0.03

func fire():
	if not is_alive:
		return  # Don't fire if dead

	if player.global_position.distance_to(global_position) <= 350:
		if time_since_last_shot >= fire_rate:
			var bullet_instance_1 = bullet.instantiate() as Node2D
			var bullet_instance_2 = bullet.instantiate() as Node2D
			get_parent().get_parent().add_child(bullet_instance_1)
			get_parent().get_parent().add_child(bullet_instance_2)
			bullet_instance_1.direction = bullet_direction
			bullet_instance_1.rotation = bullet_direction.angle() + PI / 2
			bullet_instance_1.position = bullet_pos_1
			
			bullet_instance_2.direction = bullet_direction
			bullet_instance_2.rotation = bullet_direction.angle() + PI / 2
			bullet_instance_2.position = bullet_pos_2
			
			time_since_last_shot = 0
	elif 	player.global_position.distance_to(global_position) <= 500:
			fire_rate = 0.6
			if time_since_last_shot >= fire_rate:
				var bullet_instance_1 = bullet.instantiate() as Node2D
				var bullet_instance_2 = bullet.instantiate() as Node2D
				get_parent().get_parent().add_child(bullet_instance_1)
				get_parent().get_parent().add_child(bullet_instance_2)
				bullet_instance_1.direction = bullet_direction
				bullet_instance_1.rotation = bullet_direction.angle() + PI / 2
				bullet_instance_1.position = bullet_pos_1
				
				bullet_instance_2.direction = bullet_direction
				bullet_instance_2.rotation = bullet_direction.angle() + PI / 2
				bullet_instance_2.position = bullet_pos_2
				
				time_since_last_shot = 0		

func die():
	if not is_alive:
		
		$SpaceshipAsset.visible =false
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D2.stop()
		$Timer.start()  # Start the timer for the delay before destruction
		get_node("boom_").play('default')  # Play explosion animation or sound

func _on_area_2d_area_entered(area):
	if area.is_in_group('p_bullet') and is_alive:
		area.get_parent().speed = 0
		area.get_parent().bullet_impact()
		health -= 3
		healthbar._set_health(health)

func _on_timer_timeout():
	get_parent().queue_free()  # Free the enemy after the timer ends
