extends Node2D

var monster
func _ready() -> void:
	var monster_scene = load("res://prefabs/monsters/"+monster.monster_type+".tscn")
	var monster_instance = monster_scene.instantiate()
	monster_instance.position = Vector2(1080,535)
	$Background.add_child(monster_instance)

func _on_background_gui_input(event: InputEvent) -> void:
	if Global.is_left_click(event):
		queue_free()
