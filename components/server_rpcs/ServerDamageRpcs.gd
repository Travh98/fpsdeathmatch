extends Node

## RPCs for applying damage to players and NPCs

## Emits when the server will apply damage to a player
signal server_damage_to_player(peer_id: int, damage: int)

## Clients call this RPC to request the server to do damage to the target peer_id.
## Any client can call this, this will run on the host.
@rpc("any_peer", "call_local", "reliable")
func apply_damage_to_player(peer_id: int, damage: int):
	if not multiplayer.is_server():
		return
	
	print("Server sees request to hurt peer id: ", peer_id, " for damage: ", damage)
	server_damage_to_player.emit(peer_id, damage)
	pass
