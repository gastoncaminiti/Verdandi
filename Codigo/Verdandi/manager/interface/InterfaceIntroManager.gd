extends Node2D

func _ready():
	$TweenRune1.interpolate_property(get_node("Layer 2 - GUI/Rune_1"), "global_position",Vector2(450,-50), Vector2(550,700), 12, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenRune2.interpolate_property(get_node("Layer 2 - GUI/Rune_2"), "global_position",Vector2(300,-100), Vector2(275,700), 18, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenRune3.interpolate_property(get_node("Layer 2 - GUI/Rune_3"), "global_position",Vector2(760,-150), Vector2(700,700), 22, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenRune4.interpolate_property(get_node("Layer 2 - GUI/Rune_4"), "global_position",Vector2(200,-250), Vector2(300,700), 26, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenRune5.interpolate_property(get_node("Layer 2 - GUI/Rune_5"), "global_position",Vector2(450,-150), Vector2(550,700), 30, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenRune1.start()
	$TweenRune1.start()
	$TweenRune2.start()
	$TweenRune3.start()
	$TweenRune4.start()
	$TweenRune5.start()

func _on_TweenRune1_tween_completed(object, key):
	if object.name == "Rune_1":
		$TweenRune1.interpolate_property(get_node("Layer 2 - GUI/Rune_6"), "global_position",Vector2(300,-50), Vector2(280,700), 30, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenRune1.start()
		get_node("Layer 2 - GUI/Hero").play("walk")
		$TweenAvatar.interpolate_property(get_node("Layer 2 - GUI/Hero"), "modulate",   Color(1, 1, 1, 0), Color(1, 1, 1, 1), 24, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenAvatar.start()

func _on_TweenRune2_tween_completed(object, key):
	if object.name == "Rune_2":
		$TweenRune2.interpolate_property(get_node("Layer 2 - GUI/Rune_7"), "global_position",Vector2(100,-50), Vector2(200,700), 26, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenRune2.start()
	if object.name == "Rune_7":
		get_node("Layer 2 - GUI/Hero").play("attack")
		get_node("Layer 2 - GUI/Hero").global_position.y +=40

func _on_TweenRune3_tween_completed(object, key):
	if object.name == "Rune_3":
		$TweenRune3.interpolate_property(get_node("Layer 2 - GUI/Rune_8"), "global_position",Vector2(500,-50), Vector2(550,700), 28, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenRune3.start()

func _on_TweenRune4_tween_completed(object, key):
	if object.name == "Rune_4":
		$TweenRune4.interpolate_property(get_node("Layer 2 - GUI/Rune_9"), "global_position",Vector2(700,-50), Vector2(600,700), 26, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenRune4.start()

func _on_TweenRune5_tween_completed(object, key):
	if object.name == "Rune_5":
		$TweenRune5.interpolate_property(get_node("Layer 2 - GUI/Rune_10"), "global_position",Vector2(200,-50), Vector2(150,700), 28, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenRune5.start()

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			return get_tree().change_scene_to(load(DataManager.user_data.menu))

func _on_Music_finished():
	return get_tree().change_scene_to(load(DataManager.user_data.menu))
