extends CharacterBody2D

@onready var enemy_pos = $Enemy_genrator  
var speed = 400
var motion = Vector2()
var bullet = preload("res://Bullets/turret.tscn")
var fire_rate = 0.4 
var health = 20
var time_since_last_shot = 0.0
var is_alive = true
@export var health_pos_1:Vector2
@export var health_pos_2:Vector2
@onready var healthpack = preload("res://PLayer/health_pickup.tscn")
var pos:Vector2

func _ready():
	var health_timer = $health_timer
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_death_animation_finished"))

func _physics_process(delta):
	health_pos_1 = $health_pos.global_position
	health_pos_2 = $health_pos2.global_position
	pos = Vector2(randi_range(health_pos_1.x, health_pos_2.x), randi_range(health_pos_1.y, health_pos_2.y))
	
	if not is_alive:
		return
	
	motion = Vector2()
	
	if health <= 0 and is_alive:
		_die()

	# Movement and shooting logic
	if Input.is_action_pressed("up"):
		motion.y -= 1
		$CollisionShape2D/AnimatedSprite2D2.play("boost")
		Global.ship_dir = 1
	elif Input.is_action_pressed("down"):
		motion.y += 1
		$CollisionShape2D/AnimatedSprite2D2.play("idle")
		Global.ship_dir = 3
	elif Input.is_action_pressed("left"):
		motion.x -= 1
		$CollisionShape2D/left.play("blank")
		$CollisionShape2D/right.play("right")
		Global.ship_dir = 4
	elif Input.is_action_pressed("right"):
		motion.x += 1
		$CollisionShape2D/right.play("blank")
		$CollisionShape2D/left.play("left")
		Global.ship_dir = 2
	else:
		$CollisionShape2D/AnimatedSprite2D2.play("idle")
		$CollisionShape2D/right.play("blank")
		$CollisionShape2D/left.play("blank")
	
	time_since_last_shot += delta

	# Shooting logic
	var mouse_position = get_global_mouse_position()
	var bullet_position = $Marker2D.global_position
	var bullet_position_2 = $Marker2D2.global_position
	var bullet_direction = (mouse_position - bullet_position).normalized()  
	
	if Input.is_action_pressed("shoot") and time_since_last_shot >= fire_rate:
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = bullet_direction  
		bullet_instance.global_position = bullet_position  
		bullet_instance.rotation = bullet_direction.angle() 
		get_parent().add_child(bullet_instance)
		
		var bullet_instance_2 = bullet.instantiate() as Node2D
		bullet_instance_2.direction = bullet_direction 
		bullet_instance_2.global_position = bullet_position_2  
		bullet_instance_2.rotation = bullet_direction.angle() 
		get_parent().add_child(bullet_instance_2)
		time_since_last_shot = 0.0

	motion = motion.normalized() * speed
	velocity = motion
	move_and_slide()
	look_at(mouse_position)

func _die():
	is_alive = false
	$CollisionShape2D/Sprite2D.visible = false
	$CollisionShape2D/Wing4.visible = false
	$CollisionShape2D/Wing5.visible = false
	set_process_input(false)
	$AnimatedSprite2D.play("boom")  # Play death animation
	$CollisionShape2D.set_deferred("disabled", true)  # Disable collisions during death animation

func _on_death_animation_finished():
	if not is_alive:
		queue_free()  # Free the player only after the animation finishes

func give_health(pos: Vector2):
	var health_instance = healthpack.instantiate() as Node2D
	get_parent().add_child(health_instance)
	health_instance.global_position = pos

func _on_area_2d_area_entered(area):
	if area.is_in_group('e_bullet'):
		var e_bull = area.get_parent()
		e_bull.speed = 0
		e_bull.bullet_impact() 
		Health.dec_health(1)
		health -= 1

func _on_health_timer_timeout():
	give_health(pos)
