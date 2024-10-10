extends Node2D
signal all_ene_dead
@export var spawn = false
@onready var  enemy = preload("res://Enemy/bandit.tscn")
@export var enemy_count = 35 
var enemies_spawned = 0
var spwanenemy = true
var player
var location_
func _ready():
	global_position=Vector2(0,0)
	player = get_parent().get_node('player').get_node('Ship')
	get_parent().global_position = Vector2(0,0)
	
	
func _physics_process(delta):
	if is_instance_valid(player):
		location_ = player.enemy_pos.global_position
	
	#print(spawn)
	
		
	if enemies_spawned >enemy_count:
		spwanenemy = false
		all_ene_dead.emit()
		
	#print(player.global_position)
	#_spawn_enemy()	
	
func _spawn_enemy(location:Vector2):
	#if spwanenemy == true:
		
			var enemy_instance = enemy.instantiate()
			
			
			get_parent().add_child(enemy_instance)
			
			enemy_instance.global_position =location + Vector2(randi_range(location.x,location.x+200),randi_range(location.y,location.y+200))

			enemies_spawned+=1
			#print(enemies_spawned)
func _on_timer_timeout():
	if spwanenemy == true:
		_spawn_enemy(location_) # Replace with function body.
