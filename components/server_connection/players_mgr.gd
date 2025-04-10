class_name PlayersMgr
extends Node

## Spawns the players that connect
##
## Spawned players will be a child of this node

## Emits when a character is spawned for a connected peer
signal spawned_character(peer_id: int)
## Emits when a character is despawned for a newly disconnected peer
signal despawned_character(peer_id: int)

## The Multiplayer Spawner that spawns our local client
@onready var multiplayer_spawner: MultiplayerSpawner = $"../MultiplayerSpawner"

## Scene to instantiate for each player
const PLAYER = preload("res://components/server_connection/multiplayer_client.tscn")

## Dictionary of player nodes, keyed by peer_id
var player_nodes: Dictionary = {}


func _ready():
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
	
	multiplayer_spawner.spawned.connect(register_local_player)


## Creates a player character when a peer is connected
func on_peer_connected(peer_id: int):
	add_player_character(peer_id)


## Removes a player character when the peer is disconnected
func on_peer_disconnected(peer_id: int):
	remove_player_character(peer_id)


## Spawns a player specifically for the client that is hosting the game
func spawn_player_for_host():
	# Add a character for the Host to own and control
	#print("Adding player character for the host: ", multiplayer.get_unique_id())
	add_player_character(multiplayer.get_unique_id())
	
	#print("Host is requesting for their name to be ", ClientGlobals.client_name)
	ServerPlayerDataRpcs.request_update_player_data.rpc_id(1, 
		multiplayer.get_unique_id(), 
		PlayerDataMgr.PlayerDataKeys.PD_NAME, 
		ClientGlobals.client_name)


## Registers this local player into our player_nodes.
## This is needed since the client's local player is automatically spawned
## by MultiplayerSpawner, therefore it does not go through our
## add_player_character function.
func register_local_player(local_player: Node):
	player_nodes[multiplayer.get_unique_id()] = local_player
	
	#print(local_player, " is requesting for their name to be ", ClientGlobals.client_name)
	ServerPlayerDataRpcs.request_update_player_data.rpc_id(1, 
		multiplayer.get_unique_id(), 
		PlayerDataMgr.PlayerDataKeys.PD_NAME, 
		ClientGlobals.client_name)
	
	# Since we are joining the server, and there could be players
	# already in the server, we need to request getting all the data
	# the server currently has
	ServerPlayerDataRpcs.request_all_player_data.rpc_id(1)


## Instantiates a new character for this peer
func add_player_character(peer_id):
	# Spawn a new character for this player to control
	var player_character = PLAYER.instantiate()
	
	# Set the player character's name to the peer_id of the Player who owns it
	player_character.name = str(peer_id)
	
	# Store player character node by their peer id
	player_nodes[peer_id] = player_character
	
	# If this new character is this client's character
	if peer_id == multiplayer.get_unique_id():
		pass
	
	# Players will be a child of this PlayersMgr node
	add_child(player_character)
	
	spawned_character.emit(peer_id)


## Removes the player character for this peer
func remove_player_character(peer_id):
	# Remove player character from stored dictionary of character nodes
	player_nodes.erase(peer_id)
	
	# Find and despawn the character that peer is controlling
	var player_character = get_node_or_null(str(peer_id))
	if player_character:
		player_character.queue_free()
		despawned_character.emit(peer_id)


## Updates the player's name
func update_player_name(peer_id: int, new_name: String):
	if not player_nodes.has(peer_id):
		return
	
	# Find the nametag node under the MultiplayerClient node we are updating
	var player_peer_name: String = str(peer_id)
	if not player_nodes[peer_id].has_node(player_peer_name):
		return
	if not player_nodes[peer_id].get_node(player_peer_name).has_node("PlayerNameLabel"):
		return
	
	# Update the health on the HealthComponent node of the updated player
	var nametag: Label3D = player_nodes[peer_id].get_node(player_peer_name).get_node("PlayerNameLabel")
	nametag.text = new_name


## Updates the health in the peer's characters's health component
func update_player_health(peer_id: int, new_hp: int):
	if not player_nodes.has(peer_id):
		return
	
	# Find the health component under the MultiplayerClient node we are updating
	# player_peer_name is the name of the player node that is a child of MultiplayerClient
	var player_peer_name: String = str(peer_id)
	if not player_nodes[peer_id].has_node(player_peer_name):
		return
	if not player_nodes[peer_id].get_node(player_peer_name).has_node("HealthComponent"):
		return
	
	# Update the health on the HealthComponent node of the updated player
	var health_component: HealthComponent = player_nodes[peer_id].get_node(player_peer_name).get_node("HealthComponent")
	health_component.update_health(new_hp)


func update_player_equipped_slot(peer_id: int, new_slot: int):
	if not player_nodes.has(peer_id):
		return
	
	# Find the health component under the MultiplayerClient node we are updating
	# player_peer_name is the name of the player node that is a child of MultiplayerClient
	var player_peer_name: String = str(peer_id)
	if not player_nodes[peer_id].has_node(player_peer_name):
		return
	if not player_nodes[peer_id].get_node(player_peer_name).has_node("PlayerController/UseEquippedItem"):
		return
	
	var use_equipped_item: UseEquippedItem = player_nodes[peer_id]\
		.get_node(player_peer_name).get_node("PlayerController/UseEquippedItem")
	use_equipped_item.switch_to_item_slot(new_slot)


## Triggers shooting anim on this player
func on_player_shot(peer_id: int):
	if not player_nodes.has(peer_id):
		return
	
	# Find the health component under the MultiplayerClient node we are updating
	# player_peer_name is the name of the player node that is a child of MultiplayerClient
	var player_peer_name: String = str(peer_id)
	if not player_nodes[peer_id].has_node(player_peer_name):
		return
	if not player_nodes[peer_id].get_node(player_peer_name).has_node("Head/HandSpot/Revolver"):
		return
	
	var revolver: Revolver = player_nodes[peer_id].get_node(player_peer_name).get_node("Head/HandSpot/Revolver")
	revolver.shooting_fx()


## Triggers reload anim on this player
func on_player_reload(peer_id: int):
	if not player_nodes.has(peer_id):
		return
	
	# Find the health component under the MultiplayerClient node we are updating
	# player_peer_name is the name of the player node that is a child of MultiplayerClient
	var player_peer_name: String = str(peer_id)
	if not player_nodes[peer_id].has_node(player_peer_name):
		return
	if not player_nodes[peer_id].get_node(player_peer_name).has_node("Head/HandSpot/Revolver"):
		return
	
	var revolver: Revolver = player_nodes[peer_id].get_node(player_peer_name).get_node("Head/HandSpot/Revolver")
	revolver.reloading_fx()
