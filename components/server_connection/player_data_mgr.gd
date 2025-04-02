class_name PlayerDataMgr
extends Node

## Holds all the data that makes up the game state.
## Player health, score, etc.

## Emit to update clients
signal player_health_updated(peer_id: int, new_hp: int)

## Dictionary of the current state of each Player
var players_data: Dictionary = {}


func on_player_spawned(peer_id: int):
	# Store this new player data in the dictionary
	players_data[peer_id] = {"name": "", "hp": 100, "score": 0}
	ConsoleLogGlobals.console_log("Created data dict for peer: " + str(peer_id))


## Called by the server after a client requests to damage a player
func apply_damage_to_player(peer_id: int, damage: int):
	if not multiplayer.is_server():
		ConsoleLogGlobals.console_log("I am not the server so I will not run this PlayerDataMgr.apply_damage_to_player function")
		return
	
	# Update hp for this player in our server data
	players_data[peer_id]["hp"] = players_data[peer_id]["hp"] - damage
	
	# As the server, update our local game with new data
	on_players_data_updated(peer_id, "hp")
	
	# Server has updated their Player Data, tell the clients the new data
	ServerPlayerDataRpcs.player_data_updated.rpc(peer_id, "hp", str(players_data[peer_id]["hp"]))
	
	#print_full_dict()


## Called when this client receives new player data from the server.
func update_player_data(peer_id: int, data_key: String, data_value: String):
	if multiplayer.is_server():
		# The server already has the latest data, so don't update
		return
	
	if not players_data.has(peer_id):
		ConsoleLogGlobals.console_log("Missing peer_id")
		print_full_dict()
		return
	if not players_data[peer_id].has(data_key):
		ConsoleLogGlobals.console_log("Missing data_key")
		return
	
	# Update our local dictionary of all of the player's state
	players_data[peer_id][data_key] = data_value
	
	on_players_data_updated(peer_id, data_key)


## Called when players_data dictionary is updated.
## Emits signals to share the new data with the rest of this client's system.
func on_players_data_updated(peer_id: int, data_key: String):
	match data_key:
		"hp":
			ConsoleLogGlobals.console_log("I see health was updated")
			player_health_updated.emit(peer_id, int(players_data[peer_id][data_key]))
		"score":
			pass
		_:
			print("Unsupported PlayerDataMgr data updated: ", data_key)
	pass


func print_full_dict():
	#if multiplayer.is_server():
		#print(players_data)
	print(players_data)
