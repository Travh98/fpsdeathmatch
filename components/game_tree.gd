class_name GameTree
extends Node

## Connects items in the game tree

@onready var gui_mgr: GuiMgr = $GuiMgr
@onready var server_interface: ServerInterface = $ServerInterface
@onready var enet_server = $ServerInterface/EnetServer
@onready var server_connector: ServerConnector = $ServerInterface/ServerConnector
@onready var ping_mgr: PingMgr = $ServerInterface/PingMgr
@onready var players_mgr: PlayersMgr = $PlayersMgr
@onready var player_data_mgr: PlayerDataMgr = $PlayerDataMgr


func _ready():
	# Handle hosting, joining and disconnecting 
	gui_mgr.gui_host_game.connect(server_interface.host_game)
	gui_mgr.gui_join_game.connect(server_interface.join_game)
	gui_mgr.gui_disconnect_from_server.connect(server_connector.disconnect_from_server)
	server_interface.disconnected_from_server.connect(gui_mgr.on_server_disconnected)
	
	gui_mgr.player_data_view.playerDataMgr = player_data_mgr
	
	# Spawn a player for the host if hosting
	enet_server.create_player_for_host.connect(players_mgr.spawn_player_for_host)
	
	# When PlayersMgr spawns a character, create a data dictionary for that player
	players_mgr.spawned_character.connect(player_data_mgr.on_player_spawned)
	
	# Create a new data dictionary for this client as soon as we connect to the server
	server_interface.connected_to_server.connect(
		func(): player_data_mgr.on_player_spawned(multiplayer.get_unique_id()))
	
	# If we are the server, when we receive a damage player request,
	# update our player data dictionary
	ServerDamageRpcs.server_damage_to_player.connect(player_data_mgr.apply_damage_to_player)
	
	# When the server says the player's state has changed, update PlayerDataMgr
	ServerPlayerDataRpcs.update_player_data.connect(player_data_mgr.on_server_data_updated)
	
	# When the server receives a request to update player data, update the server's data
	ServerPlayerDataRpcs.received_player_data_update_request.connect(
		player_data_mgr.on_data_update_request)
	
	# Send all player data to a peer (usually for late joiners)
	ServerPlayerDataRpcs.send_all_data_to_peer.connect(
		player_data_mgr.send_all_player_data_to_peer)
	
	ServerPlayerAnimsRpcs.player_shot.connect(players_mgr.on_player_shot)
	ServerPlayerAnimsRpcs.player_reload.connect(players_mgr.on_player_reload)
	
	player_data_mgr.player_name_updated.connect(players_mgr.update_player_name)
	
	# Update health of players when server says their health changed
	player_data_mgr.player_health_updated.connect(players_mgr.update_player_health)
	
	# Share ping with this client's system
	ping_mgr.ping_calculated.connect(func(ping: float): ClientGlobals.ping_calculated.emit(ping))
