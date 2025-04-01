class_name EscMenu
extends Control

signal disconnect_from_server()

@onready var volume_slider: HSlider = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/GridContainer/VolumeSlider
@onready var disconnect_button: Button = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/DisconnectButton
@onready var show_debug_colliders: CheckBox = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/GridContainer/ShowDebugColliders


func _ready():
	visible = false
	volume_slider.value_changed.connect(on_volume_changed)
	on_volume_changed(volume_slider.value)
	
	show_debug_colliders.toggled.connect(on_debug_colliders_toggled)
	
	disconnect_button.pressed.connect(func(): disconnect_from_server.emit())


func _input(event):
	if Input.is_action_just_pressed("escape"):
		if not visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		visible = not visible
		ClientGlobals.controls_locked = visible


func on_volume_changed(new_val: float):
	AudioServer.set_bus_volume_db(0, clamp(linear_to_db(new_val), -128, 6))


func on_debug_colliders_toggled(toggled_on: bool):
	ClientGlobals.do_show_debug_colliders = toggled_on
