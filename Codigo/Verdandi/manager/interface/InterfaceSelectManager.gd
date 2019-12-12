extends Node2D

var selected_level  = "00"
var animated_flag 

func _ready():
	animated_flag = get_node("Layer 2 - GUI/VCInterface/HCSagasContainer/VCSaga0/CContainer/AnimatedSprite")
	if DataManager.user_data.progression.legends.size() > 0 : 
		var all_Sigurd_BLevel = get_tree().get_nodes_in_group("Btn")
		for i in range(DataManager.user_data.progression.legends.size()):
			all_Sigurd_BLevel[i].disabled = false
			if i + 1 < DataManager.maped_levels.size():
				all_Sigurd_BLevel[i+1].disabled = false

func _on_BLevel0_pressed():
	animated_flag.play("play")
	animated_flag.set_frame(0)
	selected_level  = "00"

func _on_BLevel1_pressed():
	animated_flag.play("play")
	animated_flag.set_frame(0)
	selected_level  = "01"

func _on_BLevel2_pressed():
	animated_flag.play("play")
	animated_flag.set_frame(0)
	selected_level  = "02"

func _on_BLevel3_pressed():
	animated_flag.play("play")
	animated_flag.set_frame(0)
	selected_level  = "03"

func _on_AnimatedSprite_animation_finished():
	if DataManager.maped_levels.has(selected_level):
		return get_tree().change_scene_to(load(DataManager.maped_levels[selected_level]))
	else:
		print("NEXT LEVEL EN DESARROLLO")

func _on_Exit_pressed():
	return get_tree().change_scene_to(load(DataManager.user_data.menu))