extends Control

## Displays frames per second

@onready var fps_label: Label = $FpsCount
@onready var update_fps_timer: Timer = $UpdateFpsTimer


func _ready():
	update_fps_timer.timeout.connect(update_fps)
	update_fps_timer.one_shot = false
	update_fps_timer.wait_time = 0.25
	update_fps_timer.start()
	pass


func update_fps():
	var fps: float = Engine.get_frames_per_second()
	if visible:
		fps_label.text = str(fps)
		if fps < 30:
			fps_label.modulate = Color.RED
		else:
			fps_label.modulate = Color.WHITE
