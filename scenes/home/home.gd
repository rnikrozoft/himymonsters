extends TextureRect

@onready var line_edit = $LineEdit

func _on_loggin_with_guest_pressed():
	var device_id = OS.get_unique_id() + line_edit.text
	var session = await authenticate_device(device_id)
	if session:
		Global.session = session
		await register_user(device_id)
		
		var connected = await Global.socket.connect_async(Global.session)
		if connected.is_exception():
			print("cannot connect to socket on server: %s" % connected)
			return
			
		Global.set_visit_to_my_farm()
		change_scene_to_farm()

func authenticate_device(device_id: String) -> NakamaSession:
	var session = await Global.client.authenticate_device_async(device_id)
	if session.is_exception():
		print("Authentication failed: %s" % session)
		return null
		
	return session

func register_user(device_id: String) -> void:
	await Global.client.rpc_async(Global.session, "register", JSON.stringify({
		"device_id": device_id,
		"username": Global.session.username,
		"created": Global.session.created
	}))

func change_scene_to_farm() -> void:
	get_tree().change_scene_to_file("res://scenes/farm/farm.tscn")
