extends Node

func _on_back_pressed():
	get_tree().change_scene_to_file(Global.previous_scene)

#func _on_dimond_and_coin_pressed():
	#var parent_name = get_parent().name
	#if parent_name != "Shop":
		#get_tree().change_scene_to_file("res://scenes/shop/common_shop.tscn")
