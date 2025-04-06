class_name RandomSfx
extends Node3D

## Plays a random AudioStreamPlayer child with random pitch.
## Add new sounds as AudioStreamPlayer children of this node.

@export var low_pitch_range: float = 0.02
@export var high_pitch_range: float = 0.02

## Array of available sounds
var sounds: Array[AudioStreamPlayer3D]
## Shuffled array of sounds, used to make unique random sequences
var unique_sounds: Array[AudioStreamPlayer3D]


func _ready():
	# Register each audio stream player child
	for child in get_children():
		if child is AudioStreamPlayer3D:
			sounds.append(child)


## Plays a random sound.
func play_sound():
	if unique_sounds.is_empty():
		unique_sounds = sounds.duplicate()
		unique_sounds.shuffle()
	
	var stream_player: AudioStreamPlayer3D = unique_sounds.pop_front()
	stream_player.pitch_scale = 1.0 + randf_range(-low_pitch_range, high_pitch_range)
	stream_player.play()
