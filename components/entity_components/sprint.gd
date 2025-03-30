class_name Sprint
extends Node

@onready var stamina: Stamina = $"../Stamina"

@export var is_sprint_allowed: bool = true
@export var sprint_factor: float = 1.5
@export var sprint_burn_stamina_rate: int = 33
@export var sprint_fov: int = 85
var sprint_toggled: bool = false
var do_toggle_sprint: bool = false

## Returns true if can sprint, and uses stamina
func sprint() -> bool:
	if do_toggle_sprint:
		if Input.is_action_just_pressed("sprint"):
			sprint_toggled = not sprint_toggled
		
		# Untoggle sprint if no stamina
		if stamina.stamina <= 0:
			sprint_toggled = false
		
		# Always sprint
		if sprint_toggled and stamina.stamina > 0:
			return true
		else:
			return false
	else:
		if Input.is_action_pressed("sprint"):
			if stamina.stamina > 0:
				return true
		
		return false
