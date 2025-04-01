class_name Revolver
extends Node3D

@onready var ammo: Ammo = $Ammo
@onready var ranged_damage: RangedDamage = $RangedDamage


func use_primary(eye_cast: RayCast3D, hitbox_cast: RayCast3D):
	if not ammo.is_ammo_loaded():
		print("out of ammo")
		ammo.reload_magazine()
		return
	
	ammo.use_ammo()
	var hit_target = hitbox_cast.get_collider()
	if hit_target is HitBox:
		hit_target.take_hit(ranged_damage.damage)
		#print("dealing dmg to ", hit_target)
	
