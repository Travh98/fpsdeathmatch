class_name UseEquippedItem
extends Node

## Passes user input to trigger an item's functions
signal unarmed()
signal using_pistol()

## The mob for this node
@onready var mob: Node = $"../.."
@onready var revolver: Revolver = $"../../Head/HandSpot/Revolver"

enum ItemSlots {
	SLOT_REVOLVER,
	SLOT_RIFLE,
	SLOT_HANDS,
}

## The Node3D that items will be a child of
var hand_spot: Node3D
## The eye raycast used for clicking on things from player's point of view 
var eye_cast: RayCast3D
## The raycast for hitting hitboxes
var hitbox_cast: RayCast3D : set = set_hitbox_cast

var current_slot: ItemSlots = ItemSlots.SLOT_REVOLVER


func switch_to_item_slot(new_slot: ItemSlots):
	if hand_spot == null:
		return
	if current_slot == new_slot:
		return
	
	current_slot = new_slot
	for item in hand_spot.get_children():
		item.visible = false
	
	match current_slot:
		ItemSlots.SLOT_REVOLVER:
			revolver.visible = true
			using_pistol.emit()
		ItemSlots.SLOT_RIFLE:
			pass
		ItemSlots.SLOT_HANDS:
			unarmed.emit()
			pass
		_:
			pass
	
	if not is_multiplayer_authority():
		return
	
	# Tell the rest of the server
	ServerPlayerDataRpcs.request_update_player_data.rpc_id(1, multiplayer.get_unique_id(),
		PlayerDataMgr.PlayerDataKeys.PD_EQUIPPEDSLOT, str(current_slot))


func handle_primary():
	match current_slot:
		ItemSlots.SLOT_REVOLVER:
			revolver.mob = mob
			revolver.use_primary(eye_cast, hitbox_cast)
		ItemSlots.SLOT_RIFLE:
			pass
		ItemSlots.SLOT_HANDS:
			pass
		_:
			pass
		
	#print("Using primary")
	pass


func handle_reload():
	match current_slot:
		ItemSlots.SLOT_REVOLVER:
			revolver.reload()
		ItemSlots.SLOT_RIFLE:
			pass
		ItemSlots.SLOT_HANDS:
			pass
		_:
			pass


func reset_items():
	revolver.reset()


func set_hitbox_cast(cast: RayCast3D):
	hitbox_cast = cast
	hitbox_cast.collide_with_areas = true
	hitbox_cast.set_collision_mask_value(4, true)
