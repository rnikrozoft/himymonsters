extends Node

@onready var client = Nakama.create_client("defaultkey", "localhost", 7350, "http")
@onready var socket = Nakama.create_socket_from(client)

var session
var match_id
var owner_id
var is_my_farm
var previous_scene

var MONSTER_TYPES = {
	"fallen_1": load("res://scenes/monsters/fallen_1.tscn"),
	"golem_3": load("res://scenes/monsters/golem_3.tscn"),
	"minotaur_3": load("res://scenes/monsters/minotaur_3.tscn"),
	"reaperman_1": load("res://scenes/monsters/reaperman_1.tscn"),
	"reaperman_2": load("res://scenes/monsters/reaperman_2.tscn"),
	"reaperman_3": load("res://scenes/monsters/reaperman_3.tscn")
}

func is_left_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed

func get_my_info():
	var account : NakamaAPI.ApiAccount = await client.get_account_async(session)
	if account.is_exception():
		print("An error occurred: %s" % account)
		return
	return account

func get_monsters(user_id: String):
	var monsters = await client.rpc_async(session, "get_monsters",JSON.stringify({
		"owner_id": user_id
	}))
	var data = parse_json(monsters.payload)
	return data.monsters
	
func parse_json(json_string: String) -> Dictionary:
	var json = JSON.new()
	if json.parse(json_string) == OK:
		return json.data
		
	return {}
	
func create_match(user_id: String) -> String:
	var created_match = await socket.create_match_async(user_id)
	if created_match.is_exception():
		print("An error occurred: %s" % created_match)
		return ""
		
	return created_match.match_id

func set_visit_to_other_farm(id, user_id) -> void:
	match_id = id
	owner_id = user_id
	is_my_farm = false

func set_visit_to_my_farm() -> void:
	match_id = session.user_id
	owner_id = session.user_id
	is_my_farm = true

var steal_or_kill = "steal_or_kill"
var ALERTS_SCENES = {
	steal_or_kill: load("res://scenes/ui/steal_or_kill_popup.tscn")
}
