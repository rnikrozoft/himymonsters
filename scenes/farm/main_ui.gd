extends Control

func _on_coin_pressed() -> void:
	Global.previous_scene = "res://scenes/farm/farm.tscn"
	get_tree().change_scene_to_file("res://scenes/shop/common_shop.tscn")
