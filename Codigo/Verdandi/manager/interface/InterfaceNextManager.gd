extends Node2D

func _on_Button_pressed():
	return get_tree().change_scene_to(load("res://interface/LegendInterface.tscn"))


func _on_ButtonRetry_pressed():
	return get_tree().reload_current_scene()

func update_next_inteface(status, message, x, y):
	$BackRect/VContainer/CCTitle/LTitle.text = "KEY_VICTORY" if status else "KEY_DEFEAT"
	$BackRect/VContainer/CCEffectDescription/LEffectDescription.text = message
	$BackRect/VContainer/HCAlignment/CContainer/Button.visible = status
	$BackRect/VContainer/HCAlignment/CContainerRetry/ButtonRetry.visible = !status
	global_position = Vector2(x,y)