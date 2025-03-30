class_name ServerConnector
extends Node

## Manages connection to server (as a client)

signal server_connection_changed(connected: bool)
signal connection_failed_after_secs(secs: float)

var host_ip: String = "localhost"
var port: int = 25026
var last_join_attempt_secs: float
var is_server_connected: bool = false : set = set_server_connection_changed


func _ready():
	pass


func get_peer_id() -> int:
	if is_server_connected:
		return multiplayer.multiplayer_peer.get_unique_id()
	return -1


func set_server_connection_info(h: String, p: int):
	if !h.is_empty():
		host_ip = h
	if p > 1023 && p < 65535:
		port = p


func connect_to_server():
	var network: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	last_join_attempt_secs = Time.get_unix_time_from_system()
	network.create_client(host_ip, port)
	multiplayer.multiplayer_peer = network
	
	multiplayer.connection_failed.connect(on_connection_failed)
	multiplayer.connected_to_server.connect(on_connection_success)


func disconnect_from_server():
	#GameMgr.game_tree.player_mgr.delete_all_players()
	if not is_server_connected:
		return
	is_server_connected = false
	print("Disconnected from server")
	
	if multiplayer.multiplayer_peer:
		multiplayer.connection_failed.disconnect(on_connection_failed)
		multiplayer.connected_to_server.disconnect(on_connection_success)
		multiplayer.multiplayer_peer = null
	


func on_connection_failed():
	is_server_connected = false
	var time_spent_joining: float = Time.get_unix_time_from_system() - last_join_attempt_secs
	push_warning("Connection failed after ", str(time_spent_joining), " seconds.")
	connection_failed_after_secs.emit(time_spent_joining)
	#GameMgr.game_tree.gui_mgr.on_connection_failed()
	disconnect_from_server()


func on_connection_success():
	is_server_connected = true
	print("Successfully connected!")
	#GameMgr.game_tree.gui_mgr.on_connection_success()


func set_server_connection_changed(c: bool):
	if is_server_connected != c:
		is_server_connected = c
		server_connection_changed.emit(c)
