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
	
	# Connect Player Data Manager
	# When PlayersMgr spawns a character, create a data dictionary for them
	players_mgr.spawned_character.connect(player_data_mgr.on_player_spawned)
	
	# Create a new data dictionary for this client as soon as we connect to the server
	server_interface.connected_to_server.connect(
		func(): player_data_mgr.on_player_spawned(multiplayer.get_unique_id()))
	
	## When a client connects to the server, their spawned player needs to be registered
	## into PlayersMgr
	#multiplayer.connected_to_server.connect(
		#func(): players_mgr.find_and_register_local_player())
	
	
	ServerDamageRpcs.server_damage_to_player.connect(player_data_mgr.apply_damage_to_player)
	
	# When the server says the player's state has changed, update PlayerDataMgr
	ServerPlayerDataRpcs.update_player_data.connect(player_data_mgr.update_player_data)
	# Update health of players when server says their health changed
	player_data_mgr.player_health_updated.connect(players_mgr.update_player_health)
	
	# Share ping with this client's system
	ping_mgr.ping_calculated.connect(func(ping: float): ClientGlobals.ping_calculated.emit(ping))
	
	# WIP on spawning entities
	#ServerSpawningRpcs.spawned_entity.connect(spawn_entity)
	#ServerSpawningRpcs.despawned_entity.connect(despawn_entity)


#func spawn_entity(node_path: String, resource_path: String, global_pos: Vector3, global_rot: Vector3):
	#var entity: Node3D = load(resource_path).instantiate()
	#get_tree().root.get_node(node_path.get_base_dir()).add_child(entity)
	#
	## Make sure this entity on the clients has the same name & path as the entity on the host
	#entity.name = node_path.get_file()
	#
	#if not entity.is_node_ready():
		#await entity.ready
	#
	#entity.global_position = global_pos
	#entity.global_rotation = global_rot
	#
	##print("Spawning node: ", node_path, " with resource: ", resource_path)
#
#
#func despawn_entity(node_path: String):
	#var despawn_node: Node = get_tree().root.get_node(node_path)
	#if despawn_node:
		##print("Despawning node: ", node_path)
		#despawn_node.queue_free()
	#else:
		#push_warning("Failed to despawn node: ", node_path)
