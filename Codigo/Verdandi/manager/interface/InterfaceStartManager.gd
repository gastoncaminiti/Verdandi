extends Node2D

export(PackedScene)  var open_scene

func _ready():
	$AnimationPlayer.play("idle")

func _on_LinkButtonPlay_pressed():
	if(open_scene):
		return get_tree().change_scene_to(open_scene)


func _on_LinkButtonOptions_pressed():
	print("S")
	TranslationServer.set_locale("es")
