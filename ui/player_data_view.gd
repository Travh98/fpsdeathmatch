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
		for data_key: PlayerDataMgr.PlayerDataKeys in playerDataMgr.players_data[peer_id]:
			# Ignore some keys
			if ignore_name_keys:
				if data_key == PlayerDataMgr.PlayerDataKeys.PD_NAME:
					item_list.add_item(str(playerDataMgr.players_data[peer_id][data_key]), null, false)
					continue
			
			# Special processing for some values
			if data_key == PlayerDataMgr.PlayerDataKeys.PD_LASTHURTBY:
				# Try converting peer_id to display as username
				item_list.add_item(get_data_key_string(data_key), null, false)
				var hurt_by_peer_id: int = playerDataMgr.players_data[peer_id][data_key].to_int()
				if hurt_by_peer_id != 0:
					var hurt_by_name: String = str(playerDataMgr.players_data[hurt_by_peer_id][PlayerDataMgr.PlayerDataKeys.PD_NAME])
					item_list.add_item(hurt_by_name, null, false)
				else:
					item_list.add_item("NA", null, false)
				continue
			
			item_list.add_item(get_data_key_string(data_key), null, false)
			item_list.add_item(str(playerDataMgr.players_data[peer_id][data_key]), null, false)


## Get a visually appealing string for the player data key
func get_data_key_string(key: PlayerDataMgr.PlayerDataKeys) -> String:
	return str(PlayerDataMgr.PlayerDataKeys.keys()[key]).lstrip("PD_")
