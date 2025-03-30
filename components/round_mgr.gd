extends Node

## Autoload for managing the course of a round

signal depart_train

@onready var time_until_train_leaves: Timer = $TimeUntilTrainLeaves

func _ready():
	time_until_train_leaves.timeout.connect(on_train_leave_time)
	pass


func start_train_arrived():
	time_until_train_leaves.start()
	pass


func on_train_leave_time():
	depart_train.emit()
	pass
