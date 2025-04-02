extends Node

## RPCs for updating Player Data across clients

## Emits when this client has received a new Player Data update
signal update_player_data(peer_id: int, data_key: String, data_value: String)
## Emits when a client requests to update player data
signal received_player_data_update_request(peer_id: int, data_key: String, data_value: String)
## Emitted when client joins late and needs all of the current data
signal send_all_data_to_peer(peer_id: int)

## Max length of string that can be sent over RPC
const MAX_RPC_INPUT_LENGTH: int = 32


## Server calls this function on each client.
## Tells clients to update their PlayerDataMgr state with this new value.
@rpc("call_remote")
func player_data_updated(peer_id: int, data_key: String, data_value: String):
	if not safety_check(data_key) or not safety_check(data_value):
		push_warning("Received unsafe RPC input! Ignoring.")
		return
	
	update_player_data.emit(peer_id, data_key, data_value)


## Clients call this function on the server to request to set their player data
@rpc("any_peer", "call_local", "reliable")
func request_update_player_data(peer_id: int, data_key: String, data_value: String):
	if not safety_check(data_key) or not safety_check(data_value):
		push_warning("Received unsafe RPC input! Ignoring.")
		return
	
	# Only allow clients to update their own data in the server
	if multiplayer.get_remote_sender_id() != peer_id:
		print("Client ", str(multiplayer.get_remote_sender_id()), 
			" tried setting data for a diff client: ", 
			str(peer_id), ". Not allowed!")
		return
	
	received_player_data_update_request.emit(peer_id, data_key, data_value)


## Clients call this function on the server to request getting all of the latest data
@rpc("any_peer", "call_local", "reliable")
func request_all_player_data():
	send_all_data_to_peer.emit(multiplayer.get_remote_sender_id())


## Basic safety checks, to make sure clients or hosts aren't sending
## anything too suspicious. This feels safer than nothing.
func safety_check(rpc_input: String) -> bool:
	if rpc_input.is_empty():
		return false
	if rpc_input.length() > MAX_RPC_INPUT_LENGTH:
		return false
	return true
