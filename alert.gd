class_name Alert

func steal_or_kill(el):
	var steal_or_kill = preload("res://scenes/ui/steal_or_kill_popup.tscn")
	var steal_or_kill_scene = steal_or_kill.instantiate()
	
	steal_or_kill_scene.monster_id = el.monster_id
	steal_or_kill_scene.farm_node = el
	el.get_tree().current_scene.add_child(steal_or_kill_scene)

func close(el):
	el.queue_free()
