class_name PlayersMgr
extends Node

## Spawns the players that connect
##
## Spawned players will be a child of this node

signal spawned_character(peer_id: int)
signal despawned_character(peer_id: int)

## Scene to instantiate for each player
const PLAYER = preload("res://components/server_connection/multiplayer_client.tscn")

## Dictionary of player nodes, keyed by peer_id
var player_nodes: Dictionary = {}


func _ready():
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.peer_disconnected.connect(on_peer_disconnected)


func on_peer_connected(peer_id: int):
	print("Peer connected: ", peer_id)
	add_player_character(peer_id)


func on_peer_disconnected(peer_id: int):
	remove_player_character(peer_id)


func spawn_player_for_host():
	# Add a character for the Host to own and control
	print("Adding player character for the host: ", multiplayer.get_unique_id())
	add_player_character(multiplayer.get_unique_id())


func add_player_character(peer_id):
	# Spawn a new character for this player to control
	var player_character = PLAYER.instantiate()
	
	# Set the player character's name to the peer_id of the Player who owns it
	player_character.name = str(peer_id)
	
	# If this new character is this client's character
	if peer_id == multiplayer.get_unique_id():
		pass
	
	# Players will be a child of this PlayersMgr node
	add_child(player_character)
	
	# Store player character node by their peer id
	player_nodes[peer_id] = player_character
	
	spawned_character.emit(peer_id)


func remove_player_character(peer_id):
	# Remove player character from stored dictionary of character nodes
	player_nodes.erase(peer_id)
	
	# Find and despawn the character that peer is controlling
	var player_character = get_node_or_null(str(peer_id))
	if player_character:
		#ConsoleLog.log_msg(str(player_character.get_node("PlayerController").player_name, " has left the game, was peer: ", str(peer_id)))
		player_character.queue_free()
		despawned_character.emit(peer_id)


func update_player_health(peer_id: int, new_hp: int):
	print("Trying to update player health in playersMgr")
	if not player_nodes.has(peer_id):
		print("Player nodes does not have peer_id: ", peer_id)
		return
	
	# This is the name of the player node that is a child of MultiplayerClient
	var player_peer_name: String = str(peer_id)
	if not player_nodes[peer_id].has_node(player_peer_name):
		return
	if not player_nodes[peer_id].get_node(player_peer_name).has_node("HealthComponent"):
		return
	
	var health_component: HealthComponent = player_nodes[peer_id].get_node(player_peer_name).get_node("HealthComponent")
	health_component.health = new_hp
	print("Updated health of ", peer_id, " to be ", new_hp)
