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
	ServerPlayerDataRpcs.update_player_data.connect(player_data_mgr.update_player_data)
	
	# Update health of players when server says their health changed
	player_data_mgr.player_health_updated.connect(players_mgr.update_player_health)
	
	# Share ping with this client's system
	ping_mgr.ping_calculated.connect(func(ping: float): ClientGlobals.ping_calculated.emit(ping))
