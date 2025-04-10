extends RigidBody3D

@onready var despawn_timer: Timer = $DespawnTimer


func _ready():
	despawn_timer.timeout.connect(queue_free)
	despawn_timer.start()
