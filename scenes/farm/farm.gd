extends Node2D

@onready var monsters_node = Node2D.new()
@onready var main_ui_node = load("res://scenes/farm/main_ui.tscn")

func _ready():
	#var user_id = await initialize_user()
	#Global.socket.received_match_state.connect(_on_match_state)

	monsters_node.name = "Monsters"
	add_child(monsters_node)
	
	#var my_monsters = await Global.get_monsters(user_id)
	spawn_monsters([])
	add_child(main_ui_node.instantiate())

func initialize_user() -> String:
	if Global.is_my_farm:
		var connected = await Global.socket.connect_async(Global.session)
		if connected.is_exception():
			print("cannot connect to socket on server: %s" % connected)
			return ""
			
		var created = await Global.create_match(Global.session.user_id)
		if created == "":
			print("cannot create my farm")
			return ""
			
		return Global.session.user_id
	else:
		var joined = await Global.socket.join_match_async(Global.match_id)
		if joined.is_exception():
			print("cannot connect to %s farm" % Global.owner_id)
			return ""
			
		return Global.owner_id

func _on_match_state(p_state):
	if p_state.op_code == 1:
		var state_data = JSON.parse_string(p_state.data)
		remove_monster(state_data.monster_id)
		
		if Global.is_my_farm:
			$RichTextLabel.text = "หมูโดนฆ่า"
			await get_tree().create_timer(1.5).timeout
			$RichTextLabel.text = ""

func remove_monster(monster_id: String):
	var scene = $Background/Monsters
	var monster_node = scene.get_node(monster_id)
	if monster_node:
		monster_node.queue_free()

func spawn_monsters(monsters: Array):
	for monster in range(1):
		#var monster_scene = Global.MONSTER_TYPES.get(monster.monster_type, Global.MONSTER_TYPES["reaperman_3"])
		var monster_scene = Global.MONSTER_TYPES["reaperman_3"]
		var monster_instance = monster_scene.instantiate()
		
		#monster_instance.name = monster.id
		monster_instance.position = Vector2(
			randf_range(128, 1790), 
			randf_range(456, 950)   
		)
		#monster_instance.monster_id = monster.id
		
		monsters_node.add_child(monster_instance)
