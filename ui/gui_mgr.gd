class_name GuiMgr
extends Node

## Manages UI menus, when to show/hide them

## Emitted when the GUI wants to host a game
signal gui_host_game(port: int)
## Emitted when the GUI wants to join a game
signal gui_join_game(ip: String, port: int)
## Emitted when the GUI wants to disconnect from the server
signal gui_disconnect_from_server()

## Start menu with connection settings
@onready var start_connect_menu: StartConnectMenu = $StartConnectMenu
## Escape/pause menu
@onready var esc_menu: EscMenu = $EscMenu
## Console Log GUI
@onready var console_log: ConsoleLog = $ConsoleLog
## GUI for displaying PlayerData
@onready var player_data_view: PlayerDataView = $PlayerDataView


func _ready():
	start_connect_menu.start_host_server.connect(on_start_menu_host_game)
	start_connect_menu.start_join_server.connect(on_start_menu_join_game)
	esc_menu.disconnect_from_server.connect(func(): gui_disconnect_from_server.emit())
	
	ClientGlobals.show_console_log_toggled.connect(
		func(toggled_on: bool): console_log.visible = toggled_on)
	console_log.visible = ClientGlobals.do_show_console_log

	ClientGlobals.show_player_data_toggled.connect(
		func(toggled_on: bool): player_data_view.visible = toggled_on)
	player_data_view.visible = ClientGlobals.do_show_player_data
	
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
