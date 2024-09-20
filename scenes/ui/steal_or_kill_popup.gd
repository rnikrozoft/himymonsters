extends Control

@onready var monster_node
@onready var is_killing = false
@onready var is_stealing = false

func _on_kill_pressed() -> void:
	is_killing = true
	$BackGroundShadow/HBoxContainer/MarginLeftButton/Steal.disabled = true
	var response = await Global.client.rpc_async(Global.session, "kill_monster", JSON.stringify({
		"owner_id": Global.owner_id,
		"monster_id": monster_node.monster.id,
	}))
	if response.is_exception():
		print("An error occurred: %s" % response)
		return
	
	var popup_scene = load("res://scenes/ui/common_popup_m.tscn")
	var popup_instance = popup_scene.instantiate()
	var op_code = 1
	var payload = null
	
	if response.payload == "true": #TODO
		popup_instance.get_node("BackgroundShadow/Card/Label").text = "ฆ่าสำเร็จ"
		payload = {
			"monster_id": monster_node.monster.id,
			"monster_kill_price": monster_node.monster.kill.price
		}
		monster_node.queue_free()
	else:
		op_code = 2
		payload = {
			"monster_kill_price": monster_node.monster.kill.price
		}
		if monster_node != null:
			popup_instance.get_node("BackgroundShadow/Card/Label").text = "ฆ่าไม่สำเร็จ"
			monster_node.movement_configs.is_moving = true
			monster_node.movement_configs.is_stopped = false
		else:
			popup_instance.get_node("BackgroundShadow/Card/Label").text = "ถูกฆ่าแล้ว"
	
	Global.socket.send_match_state_async(Global.match_id, op_code, JSON.stringify(payload))
	
	queue_free()
	get_parent().add_child(popup_instance)

func _on_back_ground_shadow_gui_input(event) -> void:
	if is_killing || is_stealing:
		return
		
	if Global.is_left_click(event):
		monster_node.movement_configs.is_stopped = false
		queue_free()

func _on_steal_pressed() -> void:
	is_stealing = true
	$BackGroundShadow/HBoxContainer/MarginRightButton/Kill.disabled = true
	var response = await Global.client.rpc_async(Global.session, "steal_monster", JSON.stringify({
		"owner_id": Global.owner_id,
		"monster_id": monster_node.monster.id,
	}))
	if response.is_exception():
		print("An error occurred: %s" % response)
		return
	
	var popup_scene = load("res://scenes/ui/common_popup_m.tscn")
	var popup_instance = popup_scene.instantiate()
	var op_code = 1
	var payload = null
	
	if response.payload == "true": #TODO
		popup_instance.get_node("BackgroundShadow/Card/Label").text = "ขโมยสำเร็จ"
		payload = {
			"monster_id": monster_node.monster.id
		}
		monster_node.queue_free()
	else:
		op_code = 2
		if monster_node != null:
			popup_instance.get_node("BackgroundShadow/Card/Label").text = "ขโมยไม่สำเร็จ"
			monster_node.movement_configs.is_moving = true
			monster_node.movement_configs.is_stopped = false
		else:
			popup_instance.get_node("BackgroundShadow/Card/Label").text = "ถูกขโมยไปแล้ว"
	
	Global.socket.send_match_state_async(Global.match_id, op_code, JSON.stringify(payload))
	
	queue_free()
	get_parent().add_child(popup_instance)
