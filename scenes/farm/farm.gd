extends Node2D

@onready var main_ui_node = load("res://scenes/farm/main_ui.tscn")
func _ready():
	var f = get_parent().get_node("Friends") #TODO
	if f:
		f.queue_free()
		
	var user_id = await initialize_user()
	Global.socket.received_match_state.connect(_on_match_state)
	
	var my_monsters = await Global.get_monsters(user_id)
	spawn_monsters(my_monsters)
	
	add_child(main_ui_node.instantiate())

func initialize_user() -> String:
	if Global.is_my_farm:
		Global.match_id = await Global.create_match(Global.session.user_id)
		return Global.session.user_id
	else:
		var joined = await Global.socket.join_match_async(Global.match_id)
		if joined.is_exception():
			print("cannot connect to %s farm" % Global.owner_id)
			return ""
			
		return Global.owner_id

func _on_match_state(p_state):
	var state_data = JSON.parse_string(p_state.data)
	main_ui_node.coin.text -= state_data.monster_kill_price
	
	if p_state.op_code == 1:
		get_node(state_data.monster_id).queue_free()
		
		if Global.is_my_farm:
			$RichTextLabel.text = "มอนสเตอร์คุณถูกสังหาร"
			await get_tree().create_timer(1.5).timeout
			$RichTextLabel.text = ""
			

func spawn_monsters(monsters: Array):
	for monster in monsters:
		var monster_scene = Global.MONSTER_TYPES.get(monster.monster_type, Global.MONSTER_TYPES["reaperman_1"])
		var monster_instance = monster_scene.instantiate()
		monster_instance.name = monster.id
		monster_instance.position = Vector2(
			randf_range(128, 1790), 
			randf_range(456, 950)   
		)
		
		monster_instance.monster = monster
		add_child(monster_instance)
