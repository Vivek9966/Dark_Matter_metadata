extends Node

var max_health :int = 15
var current_health: int
signal  _on_health_change
func _ready():
	current_health = max_health
func  dec_health(amt:int):
	current_health-=amt
	if current_health<0:
		current_health=0
	_on_health_change.emit(current_health)	
func inc_health(amt:int):
	current_health+=amt
	if current_health>max_health:
		current_health =max_health
	_on_health_change.emit(current_health)	
		   
