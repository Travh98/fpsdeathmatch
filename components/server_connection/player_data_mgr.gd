class_name PlayerDataMgr
extends Node

## Holds all the data that makes up the game state.
## Player health, score, etc.


## Signal to let the system know any item in the player data was updated
signal player_data_changed()

signal player_name_updated(peer_id: int, new_name: String)
signal player_health_updated(peer_id: int, new_hp: int)

## Dictionary of the current state of each Player
var players_data: Dictionary = {}


## Creates a new dictionary entry for this player's data
func on_player_spawned(peer_id: int):
	# Store this new player data in the dictionary
	players_data[peer_id] = {"name": "", "hp": 100, "score": 0}


func on_player_despawned(_peer_id: int):
	# TODO, should data immediately remove or keep it for scoreboards?
	pass


## Called when this client receives new player data from the server.
func on_server_data_updated(peer_id: int, data_key: String, data_value: String):
	if multiplayer.is_server():
		# The server already has the latest data, so don't update
		return
	
	if not is_data_valid(peer_id, data_key):
		return
	
	store_data(peer_id, data_key, data_value)
	pass


## Server calls this to handle a Client's player data update request
func on_data_update_request(peer_id: int, data_key: String, data_value: String):
	if not multiplayer.is_server():
		# Only run this on the server
		return
	
	store_data(peer_id, data_key, data_value)
	
	# Tell clients to update their data
	ServerPlayerDataRpcs.player_data_updated.rpc(peer_id, data_key, data_value)
	pass


## Called when players_data dictionary is updated.
## Emits signals to share the new data with the rest of this client's system.
func on_players_data_updated(peer_id: int, data_key: String):
	# Emit the relevant signal for the newly updated data
	match data_key:
		"name":
			player_name_updated.emit(peer_id, str(players_data[peer_id][data_key]))
		"hp":
			player_health_updated.emit(peer_id, int(players_data[peer_id][data_key]))
		"score":
			pass
		_:
			print("Unsupported PlayerDataMgr data updated: ", data_key)
	
	player_data_changed.emit()
	pass


## Server sends every entry in the players data to the target peer
func send_all_player_data_to_peer(peer_id: int):
	if not multiplayer.is_server():
		return
	
	print("Sending all player data to peer: ", peer_id)
	var num_sends: int = 0
	for peer_id_key in players_data:
		for data_key in players_data[peer_id_key]:
			# Send each player's key-values to the target peer_id
			ServerPlayerDataRpcs.player_data_updated.rpc_id(peer_id, peer_id_key, data_key, str(players_data[peer_id_key][data_key]))
			num_sends += 1
	
	print("Server sent " + str(num_sends) + " data entries to client: ", str(peer_id))
	pass


## Called by the server after a client requests to damage a player
func apply_damage_to_player(peer_id: int, damage: int):
	if not multiplayer.is_server():
		return
	
	# Update hp for this player in our server data
	var current_hp: int = int(players_data[peer_id]["hp"])
	if current_hp < 0:
		return
	var new_hp: int = current_hp - damage
	
	on_data_update_request(peer_id, "hp", str(new_hp))
	
	# Server has updated their Player Data, 
	# tell all the clients about the new data
	ServerPlayerDataRpcs.player_data_updated.rpc(peer_id, "hp", str(players_data[peer_id]["hp"]))


## Debug print all of the players data
func print_full_dict():
	print(players_data)


## Checks if input data is valid for updating the data
func is_data_valid(peer_id: int, data_key: String) -> bool:
	# Make sure players_data has been initialized for this peer_id and data_key
	if not players_data.has(peer_id):
		push_warning("Missing peer id for updating player data")
		return false
	if not players_data[peer_id].has(data_key):
		push_warning("Missing data key for updating player data")
		return false
	
	return true


## Stores the incoming player data locally and updates this system
func store_data(peer_id: int, data_key: String, data_value: String):
	# Update our local dictionary of all of the player's state
	players_data[peer_id][data_key] = data_value
	
	# Update the rest of this system
	on_players_data_updated(peer_id, data_key)
