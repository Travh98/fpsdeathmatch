class_name PlayerHud
extends Control

## Displays HUD for Player, referencing Player's nodes

# Components on Mob
@onready var stamina: Stamina = $"../PlayerController/Stamina"
@onready var health_component: HealthComponent = $"../HealthComponent"

# UI elements
@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HealthBar
@onready var stamina_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/StaminaBar
@onready var speed_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer/MarginContainer/StatsContainer/SpeedLabel
@onready var interact_text: Label = $HBoxContainer2/VBoxContainer/InteractText

var last_inv_slot_label: Label


func _ready():
	pass


func _process(_delta):
	stamina_bar.value = stamina.stamina
	health_bar.value = health_component.health


func update_speed(new_speed: float):
	speed_label.text = str(new_speed).pad_decimals(2)


func set_interact_text(text: String):
	interact_text.text = text
