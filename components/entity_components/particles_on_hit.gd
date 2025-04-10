class_name ParticlesOnHit
extends Node

@export var particles: GPUParticles3D

func _ready():
	pass


func fire_particles():
	particles.restart()
	particles.emitting = true
