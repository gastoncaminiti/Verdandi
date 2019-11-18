extends Node2D



func _on_Button_pressed():
	return get_tree().change_scene_to(load(ProjectSettings.get_setting("application/run/main_scene")))
