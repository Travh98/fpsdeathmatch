extends Node

## Autoloaded RPC functions for pinging

## Emitted when the server sends back a pong to the client's ping
signal recieve_pong


## Ping the server, telling it which client it should pong back to.
## Any client can call this, this will run on the host.
@rpc("any_peer", "call_local", "unreliable")
func ping_to_server(peer_id: int):
	# Input peer_id tells the server who to pong back to
	if multiplayer.is_server():
		ServerPingRpcs.pong_to_client.rpc_id(peer_id)
	pass


@rpc("call_remote")
func pong_to_client():
	# Called from server
	recieve_pong.emit()

#@rpc("any_peer")
#func report_ping_to_server(_peer_id: int, _ping: float):
	#pass
