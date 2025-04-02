class_name Logger
extends Node

## Hooks up all the signals from components to the logging autoload.

@onready var start_connect_menu: StartConnectMenu = $"../GuiMgr/StartConnectMenu"
@onready var esc_menu = $"../GuiMgr/EscMenu"
@onready var players_mgr: PlayersMgr = $"../PlayersMgr"
@onready var player_data_mgr: PlayerDataMgr = $"../PlayerDataMgr"
@onready var connection_timeout: ConnectionTimeout = $"../ServerInterface/ConnectionTimeout"
@onready var server_connector: ServerConnector = $"../ServerInterface/ServerConnector"


func _ready():
	# Listen for signals from nodes in the game tree
	# When those signals emit, log details for debugging
	players_mgr.spawned_character.connect(on_character_spawned)
	players_mgr.despawned_character.connect(on_character_despawned)
	player_data_mgr.player_health_updated.connect(on_player_health_updated)
	start_connect_menu.start_host_server.connect(on_start_hosting)
	start_connect_menu.start_join_server.connect(on_start_joining)
	connection_timeout.lost_heartbeat_connection.connect(on_lost_heartbeat_connection)
	server_connector.connection_failed_after_secs.connect(on_connection_failed_after_secs)


func on_character_spawned(peer_id: int):
	ConsoleLogGlobals.console_log("Peer spawned: " + str(peer_id))


func on_character_despawned(peer_id: int):
	ConsoleLogGlobals.console_log("Peer despawned/disconnected: " + str(peer_id))


func on_player_health_updated(_peer_id: int, _new_hp: int):
	#ConsoleLogGlobals.console_log("Peer: " + str(peer_id) + " new health: " + str(new_hp))
	pass


func on_start_hosting(port: int):
	ConsoleLogGlobals.console_log("Hosting on port: " + str(port))


func on_start_joining(host: String, port: int):
	ConsoleLogGlobals.console_log("Joining to host: " + host + ":" + str(port))


func on_lost_heartbeat_connection():
	ConsoleLogGlobals.console_log("Did not receive ping after " 
		+ str(connection_timeout.heartbeat_timer.wait_time).pad_decimals(1) 
		+ " secs. Disconnecting")


func on_connection_failed_after_secs(secs: float):
	ConsoleLogGlobals.console_log("Failed to connect after " 
		+ str(secs).pad_decimals(1)
		+ " secs.")
