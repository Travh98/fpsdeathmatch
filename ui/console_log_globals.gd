extends Node

## Autoload for logging to console

signal log_to_console(text: String)

func console_log(text: String):
	log_to_console.emit(text)
