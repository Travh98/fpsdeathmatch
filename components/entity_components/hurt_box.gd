extends Area3D
class_name HurtBox

## An Area3D that hurts things

## Signal to notify when this hurtbox applied damage
signal did_hurt()

## If true, actively hurt things that enter
@export var is_active: bool = false : set = set_is_active
## Amount of damage to apply when hurting things
@export var damage: int = 0
## Optionally specify a body that will not be hurt by this
@export var ignore_body: Node3D

## A timer for applying a cooldown between hurts 
var cooldown_timer: Timer


func _ready():
	# Able to hurt hitboxes
	set_collision_mask_value(4, true)
	
	# Find or create a new cooldown timer
	if has_node("CooldownTimer"):
		var found_timer: Timer = get_node("CooldownTimer")
		if found_timer:
			cooldown_timer = found_timer
	if cooldown_timer == null:
		cooldown_timer = Timer.new()
		cooldown_timer.wait_time = 0.1
	cooldown_timer.one_shot = true
	
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node3D):
	if not is_active: 
		return
	
	# Wait until cooled down to deal damage
	if cooldown_timer.time_left > 0:
		print("Hurtbox cooling down, ignoring hit")
		return
	
	# Optionally ignore hitting a body
	if body == ignore_body:
		return
	
	# Hurt the mob's collider if it has a HealthComponent
	if body.has_node("HealthComponent"):
		var health_component: HealthComponent = body.get_node("HealthComponent")
		health_component.take_damage(damage)
		cooldown_timer.start()
		did_hurt.emit()
		return
	
	# If a hitbox enters, hurt the hitbox
	if body is HitBox:
		body.take_hit(damage)
		cooldown_timer.start()
		did_hurt.emit()
		return


func set_is_active(do_be_active: bool):
	is_active = do_be_active
	if is_active:
		# Hurt everything that is already inside this hurtbox,
		# since it was just activated
		for body in get_overlapping_bodies():
			on_body_entered(body)
	else:
		cooldown_timer.stop()
