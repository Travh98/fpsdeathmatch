class_name PingMgr
extends Node

## Manages ping calculations

signal ping_calculated(ping: float)

@onready var ping_timer: Timer = Timer.new()

## Track when the ping is started to see how long it takes to reach
var ping_start_time_msec: float 
## Report ping to the server after getting this many pings 
var report_ping_interval: int = 6
## Track the number of pings received since we have reported to server
var num_pings_since_reporting: int = 0
## How often to ping the server
var ping_interval_secs: float = 2.5


func _ready():
	ServerPingRpcs.recieve_pong.connect(receive_pong)
	
	add_child(ping_timer)
	
	# Pinging shouldn't take up a lot of bandwidth
	ping_timer.wait_time = ping_interval_secs
	ping_timer.one_shot = false
	ping_timer.timeout.connect(start_ping)


func begin_pinging():
	ping_timer.start()


func stop_pinging():
	ping_timer.stop()


func start_ping():
	ping_start_time_msec = Time.get_ticks_msec()
	# Ping the server, telling it who to respond to
	ServerPingRpcs.ping_to_server.rpc_id(1, multiplayer.multiplayer_peer.get_unique_id())


func report_ping(ping: float):
	# Report every couple pings to the server
	# so that the server knows how good your connection is
	if num_pings_since_reporting > report_ping_interval:
		#Server.report_ping_to_server.rpc_id(1, multiplayer.multiplayer_peer.get_unique_id(), ping)
		num_pings_since_reporting = 0
	num_pings_since_reporting += 1


func receive_pong():
	var ping: float = Time.get_ticks_msec() - ping_start_time_msec
	ping_calculated.emit(ping)
	report_ping(ping)


func on_server_connection_changed(connected: bool):
	if connected:
		begin_pinging()
	else:
		stop_pinging()
