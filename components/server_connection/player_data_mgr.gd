class_name PlayerDataMgr
extends Node

## Holds all the data that makes up the game state.
## Player health, score, etc.


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


## Called by the server after a client requests to damage a player
func apply_damage_to_player(peer_id: int, damage: int):
	if not multiplayer.is_server():
		return
	
	# Update hp for this player in our server data
	players_data[peer_id]["hp"] = players_data[peer_id]["hp"] - damage
	
	# As the server, update our local game with new data
	on_players_data_updated(peer_id, "hp")
	
	# Server has updated their Player Data, 
	# tell all the clients about the new data
	ServerPlayerDataRpcs.player_data_updated.rpc(peer_id, "hp", str(players_data[peer_id]["hp"]))


## Called when this client receives new player data from the server.
func update_player_data(peer_id: int, data_key: String, data_value: String):
	if multiplayer.is_server():
		# The server already has the latest data, so don't update
		return
	
	# Make sure players_data has been initialized for this peer_id and data_key
	if not players_data.has(peer_id):
		push_warning("Missing peer id for updating player data")
		return
	if not players_data[peer_id].has(data_key):
		push_warning("Missing data key for updating player data")
		return
	
	# Update our local dictionary of all of the player's state
	players_data[peer_id][data_key] = data_value
	
	on_players_data_updated(peer_id, data_key)


## Server calls this to handle a Client's player data update request
func handle_update_player_data_request(peer_id: int, data_key: String, data_value: String):
	if not multiplayer.is_server():
		# Only run this on the server
		return
	
	# Make sure players_data has been initialized for this peer_id and data_key
	if not players_data.has(peer_id):
		push_warning("Missing peer id for updating player data")
		return
	if not players_data[peer_id].has(data_key):
		push_warning("Missing data key for updating player data")
		return
	
	# Update our local dictionary of all of the player's state
	players_data[peer_id][data_key] = data_value
	
	on_players_data_updated(peer_id, data_key)


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


## Debug print all of the players data
func print_full_dict():
	print(players_data)
