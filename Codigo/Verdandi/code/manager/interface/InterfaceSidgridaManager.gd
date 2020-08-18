extends Node2D

export(bool) var show_tips  = false
var tip

func _ready():
	$AnimatedSprite.set_sprite_frames(load(DataManager.user_data.skin))
	tip_manager()

func _on_SelectedManager_mouse_entered():
	tip_manager()

func _on_SelectedManager_mouse_exited():
	if show_tips:
		owner.hide_subtitle()
	$AnimatedSprite.play("default")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "atack":
		$AnimatedSprite.play("default")

func tip_manager():
	tip = "KEY_TUTORIAL_"+String(DataManager.user_data.progression.saga_index) + String(DataManager.user_data.progression.act_index) +"_"+ String(CardGame.index_effect)
	if show_tips and tip != TranslationServer.translate(tip):
		$AnimatedSprite.play("speak")
		owner.set_subtitle(tip)
		owner.show_subtitle()
	else:
		$AnimatedSprite.play("idle")
