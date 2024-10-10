extends ProgressBar

@onready var timer = $Timer
@onready var dmg_bar = $Damage
# Called when the node enters the scene tree for the first time.
var health = 0 : set  =_set_health
func _set_health(new_health):
	var previous = health
	health = min(max_value,new_health)
	value = health
	if health <=0:
		queue_free()
	if  health <previous:
		timer.start()
	else:
		dmg_bar.value = health
func _init_health(_health):
	health = _health
	max_value = health
	value =health
	dmg_bar.max_value = health
	dmg_bar.value = health
	
func _ready():
	Health._on_health_change.connect(on_player_health_change)
	_init_health(Health.max_health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_player_health_change(player_current_healt :int):
	_set_health(player_current_healt)
	
func _on_timer_timeout():
	dmg_bar.value =health # Replace with function body.
