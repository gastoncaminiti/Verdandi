extends Node2D

export(PackedScene)  var play_scene
export(PackedScene)  var rune_scene

func _ready():
	$AnimationPlayer.play("idle")

func _on_LinkButtonPlay_pressed():
	if(play_scene):
		return get_tree().change_scene_to(play_scene)


func _on_LinkButtonOptions_pressed():
	if TranslationServer.get_locale() == "en":
		TranslationServer.set_locale("es")
	else:
		TranslationServer.set_locale("en")

func _on_LinkButtonRunes_pressed():
	if(rune_scene):
		return get_tree().change_scene_to(rune_scene)


func _on_LinkButtonQuit_pressed():
	return get_tree().quit()
