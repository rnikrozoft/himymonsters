extends Control

@onready var monster_node
func _ready() -> void:
	$Panel/Name.text = monster_node.monster.name
	$Panel/KillRateSuccess.text = str(10-monster_node.monster.kill.rate_success)
	$Panel/StealRateSuccess.text = str(10-monster_node.monster.steal.rate_success)
	
	var prefab = load("res://prefabs/monsters/"+monster_node.monster.monster_type+".tscn")
	var prefab_instance = prefab.instantiate()
	prefab_instance.position = Vector2(455,375)
	$Panel.add_child(prefab_instance)
	
func _on_gui_input(event: InputEvent) -> void:
	if Global.is_left_click(event):
		monster_node.movement_configs.is_stopped = false
		queue_free()
