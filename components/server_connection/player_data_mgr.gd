class_name PlayerDataMgr
extends Node

## Holds all the data that makes up the game state.
## Player health, score, etc.

## Emit to update clients
signal player_data_updated(peer_id: int, new_hp: int, new_score: int)
signal player_health_updated(peer_id: int, new_hp: int)

var players_data: Dictionary = {}


func on_player_spawned(peer_id: int):
	# Store this new player data in the dictionary
	players_data[peer_id] = {"name": "", "hp": 100, "score": 0}
	player_data_updated.emit(peer_id, players_data[peer_id]["hp"], players_data[peer_id]["score"])
	ServerPlayerDataRpcs.player_data_updated.rpc(peer_id, players_data[peer_id])


## Called by the server after a client requests to damage a player
func apply_damage_to_player(peer_id: int, damage: int):
	if not multiplayer.is_server():
		return
	
	players_data[peer_id]["hp"] = players_data[peer_id]["hp"] - damage
	player_health_updated.emit(peer_id, players_data[peer_id]["hp"])
	ServerPlayerDataRpcs.player_data_updated.rpc(peer_id, players_data[peer_id])
	print_full_dict()


func print_full_dict():
	#if multiplayer.is_server():
		#print(players_data)
	print(players_data)
