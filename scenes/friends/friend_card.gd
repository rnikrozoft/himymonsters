extends Panel

var user
var state
func _ready():
	$Name.text = user.username
	if state == 0:
		$AddFriend.text = "ลบเพื่อน"
	if state == 1:
		$AddFriend.text = "ยกเลิก"
	if state == 2:
		$AddFriend.text = "ตอบรับ"
		
func _on_add_friend_pressed() -> void:
	var ids = [user.id]
	if state == 0 || state == 1:
		var remove = await Global.client.delete_friends_async(Global.session, ids, Global.session.username)
		if remove.is_exception():
			print("An error occurred: %s" % remove)
			return
		$AddFriend.text = "เพิ่มเพื่อน"
	else:
		var result = await Global.client.add_friends_async(Global.session, ids, Global.session.username)
		if result.is_exception():
			print("An error occurred: %s" % result)
			return
		state = 1
		$AddFriend.text = "ยกเลิก"

func _on_goto_farm_pressed() -> void:
	var leave = await Global.socket.leave_match_async(Global.match_id)
	if leave.is_exception():
		print("An error occurred: %s" % leave)
		return
	var match_id = await Global.create_match(user.id)
	Global.set_visit_to_other_farm(match_id, user.id)
	get_tree().change_scene_to_file("res://scenes/farm/farm.tscn")
