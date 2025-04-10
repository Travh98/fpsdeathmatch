extends Node

## RPCs for applying damage to players and NPCs

## Emits when the server will apply damage to a player
signal server_damage_to_player(peer_id: int, damage: int, damage_sender_peer_id: int)
signal player_was_killed(peer_id: int)

## Clients call this RPC to request the server to do damage to the target peer_id.
## Any client can call this, this will run on the host.
@rpc("any_peer", "call_local", "reliable")
func apply_damage_to_player(peer_id: int, damage: int, damage_sender_peer_id: int):
	if not multiplayer.is_server():
		return
	
	print("Server sees request to hurt peer id: ", peer_id, " for damage: ", damage)
	server_damage_to_player.emit(peer_id, damage, damage_sender_peer_id)
	pass


## Client's notify server when they have died
@rpc("any_peer", "call_local", "reliable")
func apply_player_was_killed(peer_id: int):
	if not multiplayer.is_server():
		return
	
	player_was_killed.emit(peer_id)
	pass
