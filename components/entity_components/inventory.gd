class_name Inventory
extends Node
#
#signal current_slot(slot_index: int)
#signal item_stored_in_inventory(item: HandItem, slot_index: int)
#signal use_primary()
#signal use_secondary()
#
#@onready var hand_spot: Node3D = $"../Head/HandSpot"
#@onready var drop_item_cast: RayCast3D = $"../Head/FpsCamera/DropItemCast"
#@onready var interact_cast: RayCast3D = $"../Head/FpsCamera/InteractCast"
#
#var inventory_slots: Array[HandItem]
#var max_inventory_slots: int = 4
#var current_inventory_slot_index: int = 1
#var current_hand_item: HandItem = null
#
#
#func _ready():
	#for i in range(0, max_inventory_slots):
		#inventory_slots.append(null)
	#
	#select_inventory_slot(0)
#
#
#func _input(event):
	#if Input.is_action_just_pressed("slot1"):
		#select_inventory_slot(1 - 1)
	#if Input.is_action_just_pressed("slot2"):
		#select_inventory_slot(2 - 1)
	#if Input.is_action_just_pressed("slot3"):
		#select_inventory_slot(3 - 1)
	#if Input.is_action_just_pressed("slot4"):
		#select_inventory_slot(4 - 1)
	#
	#if Input.is_action_just_pressed("drop_item"):
		#if current_hand_item:
			#drop_current_item()
	#
	#if Input.is_action_just_pressed("primary"):
		#use_primary.emit()
	#if Input.is_action_just_pressed("secondary"):
		#use_secondary.emit()
#
#
#func _process(delta):
	#if Input.is_action_just_pressed("scroll_up"):
		#select_inventory_slot((current_inventory_slot_index + 1) % max_inventory_slots)
	#if Input.is_action_just_pressed("scroll_down"):
		#var next_slot: int = (current_inventory_slot_index - 1) % max_inventory_slots
		## Prevent negative slot index
		#if next_slot < 0:
			#next_slot = max_inventory_slots + next_slot
		#select_inventory_slot(next_slot)
#
#
#func select_inventory_slot(slot_index: int):
	## Hide current item
	#if inventory_slots[current_inventory_slot_index]:
		#inventory_slots[current_inventory_slot_index].visible = false
		#unequip_item(inventory_slots[current_inventory_slot_index])
	#
	## Inventory array is 0-indexed
	#current_inventory_slot_index = slot_index
	#current_hand_item = inventory_slots[current_inventory_slot_index]
	#if current_hand_item:
		#current_hand_item.visible = true
		#equip_item(inventory_slots[current_inventory_slot_index])
	#
	#current_slot.emit(current_inventory_slot_index)
#
#
#func interact_with_item(item: HandItem):
	#print("Interacting with item: ", item.name)
	#if current_hand_item:
		## Add to empty inventory slot
		#var next_empty_slot: int = get_next_empty_slot_index()
		#if next_empty_slot == -1:
			#print("No room in inventory")
		#else:
			#store_item_in_inventory(item, next_empty_slot)
			#print("add to empty slot: ", next_empty_slot)
			#pickup_item(item)
			#item.visible = false
		#pass
	#else:
		## Add to current hand
		#current_hand_item = item
		#store_item_in_inventory(item, current_inventory_slot_index)
		#pickup_item(item)
		#equip_item(item)
		#pass
#
#
#func store_item_in_inventory(item: HandItem, slot_index: int):
	#inventory_slots[slot_index] = item
	#item_stored_in_inventory.emit(item, slot_index)
	#print("Stored item: ", item.name, " in slot: ", slot_index, " and next open space is: ", get_next_empty_slot_index())
#
#
#func get_next_empty_slot_index() -> int:
	#for i in range(0, max_inventory_slots):
		#var test_index: int = (current_inventory_slot_index + i) % (max_inventory_slots)
		#if inventory_slots[test_index] == null:
			#return test_index
	#return -1
#
#
##func on_empty_interact():
	##if current_hand_item:
		##drop_current_item()
#
#
#func pickup_item(item: HandItem):
	#item.on_interact()
	#item.reparent(hand_spot)
	#item.global_position = hand_spot.global_position
	#item.global_rotation = hand_spot.global_rotation # + Vector3(deg_to_rad(180), 0, deg_to_rad(180))
	#if item.face_towards_user:
		#item.rotation = Vector3(deg_to_rad(30), deg_to_rad(135), deg_to_rad(10))
	#interact_cast.add_exception(item)
#
#
#func equip_item(item: HandItem):
	#use_primary.connect(item.on_primary)
	#use_secondary.connect(item.on_secondary)
#
#
#func unequip_item(item: HandItem):
	#use_primary.disconnect(item.on_primary)
	#use_secondary.disconnect(item.on_secondary)
#
#
#func drop_current_item():
	#if current_hand_item:
		#interact_cast.remove_exception(current_hand_item)
		#
		#unequip_item(current_hand_item)
		#
		## Reparent into world
		#current_hand_item.on_drop()
		#current_hand_item.global_rotation.x = 0
		#current_hand_item.global_rotation.z = 0
		#if drop_item_cast.is_colliding():
			#current_hand_item.global_position = drop_item_cast.global_position
		#else:
			#current_hand_item.global_position = drop_item_cast.to_global(drop_item_cast.target_position)
		#
		#
		#inventory_slots[current_inventory_slot_index] = null
		#current_hand_item = null
		#item_stored_in_inventory.emit(null, current_inventory_slot_index)
