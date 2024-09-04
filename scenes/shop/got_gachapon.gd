extends Node2D

var monster
var refabs = {
	"minotaur_3": preload("res://scenes/monsters/minotaur_3.tscn"),
}
func _ready() -> void:
	var popup_scene = refabs["minotaur_3"]
	var monster_instance = popup_scene.instantiate()
	$Background.add_child(monster_instance)


func _on_background_gui_input(event: InputEvent) -> void:
	if Global.is_left_click(event):
		queue_free()
