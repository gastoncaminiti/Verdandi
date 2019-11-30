extends Node2D



func _on_Button_pressed():
	return get_tree().change_scene_to(load("res://interface/LegendInterface.tscn"))


func _on_ButtonRetry_pressed():
	return get_tree().reload_current_scene()
