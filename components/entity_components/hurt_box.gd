extends Area3D
class_name HurtBox

signal did_hurt()

@export var damage: int = 0
@onready var cooldown_timer: Timer = $CooldownTimer
@export var ignore_body: Node3D
var is_active: bool = false : set = set_is_active

func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node3D):
	if not is_active: 
		return
	
	if cooldown_timer.time_left > 0:
		print("Hurtbox cooling down, ignoring hit")
		return
	
	if body == ignore_body:
		return
	
	if body.has_node("HealthComponent"):
		var health_component: HealthComponent = body.get_node("HealthComponent")
		health_component.take_damage(damage)
		cooldown_timer.start()
		did_hurt.emit()


func set_is_active(do_be_active: bool):
	is_active = do_be_active
	if is_active:
		for body in get_overlapping_bodies():
			on_body_entered(body)
	else:
		cooldown_timer.stop()
