extends Node2D

var index_papyrus = 0
var size = 8

func _ready():
	var aux_key = String(DataManager.user_data.progression.saga_index) + String(DataManager.user_data.progression.act_index)
	for i in range(DataManager.user_data.progression.legends[aux_key].size()):
		get_node("Layer 2 - GUI/Papyrus/GridContainer/CChar"+String(i)+"/Char0").text = DataManager.user_data.progression.legends[aux_key][i].key
		get_node("Layer 2 - GUI/VContainer/ScrollContainer/VSagaContainer/LMilestone"+String(i)).text = DataManager.user_data.progression.legends[aux_key][i].milestone
	$AnimationPlayer.play("EnterPapyrus")

func _on_AnimationPlayer_animation_finished(anim_name):
	$Tween.interpolate_property(get_node("Layer 2 - GUI/Papyrus"), "modulate",   Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	if object.name =="Papyrus":
		$Tween.interpolate_property(get_node("Layer 2 - GUI/VContainer/VTitleContainer/Label"), "modulate",   Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	if object.name =="Label":
		$Tween.interpolate_property(get_node("Layer 2 - GUI/VContainer/VTitleContainer/LRuneName"), "modulate",   Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	if object.name =="LRuneName":
		$Tween.interpolate_property(get_node("Layer 2 - GUI/VContainer/ScrollContainer"), "modulate",   Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	if object.name =="ScrollContainer":
		var aux_c = "Layer 2 - GUI/Papyrus/GridContainer/CChar"+String(index_papyrus)+"/Char0"
		$TweenPapyrus.interpolate_property(get_node(aux_c), "modulate",   Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenPapyrus.start()

func _on_TweenPapyrus_tween_completed(object, key):
	var aux_s = "Layer 2 - GUI/VContainer/ScrollContainer/VSagaContainer/LMilestone"+String(index_papyrus)
	$TweenSaga.interpolate_property(get_node(aux_s), "modulate",   Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenSaga.start()

func _on_TweenSaga_tween_completed(object, key):
	index_papyrus+=1
	if index_papyrus < size:
		var aux_c = "Layer 2 - GUI/Papyrus/GridContainer/CChar"+String(index_papyrus)+"/Char0"
		$TweenPapyrus.interpolate_property(get_node(aux_c), "modulate",   Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenPapyrus.start()

func _on_Exit_pressed():
	return get_tree().change_scene_to(load("res://interface/SelectLevelInterface.tscn"))
