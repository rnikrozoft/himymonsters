extends Control

var parent_node
func set_parent_node(el):
	parent_node = el
	
var monster_id
func _ready() -> void:
	monster_id = parent_node.monster_id
	
func _on_kill_pressed() -> void:
	var response = await Global.client.rpc_async(Global.session, "kill_monster", JSON.stringify({
		"owner_id": Global.owner_id,
		"monster_id": monster_id,
	}))
	if response.is_exception():
		print("An error occurred: %s" % response)
		return
	
	var popup_scene = preload("res://scenes/ui/common_popup_m.tscn")
	var popup_instance = popup_scene.instantiate()
	var op_code = 1
	var payload = null
	
	if response.payload == "true":
		popup_instance.get_node("BackgroundShadow/Card/Label").text = "ฆ่าสำเร็จ"
		payload = {
			"monster_id": monster_id
		}
		parent_node.queue_free()
	else:
		op_code = 2
		if parent_node != null:
			popup_instance.get_node("BackgroundShadow/Card/Label").text = "ฆ่าไม่สำเร็จ"
			parent_node.is_moving = true
			parent_node.is_stopped = false
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
		parent_node.is_stopped = false
		queue_free()
