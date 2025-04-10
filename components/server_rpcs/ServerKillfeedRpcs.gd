extends Node

## RPCs for sharing kill feed info

signal new_kill(killer: String, killed: String)

## Server calls this to announce to clients that a player was killed
@rpc("call_remote")
func announce_kill(killer: String, killed: String):
	new_kill.emit(killer, killed)
