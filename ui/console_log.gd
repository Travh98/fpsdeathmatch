class_name ConsoleLog
extends Control

@onready var rich_text_label: RichTextLabel = $MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer/RichTextLabel

func _ready():
	ConsoleLogGlobals.log_to_console.connect(console_line)
	pass


func console_line(new_text: String):
	rich_text_label.add_text(new_text + '\n')
	rich_text_label.scroll_to_line(rich_text_label.get_line_count() - 1)
