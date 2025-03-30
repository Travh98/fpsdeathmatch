class_name RelativeInput
extends Node

## Provides input relative to an object


func get_camera_relative_input(input_axis: Vector2, camera: Node3D) -> Vector3:
	var aim: Basis = camera.get_global_transform().basis
	return aim.z * -input_axis.x + aim.x * input_axis.y


func get_fps_relative_input(input_axis: Vector2, player: Node3D) -> Vector3:
	var aim: Basis = player.get_global_transform().basis
	return aim.z * -input_axis.x + aim.x * input_axis.y
