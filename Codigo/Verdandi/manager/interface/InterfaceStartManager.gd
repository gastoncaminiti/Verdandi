extends Node2D

export(PackedScene)  var play_scene
export(PackedScene)  var rune_scene

func _ready():
	$AnimationPlayer.play("idle")

func _on_LinkButtonPlay_pressed():
	if(play_scene):
		return get_tree().change_scene_to(play_scene)


func _on_LinkButtonOptions_pressed():
	TranslationServer.set_locale("es")


func _on_LinkButtonRunes_pressed():
	if(rune_scene):
		return get_tree().change_scene_to(rune_scene)
