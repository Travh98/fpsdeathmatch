class_name KillfeedHud
extends Control


@onready var kill_labels: VBoxContainer = $MarginContainer/HBoxContainer/KillLabels
@onready var despawn_kill_label: Timer = $DespawnKillLabel

var kill_reports_array: Array


func _ready():
	ServerKillfeedRpcs.new_kill.connect(on_new_kill)
	despawn_kill_label.timeout.connect(on_despawn_label_time)
	pass


func on_new_kill(killer: String, killed: String):
	if kill_reports_array.size() >= 3:
		despawn_label()
	
	var new_kill_label: Label = Label.new()
	new_kill_label.text = killer + " 💀 " + killed
	kill_labels.add_child(new_kill_label)
	kill_reports_array.append(new_kill_label)
	despawn_kill_label.start()
	
	pass


func despawn_label():
	if kill_reports_array.is_empty():
		return
	
	var old_label: Control = kill_reports_array.pop_front()
	old_label.queue_free()


func on_despawn_label_time():
	if not kill_reports_array.is_empty():
		despawn_label()
		despawn_kill_label.start()
