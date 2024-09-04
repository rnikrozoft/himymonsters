extends Control

func _on_gachapon_gui_input(event: InputEvent) -> void:
	if Global.is_left_click(event):
		var got = await Global.client.rpc_async(Global.session, "free_gachapon")
		var data = Global.parse_json(got.payload)
		
		if data.has("monsters"):
			for monster in data.monsters:
				var got_scene = load("res://scenes/shop/got_gachapon.tscn")
				var popup = got_scene.instantiate()
				popup.monster = monster
				add_child(popup)
