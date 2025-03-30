class_name MovingStaticBody
extends Node

@onready var moving_object: Node3D = $".."
@onready var sample_timer: Timer = $SampleTimer

var avg_velocity: Vector3

var position_samples: Array[Vector3]
var max_position_samples: int = 5

func _ready():
	sample_timer.timeout.connect(sample_position)
	sample_timer.start()


func sample_position():
	if position_samples.size() > max_position_samples - 1:
		position_samples.pop_back()
	
	position_samples.append(moving_object.global_position)
	
	# Take the average of the position samples
	var sum_of_velocities: Vector3 = Vector3.ZERO
	var latest_pos: Vector3 = position_samples[0]
	for i in range(0, position_samples.size()):
		sum_of_velocities += position_samples[i] - latest_pos
		latest_pos = position_samples[i]
	
	avg_velocity = sum_of_velocities / position_samples.size()
	#print("Average velocity of ", moving_object.name, " is ", avg_velocity.length(), " vector: ", avg_velocity, " with num samples: ", position_samples.size())
