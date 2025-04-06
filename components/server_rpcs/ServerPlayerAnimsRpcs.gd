extends Node

## RPC functions for player animations

## Emits when a player shoots
signal player_shot(peer_id: int)
## Emits when a player reloads
signal player_reload(reloading_peer_id: int)


## Call to tell server this player has shot
@rpc("any_peer", "call_local", "reliable")
func on_player_shot(peer_id: int):
	if not multiplayer.is_server():
		return
	
	# If the server host is the one shooting,
	# don't run the shooting fx twice
	if peer_id != multiplayer.get_unique_id():
		player_shot.emit(peer_id)
	
	# Replicate on clients
	replicate_player_shot.rpc(peer_id)


## Call from the server to tell clients a player has shot
@rpc("call_remote")
func replicate_player_shot(peer_id: int):
	if multiplayer.is_server():
		return

	# Do not replicate shots for this client if we are the ones shooting
	if peer_id == multiplayer.get_unique_id():
		return
	
	player_shot.emit(peer_id)


## Call to tell server this player starts reload
@rpc("any_peer", "call_local", "reliable")
func on_player_reload(reloading_peer_id: int):
	if not multiplayer.is_server():
		return
	
	if reloading_peer_id != multiplayer.get_unique_id():
		player_reload.emit(reloading_peer_id)
	
	# Replicate on clients
	replicate_player_reload.rpc(reloading_peer_id)


## Call from the server to tell clients a player starts reload
@rpc("call_remote")
func replicate_player_reload(reloading_peer_id: int):
	if multiplayer.is_server():
		return

	# Do not replicate shots for this client if we are the ones shooting
	if reloading_peer_id == multiplayer.get_unique_id():
		return
	
	player_reload.emit(reloading_peer_id)
