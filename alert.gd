extends Node

func steal_or_kill(monster_node):
	var steal_or_kill_popup = Global.ALERTS_SCENES[Global.steal_or_kill].instantiate()
	steal_or_kill_popup.monster_node = monster_node
	monster_node.get_parent().add_child(steal_or_kill_popup)
