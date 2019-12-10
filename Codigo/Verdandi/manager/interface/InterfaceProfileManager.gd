extends Node2D

func _ready():
	var legends = get_node("Layer 2 - GUI/SagaContainer/GridSigurd").get_children()
	var c = Color(1,1,1,1)
	for i in range(DataManager.user_data.progression.legends.size()):
		legends[i].get_child(0).modulate = c
		legends[i].get_child(1).disabled = false

func _on_LinkButtonL1_pressed():
	DataManager.user_data.progression.act_index = 0
	return get_tree().change_scene_to(load("res://interface/LegendInterface.tscn"))

func _on_LinkButtonL2_pressed():
	DataManager.user_data.progression.act_index = 1
	return get_tree().change_scene_to(load("res://interface/LegendInterface.tscn"))

func _on_LinkButtonL3_pressed():
	DataManager.user_data.progression.act_index = 2
	return get_tree().change_scene_to(load("res://interface/LegendInterface.tscn"))

func _on_LinkButtonL4_pressed():
	DataManager.user_data.progression.act_index = 3
	return get_tree().change_scene_to(load("res://interface/LegendInterface.tscn"))
