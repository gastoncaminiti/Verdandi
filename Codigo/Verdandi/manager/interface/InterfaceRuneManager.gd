extends Node2D

var runes = null

func _ready():
	hide_rune_view()
	runes = CardEngine.library()
	for card in runes.cards():
		var card_widget  = CardConfig.card_instance()
		var node_control = CenterContainer.new()
		card_widget.set_card_data(card)
		node_control.set_custom_minimum_size(Vector2(160,160))
		get_node("Layer 2 - GUI/MGrid/Grid").add_child(node_control)
		node_control.add_child(card_widget)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_rune_view(data):
	get_node("Layer 2 - GUI/RuneDetailInterface").visible = true
	get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCRuneName/LRuneName").text = data.id
	if(data.invertible):
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCRuneStatus/LRuneStatus").text = "KEY_INVERTIBLE"
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/LEffect").text = data.effect.text
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/LIEffect").text = data.inverse.text
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/LIEffect").visible = true
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCEffectDescription/LEffectDescription").text = TranslationServer.translate(data.effect.description)+" "+TranslationServer.translate("KEY_OR")+" "+TranslationServer.translate(data.inverse.description)
	else:
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCRuneStatus/LRuneStatus").text = "KEY_NOINVERTIBLE"
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/LEffect").text = data.effect.text
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/LIEffect").visible = false
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCEffectDescription/LEffectDescription").text = data.effect.description
	
	match data.alignment:
		"prosperity":
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/MCAlignment/Axe").visible = false
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/MCAlignment/Eye").visible = false
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/MCAlignment/Coin").visible = true
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/LAlignment").text = "KEY_PROSPERITY"
		"favor":
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/MCAlignment/Axe").visible = false
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/MCAlignment/Eye").visible = true
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/MCAlignment/Coin").visible = false
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/LAlignment").text = "KEY_FAVOR"
		"honor":
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/MCAlignment/Axe").visible = true
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/MCAlignment/Eye").visible = false
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/MCAlignment/Coin").visible = false
			get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCAlignment/LAlignment").text = "KEY_HONOR"
	
func hide_rune_view():
	get_node("Layer 2 - GUI/RuneDetailInterface").visible = false

func _on_Exit_pressed():
	return get_tree().change_scene_to(load(ProjectSettings.get_setting("application/run/main_scene")))
