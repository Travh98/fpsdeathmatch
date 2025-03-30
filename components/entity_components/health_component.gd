class_name HealthComponent
extends Node

signal health_changed(health_value: int)
signal health_died
signal damage_taken

@export var health: int = 100
@export var max_health: int = 100
var invincible: bool = false
var is_dead: bool = false


func _ready():
	pass


func take_damage(damage: int):
	if invincible:
		return
	if is_dead:
		return
	update_health(get_health() - damage)


func get_health() -> int:
	return health


func full_heal():
	update_health(max_health)


func update_health(new_health: int):
	var previous_health: int = health
	
	# Limit to max health
	if new_health > max_health:
		health = max_health
	else:
		health = new_health
	health_changed.emit(health)
	
	if health < previous_health:
		damage_taken.emit()
	
	# Check if alive
	if health > 0 and is_dead:
		is_dead = false
		#print(get_parent().name, " is no longer dead")
	
	# Check if dead
	if health <= 0:
		is_dead = true
		#print(get_parent().name, " has died")
		health_died.emit()
	
#	print(get_parent().name, " has health: ", get_health(), "/", max_health)
