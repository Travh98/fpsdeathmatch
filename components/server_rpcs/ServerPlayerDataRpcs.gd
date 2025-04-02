extends Node

## RPCs for updating Player Data across clients

#signal set_player_health(peer_id: int, new_hp: int)
signal update_player_data(peer_id: int, data_key: String, data_value: String)


## Server calls this function on each client.
## Tells clients to update their PlayerDataMgr state with this new value.
@rpc("call_remote")
func player_data_updated(peer_id: int, data_key: String, data_value: String):
	ConsoleLogGlobals.console_log("I (peer " + str(multiplayer.get_unique_id()) + " have received from server, new " + str(peer_id) + " data " + str(data_key))
	update_player_data.emit(peer_id, data_key, data_value)
	
