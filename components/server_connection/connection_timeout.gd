class_name ConnectionTimeout
extends Node

## Watches pings and disconnects from server if pings stop

signal lost_heartbeat_connection

@onready var ping_mgr: PingMgr = $"../PingMgr"
@onready var heartbeat_timer: Timer = Timer.new()

func _ready():
	add_child(heartbeat_timer)
	
	# If we miss 2.5 pings, then we have lost connection
	heartbeat_timer.wait_time = ping_mgr.ping_interval_secs * 2.5
	heartbeat_timer.one_shot = true
	heartbeat_timer.timeout.connect(on_heartbeat_timeout)
	
	ping_mgr.ping_calculated.connect(on_ping_received)
	pass


## Handle when a ping-response is received from the server
func on_ping_received(ping: float):
	# Start or reset heartbeat timer
	heartbeat_timer.start()


## Handle when we haven't gotten a response from the server
func on_heartbeat_timeout():
	print("Lost connection heartbeat!!")
	lost_heartbeat_connection.emit()
