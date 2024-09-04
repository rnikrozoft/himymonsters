extends Control

var monster_id
var farm_node

func _on_kill_pressed() -> void:
	var response = await Global.client.rpc_async(Global.session, "kill_monster", JSON.stringify({
		"owner_id": Global.owner_id,
		"monster_id": monster_id,
	}))
	if response.is_exception():
		print("An error occurred: %s" % response)
	
	var popup_scene = preload("res://scenes/ui/common_popup_m.tscn")
	var popup_instance = popup_scene.instantiate()
	
	var op_code = 1
	var payload = null
	if response.payload == "true":
		popup_instance.get_node("BackgroundShadow/Card/Label").text = "ฆ่าสำเร็จ"
		payload = {
			"monster_id": monster_id
		}
		farm_node.queue_free()
	else:
		op_code = 2
		if farm_node != null:
			popup_instance.get_node("BackgroundShadow/Card/Label").text = "ฆ่าไม่สำเร็จ"
			farm_node.is_moving = true
			farm_node.is_stopped = false
		else:
			popup_instance.get_node("BackgroundShadow/Card/Label").text = "ถูกฆ่าแล้ว"
	
	Global.socket.send_match_state_async(Global.match_id, op_code, JSON.stringify(payload))
	
	var current_scene = get_parent().get_parent()
	current_scene.add_child(popup_instance)
	
	await get_tree().create_timer(1.5).timeout
	popup_instance.queue_free()
	queue_free()

func _on_back_ground_shadow_gui_input(event) -> void:
	if Global.is_left_click(event):
		var alert = Alert.new()
		farm_node.is_stopped = false
		alert.close(self)
