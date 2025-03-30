class_name Stamina
extends Node

@onready var stamina_do_nothing_timer: Timer = Timer.new()
@onready var stamina_recharge_cooldown: Timer = Timer.new()

var stamina: float = 100
var max_stamina: int = 100
var regen_stamina_per_sec: int = 25

func _ready():
	add_child(stamina_do_nothing_timer)
	stamina_do_nothing_timer.wait_time = 1.0
	stamina_do_nothing_timer.one_shot = true

	add_child(stamina_recharge_cooldown)
	stamina_recharge_cooldown.wait_time = 0.25
	stamina_recharge_cooldown.one_shot = true
	
	stamina_do_nothing_timer.timeout.connect(on_done_doing_nothing)


func _process(delta):
	if not stamina_recharge_cooldown.is_stopped() or not stamina_do_nothing_timer.is_stopped():
		return
	
	if stamina < max_stamina:
		stamina += regen_stamina_per_sec * delta
		clamp(stamina, 0, max_stamina)


# Returns true if successfully burned stamina
func burn_stamina(burn_rate_per_sec: int, delta: float) -> bool:
	if stamina > 0:
		stamina -= burn_rate_per_sec * delta
		clamp(stamina, 0, max_stamina)
		
		# Restart the regen since we used stamina
		stamina_do_nothing_timer.start()
		return true
	else:
		print("Out of stamina")
		return false


func on_done_doing_nothing():
	stamina_recharge_cooldown.start()
