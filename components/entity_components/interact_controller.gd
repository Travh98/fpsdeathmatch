class_name InteractController
extends Node

## Handles when the user tries interacting with different things

signal interact_text(text: String)
#signal interact_with_item(item: HandItem)
signal interact_with_interactable(interactable: InteractArea)
signal empty_interact()

@onready var interact_cast: RayCast3D = $"../../Head/FpsCamera/InteractCast"


func _ready():
	interact_cast.collide_with_areas = true
	interact_with_interactable.connect(interact_on_interactable)


func interact_on_interactable(interactable: InteractArea):
	interactable.do_interact()


func _physics_process(delta):
	# Update the crosshair for stats on what you're looking at
	if interact_cast.is_colliding():
		var collider: Node3D = interact_cast.get_collider()
		if collider is InteractArea:
			interact_text.emit(collider.interact_text)
		else:
			interact_text.emit("")
	else:
		interact_text.emit("")
	
	if Input.is_action_just_pressed("interact"):
		var collider: Node3D = interact_cast.get_collider()
		# Interact with items
		#if collider is HandItem:
			#interact_with_item.emit(collider)
			#return
		# Touch buttons, etc
		if collider is InteractArea:
			interact_with_interactable.emit(collider)
			return
		
		# Interacting but not hitting anything,
		# for dropping items or whatever
		empty_interact.emit()
