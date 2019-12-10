extends Node2D

export(PackedScene)  var play_scene
export(PackedScene)  var rune_scene
export(PackedScene)  var options_scene
export(PackedScene)  var profile_scene

func _ready():
	$AnimationPlayer.play("idle")

func _on_LinkButtonPlay_pressed():
	if(play_scene):
		return get_tree().change_scene_to(play_scene)

func _on_LinkButtonOptions_pressed():
	if(options_scene):
		var gui = get_node("Layer 2 - GUI")
		if gui.get_child(gui.get_child_count()-1).name != "OptionsInterface":
			var aux_options = options_scene.instance()
			get_node("Layer 2 - GUI").add_child(aux_options)
			get_node("Layer 2 - GUI/OptionsInterface").global_position = Vector2(560,300)
		
		
func _on_LinkButtonRunes_pressed():
	if(rune_scene):
		return get_tree().change_scene_to(rune_scene)

func _on_LinkButtonQuit_pressed():
	return get_tree().quit()


func _on_LinkButtonProfile_pressed():
	if(profile_scene):
		return get_tree().change_scene_to(profile_scene)
