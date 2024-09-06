extends Node

func steal_or_kill(parent_node):
	var steal_or_kill_popup = Global.ALERTS_SCENES[Global.steal_or_kill].instantiate()
	steal_or_kill_popup.set_parent_node(parent_node)
	parent_node.get_parent().add_child(steal_or_kill_popup)
