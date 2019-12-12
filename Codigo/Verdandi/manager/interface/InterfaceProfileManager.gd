extends Node2D

var path_skin_0 = "res://avatar/norse/sigrdrifa/skin/Common.tres"
var path_skin_1 = "res://avatar/norse/sigrdrifa/skin/Gold.tres"

func _ready():
	match DataManager.user_data.skin:
		path_skin_0:
			get_node("Layer 2 - GUI/AvatarContainer/AvatarSelected/AnimatedSprite").set_sprite_frames(load(path_skin_0))
			get_node("Layer 2 - GUI/AvatarContainer/HBoxContainer/TextureButtonSkin1").grab_focus()
		path_skin_1:
			get_node("Layer 2 - GUI/AvatarContainer/AvatarSelected/AnimatedSprite").set_sprite_frames(load(path_skin_1))
			get_node("Layer 2 - GUI/AvatarContainer/HBoxContainer/TextureButtonSkin2").grab_focus()
	if DataManager.maped_levels.size() == DataManager.user_data.progression.legends.size():
		get_node("Layer 2 - GUI/AvatarContainer/HBoxContainer/TextureButtonSkin2").disabled = false
		get_node("Layer 2 - GUI/AvatarContainer/HBoxContainer/TextureButtonSkin2").set_focus_mode(2)
	else:
		get_node("Layer 2 - GUI/AvatarContainer/HBoxContainer/TextureButtonSkin2").set_focus_mode(0)
		
	if DataManager.user_data.progression.legends.size() > 0:
		var legends = get_node("Layer 2 - GUI/SagaContainer/GridSigurd").get_children()
		var c = Color(1,1,1,1)
		for i in range(DataManager.user_data.progression.legends.size()):
			legends[i].get_child(0).modulate = c
			legends[i].get_child(1).disabled = false

func _on_LinkButtonL1_pressed():
	DataManager.user_data.progression.act_index = 0
	return get_tree().change_scene_to(load("res://interface/LegendInterface.tscn"))

func _on_LinkButtonL2_pressed():
	DataManager.user_data.progression.act_index = 1
	return get_tree().change_scene_to(load("res://interface/LegendInterface.tscn"))

func _on_LinkButtonL3_pressed():
	DataManager.user_data.progression.act_index = 2
	return get_tree().change_scene_to(load("res://interface/LegendInterface.tscn"))

func _on_LinkButtonL4_pressed():
	DataManager.user_data.progression.act_index = 3
	return get_tree().change_scene_to(load("res://interface/LegendInterface.tscn"))

func _on_TextureButtonSkin1_pressed():
	get_node("Layer 2 - GUI/AvatarContainer/AvatarSelected/AnimatedSprite").set_sprite_frames(load(path_skin_0))
	DataManager.user_data.skin = path_skin_0
	DataManager.save_user_data_encrypted()

func _on_TextureButtonSkin2_pressed():
	get_node("Layer 2 - GUI/AvatarContainer/AvatarSelected/AnimatedSprite").set_sprite_frames(load(path_skin_1))
	DataManager.user_data.skin = path_skin_1
	DataManager.save_user_data_encrypted()

func _on_Exit_pressed():
	return get_tree().change_scene_to(load(DataManager.user_data.menu))
