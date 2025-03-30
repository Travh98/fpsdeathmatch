class_name PlayersMgr
extends Node

## Spawns the players that connect
##
## Spawned players will be a child of this node

signal spawned_character(peer_id: int)
signal despawned_character(peer_id: int)

const PLAYER = preload("res://components/server_connection/multiplayer_client.tscn")

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
	
	print("Adding player character: ", peer_id)
	add_child(player_character)
	
	spawned_character.emit(peer_id)


func remove_player_character(peer_id):
	# Find and despawn the character that peer is controlling
	var player_character = get_node_or_null(str(peer_id))
	if player_character:
		#ConsoleLog.log_msg(str(player_character.get_node("PlayerController").player_name, " has left the game, was peer: ", str(peer_id)))
		player_character.queue_free()
		despawned_character.emit(peer_id)
