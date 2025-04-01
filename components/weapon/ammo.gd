class_name Ammo
extends Node

## Node for managing ammo

signal magazine_empty()
signal ammo_reserves_empty()
signal ammo_reloaded()

@export var ammo_in_magazine: int
@export var ammo_per_magazine: int
@export var ammo_in_reserve: int


func is_ammo_loaded() -> bool:
	return ammo_in_magazine > 0


func use_ammo():
	ammo_in_magazine -= 1
	if ammo_in_magazine <= 0:
		magazine_empty.emit()


func reload_magazine():
	if ammo_in_reserve <= 0:
		return
	
	if ammo_in_reserve >= ammo_per_magazine:
		ammo_in_magazine = ammo_per_magazine
		ammo_in_reserve -= ammo_per_magazine
	else:
		ammo_in_magazine = ammo_in_reserve
		ammo_in_reserve = 0
		ammo_reserves_empty.emit()
	ammo_reloaded.emit()
