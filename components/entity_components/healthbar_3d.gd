extends Sprite3D

## A 3D floating healthbar

@onready var healthbar: ProgressBar = $SubViewport/Healthbar

func _ready():
	texture = $SubViewport.get_texture()
	
	var mob = get_parent()
	var health_component: HealthComponent = mob.get_node("HealthComponent")
	health_component.health_changed.connect(on_health_changed)
	healthbar.max_value = health_component.max_health
	healthbar.value = health_component.health


func on_health_changed(newhealth: int):
	healthbar.value = newhealth
