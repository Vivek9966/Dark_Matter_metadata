extends Node2D
var enemy = preload("res://Enemy/bandit.gd")
@onready var enemy_spawner = preload("res://enemy_spawner_1.tscn")
var enemies_alive : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.start('timeline_1')# Replace with function body.
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	enemies_alive = check_enemies_alive()
	$AnimatedSprite2D.global_position = $player/Ship.global_position
	
func check_enemies_alive() -> bool:

	for node in get_tree().current_scene.get_children():
		if node.is_in_group('enemy_'):
			return true
	return false
		
	
	



func _on_entry_area_entered(area):
	if area.is_in_group('player'):
		Dialogic.start('timeline_2')# Replace with function body.
		
		get_node('ISS_Isamora/entry').queue_free()
		var enemy_spawner_instance =enemy_spawner.instantiate() 
		add_child(enemy_spawner_instance)
		await $enemy_spawner.all_ene_dead
		while enemies_alive:
			await get_tree().create_timer(0.5).timeout
			
		Dialogic.start('timeline_3')
		$Timer.start()
		
		

func _on_timer_timeout():
	$AnimatedSprite2D/AnimationPlayer.play('new_animation') 
	$AnimatedSprite2D.play("default")
	$player.get_child(0).get_node('AnimationPlayer').play('new_animation')
	await  $AnimatedSprite2D.animation_finished
	SceneTran.transition()	
	await SceneTran.on_transition_finished
	get_tree().change_scene_to_file("res://Base_Level.tscn")
	
# Replace with function body.
