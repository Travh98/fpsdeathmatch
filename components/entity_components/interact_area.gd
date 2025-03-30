class_name InteractArea
extends Area3D

signal interact()

@export var interact_text: String = "interactable"


func do_interact():
	interact.emit()
