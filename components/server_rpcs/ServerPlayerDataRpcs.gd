extends Node

## RPCs for updating Player Data across clients

signal set_player_health(peer_id: int, new_hp: int)

@rpc("call_remote")
func player_data_updated(peer_id: int, player_data: Dictionary):
	# Called from server, runs functions on the client
	print("Client received new data from server: ", player_data)
	set_player_health.emit(peer_id, player_data["hp"])
	
