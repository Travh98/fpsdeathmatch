class_name PlayerDataView
extends Control

## Displays this client's PlayerDataMgr data on the UI

@export var playerDataMgr: PlayerDataMgr : set = set_player_data_mgr

@onready var item_list: ItemList = $MarginContainer/HBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/ItemList

var ignore_peer_ids: bool = true
var ignore_name_keys: bool = true


func set_player_data_mgr(data_mgr: PlayerDataMgr):
	playerDataMgr = data_mgr
	playerDataMgr.player_data_changed.connect(on_player_data_changed)


func on_player_data_changed():
	item_list.clear()
	item_list.same_column_width = true
	
	# Have a column for each key and value
	var num_columns: int = playerDataMgr.players_data[playerDataMgr.players_data.keys()[0]].size() * 2 + 1
	if ignore_peer_ids:
		num_columns -= 1
	if ignore_name_keys:
		num_columns -= 1
	item_list.max_columns = num_columns
	
	# For each peer id in the data
	for peer_id in playerDataMgr.players_data:
		if not ignore_peer_ids:
			item_list.add_item(str(peer_id), null, false)
		
		# Create a row for this peer_id
		for data_key in playerDataMgr.players_data[peer_id]:
			if ignore_name_keys:
				if str(data_key) == "name":
					item_list.add_item(str(playerDataMgr.players_data[peer_id][data_key]), null, false)
					continue
			
			item_list.add_item(str(data_key), null, false)
			item_list.add_item(str(playerDataMgr.players_data[peer_id][data_key]), null, false)
