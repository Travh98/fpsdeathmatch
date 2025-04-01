class_name HitBoxManager
extends Node

## Manages finding all hitboxes for this mob

## All hitboxes will be a child of this node or this node's children.
## For example, for hitboxes under BoneAttachments, you'd want 
## hitbox_parent to be the Skeleton3D that has the attachments.
@export var hitbox_parent: Node3D

## The player or mob that owns this manager.
@onready var mob: Node3D = $"../.."
### 
#@onready var health_component: HealthComponent = $"../../HealthComponent"

## Store all hitboxes
var hitboxes: Array[HitBox]


func _ready():
	# Scan for hitbox children down two levels
	for child in hitbox_parent.get_children():
		
		for sub_child in child.get_children():
			if sub_child is HitBox:
				hitboxes.append(sub_child)
		
		if child is HitBox:
			hitboxes.append(child)
	
	# Connect to each hitbox
	for hitbox: HitBox in hitboxes:
		hitbox.hit_taken.connect(on_hit_taken)
	#print("Registered ", hitboxes.size(), " hitboxes for ", mob.name)


func on_hit_taken(vital: HitBox.Vitalness, incoming_dmg: int):
	var calculated_dmg: int
	match vital:
		HitBox.Vitalness.VITAL_CRITICAL:
			calculated_dmg = incoming_dmg * 2
			pass
		HitBox.Vitalness.VITAL_HIGH:
			calculated_dmg = incoming_dmg * 1
			pass
		HitBox.Vitalness.VITAL_MID:
			calculated_dmg = incoming_dmg * 0.75
			pass
		HitBox.Vitalness.VITAL_LOW:
			calculated_dmg = incoming_dmg * 0.5
			pass
	
	print(mob.name, " took ", HitBox.Vitalness.keys()[vital], " hit of dmg ", calculated_dmg)
	
	# Tell the server you want to deal damage to this player.
	ServerDamageRpcs.apply_damage_to_player.rpc(mob.name.to_int(), calculated_dmg)
