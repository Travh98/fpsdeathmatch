class_name DamageVignette
extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer


func flash_vignette():
	anim_player.play("vignette_flash")
