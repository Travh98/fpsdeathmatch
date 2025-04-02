extends Node

## RPCs for applying damage to players and NPCs

signal server_damage_to_player(peer_id: int, damage: int)

# Any client can call this, this will run on the host
@rpc("any_peer", "call_local", "reliable")
func apply_damage_to_player(peer_id: int, damage: int):
	# Input peer_id tells the server who to apply damage to
	if not multiplayer.is_server():
		ConsoleLogGlobals.console_log("I am not the server so I will not run this apply_damage_to_player function")
		return
	
	print("Server sees request to hurt peer id: ", peer_id, " for damage: ", damage)
	server_damage_to_player.emit(peer_id, damage)
	pass
