extends Node2D


func _ready():
	$Tween.interpolate_property(get_node("Layer 2 - GUI/Logo"), "modulate",   Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween2.interpolate_property(get_node("Layer 0 - Background/TextureRect"), "modulate",   Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$Tween2.start()

func _on_Tween_tween_completed(object, key):
	object.play("stand")
	$Music.play()
	$Tween2.interpolate_property(get_node("Layer 2 - GUI/Label"), "modulate",   Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween2.start()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		return get_tree().change_scene_to(load(ProjectSettings.get_setting("application/run/main_scene")))

func _on_Music_finished():
	return get_tree().change_scene_to(load(ProjectSettings.get_setting("application/run/main_scene")))
