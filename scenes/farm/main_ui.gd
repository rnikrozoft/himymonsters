extends Control

func _ready() -> void:
	if !Global.is_my_farm:
		$BackToMyFarm.visible = true
		
func _on_coin_pressed() -> void:
	Global.previous_scene = "res://scenes/farm/farm.tscn"
	get_tree().change_scene_to_file("res://scenes/shop/common_shop.tscn")

func _on_friends_pressed() -> void:
	var friends_scene = load("res://scenes/friends/friends.tscn")
	var friends = friends_scene.instantiate()
	add_child(friends)

func _on_back_to_my_farm_pressed() -> void:
	Global.set_visit_to_my_farm()
	get_tree().change_scene_to_file("res://scenes/farm/farm.tscn")
