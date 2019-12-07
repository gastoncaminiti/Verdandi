extends Node2D

export(PackedScene)  var saga0_level0

func _on_BLevel0_pressed():
	get_node("Layer 2 - GUI/VCInterface/HCSagasContainer/VCSaga0/CContainer/AnimatedSprite").play("play")

func _on_AnimatedSprite_animation_finished():
	if(saga0_level0):
		return get_tree().change_scene_to(saga0_level0)

func _on_Exit_pressed():
	return get_tree().change_scene_to(load(DataManager.user_data.menu))
