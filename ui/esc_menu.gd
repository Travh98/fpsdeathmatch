class_name EscMenu
extends Control

## Escape/Pause Menu

signal disconnect_from_server()

@onready var volume_slider: HSlider = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/GridContainer/VolumeSlider
@onready var disconnect_button: Button = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/DisconnectButton
@onready var show_debug_colliders: CheckBox = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/GridContainer/ShowDebugColliders
@onready var show_console_log: CheckBox = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/GridContainer/ShowConsoleLog
@onready var show_player_data: CheckBox = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/GridContainer/ShowPlayerData


func _ready():
	visible = false
	volume_slider.value_changed.connect(on_volume_changed)
	on_volume_changed(volume_slider.value)
	
	show_debug_colliders.toggled.connect(on_debug_colliders_toggled)
	
	show_console_log.toggled.connect(on_show_console_log_toggled)
	on_show_console_log_toggled(show_console_log.button_pressed)
	
	show_player_data.toggled.connect(on_show_player_data_toggled)
	on_show_player_data_toggled(show_player_data.button_pressed)
	
	disconnect_button.pressed.connect(func(): disconnect_from_server.emit())


func _input(_event):
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


func on_show_console_log_toggled(toggled_on: bool):
	ClientGlobals.do_show_console_log = toggled_on


func on_show_player_data_toggled(toggled_on: bool):
	ClientGlobals.do_show_player_data = toggled_on
