extends Node

@onready var grid_container = $Background/ScrollContainer/GridContainer

func update_my_friend_list() -> void:
	var list = await Global.client.list_friends_async(Global.session)
	if list.is_exception():
		print("An error occurred: %s" % list)
		return

	for f in list.friends:
		var friend_card_scene = load("res://scenes/friends/friend_card.tscn")
		var friend_card = friend_card_scene.instantiate()
		friend_card.custom_minimum_size = Vector2(770, 265)
	#
		var friend = f as NakamaAPI.ApiFriend
		friend_card.user = friend.user
		friend_card.state = f.state
		grid_container.add_child(friend_card)
		
func _ready() -> void:
	update_my_friend_list()
	
func _on_gui_input(event):
	if Global.is_left_click(event):
		queue_free()

func _on_search_text_changed(new_text):
	for child in grid_container.get_children():
			child.queue_free()
				
	if new_text == "":
		update_my_friend_list()

	if new_text != Global.session.user_id:
		var ids = [new_text]
		var result = await Global.client.get_users_async(Global.session, ids, Global.session.username, null)

		if result.is_exception():
			for child in grid_container.get_children():
				child.queue_free()
			return
			
		for user in result.users:
			var friend_card_scene = load("res://scenes/friends/friend_card.tscn")
			var friend_card = friend_card_scene.instantiate()
			friend_card.custom_minimum_size = Vector2(770, 265)
			friend_card.user = user
			grid_container.add_child(friend_card)
