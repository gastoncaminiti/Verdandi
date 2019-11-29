extends Node2D

var index_papyrus = 0

func _ready():
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
	if index_papyrus < 24:
		var aux_c = "Layer 2 - GUI/Papyrus/GridContainer/CChar"+String(index_papyrus)+"/Char0"
		$TweenPapyrus.interpolate_property(get_node(aux_c), "modulate",   Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenPapyrus.start()