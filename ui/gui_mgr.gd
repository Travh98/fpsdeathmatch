class_name GuiMgr
extends Node

## Manages UI menus, when to show/hide them

signal gui_host_game(port: int)
signal gui_join_game(ip: String, port: int)
signal gui_disconnect_from_server()

@onready var start_connect_menu: StartConnectMenu = $StartConnectMenu
@onready var esc_menu: EscMenu = $EscMenu
@onready var console_log: ConsoleLog = $ConsoleLog


func _ready():
	start_connect_menu.start_host_server.connect(on_start_menu_host_game)
	start_connect_menu.start_join_server.connect(on_start_menu_join_game)
	esc_menu.disconnect_from_server.connect(func(): gui_disconnect_from_server.emit())
	
	start_connect_menu.visible = true
	esc_menu.visible = false


func on_start_menu_host_game(port: int):
	gui_host_game.emit(port)
	hide_start_menu()


func on_start_menu_join_game(ip: String, port: int):
	gui_join_game.emit(ip, port)
	hide_start_menu()


func hide_start_menu():
	start_connect_menu.visible = false


func on_server_disconnected():
	start_connect_menu.visible = true
	print("GUI sees disconnected from server")
