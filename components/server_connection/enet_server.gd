class_name EnetServer
extends Node

## Manages creating the server (if you are hosting)

signal create_player_for_host()

var port: int = 25026
var max_players: int = 64


func start_server():
	# Create the server
	var network: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	network.create_server(port, max_players)
	
	# Store the peer in the Multiplayer Singleton
	multiplayer.multiplayer_peer = network
	
	print("Server started on port: ", str(port))
	
	create_player_for_host.emit()
