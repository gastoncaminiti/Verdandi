extends Node2D

var runes_prosperity = null
var runes_favor = null
var runes_honor = null

func _ready():
	hide_rune_view()
	runes_prosperity = CardEngine.library().deck("deck_prosperity")
	runes_favor = CardEngine.library().deck("deck_favor")
	runes_honor = CardEngine.library().deck("deck_honor")
	for card in runes_prosperity.cards():
		var card_widget  = CardConfig.card_instance()
		var node_control = CenterContainer.new()
		card_widget.set_card_data(card)
		node_control.set_custom_minimum_size(Vector2(160,160))
		get_node("Layer 2 - GUI/MGridProsperity/Grid").add_child(node_control)
		node_control.add_child(card_widget)
	for card in runes_favor.cards():
		var card_widget  = CardConfig.card_instance()
		var node_control = CenterContainer.new()
		card_widget.set_card_data(card)
		node_control.set_custom_minimum_size(Vector2(160,160))
		get_node("Layer 2 - GUI/MGridFavor/Grid").add_child(node_control)
		node_control.add_child(card_widget)
	for card in runes_honor.cards():
		var card_widget  = CardConfig.card_instance()
		var node_control = CenterContainer.new()
		card_widget.set_card_data(card)
		node_control.set_custom_minimum_size(Vector2(160,160))
		get_node("Layer 2 - GUI/MGridHonor/Grid").add_child(node_control)
		node_control.add_child(card_widget)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_rune_view(data):
	get_node("Layer 2 - GUI/RuneDetailInterface").visible = true
	get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCRuneName/LRuneName").text = data.id
	if(data.invertible):
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCRuneStatus/LRuneStatus").text = "KEY_INVERTIBLE"
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLEContainer/LEffect").text = data.effect.text
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/LIEffect").text = data.inverse.text
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/LIEffect").visible = true
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/Label").visible = true
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCEffectDescription/LEffectDescription").text = TranslationServer.translate(data.effect.description)+" "+TranslationServer.translate("KEY_OR")+" "+TranslationServer.translate(data.inverse.description)
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/Label").text = String(data.effect.duration) +" turns"
	else:
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCRuneStatus/LRuneStatus").text = "KEY_NOINVERTIBLE"
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLEContainer/LEffect").text = data.effect.text
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/LIEffect").visible = false
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCEffectDescription/LEffectDescription").text = data.effect.description
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/Label").visible = false
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
	return get_tree().change_scene_to(load(DataManager.user_data.menu))


func _on_LinkProsperity_pressed():
	get_node("Layer 2 - GUI/MGridProsperity").visible = true
	get_node("Layer 2 - GUI/MGridFavor").visible = false
	get_node("Layer 2 - GUI/MGridHonor").visible = false


func _on_LinkFavor_pressed():
	get_node("Layer 2 - GUI/MGridProsperity").visible = false
	get_node("Layer 2 - GUI/MGridFavor").visible = true
	get_node("Layer 2 - GUI/MGridHonor").visible = false


func _on_LinkHonor_pressed():
	get_node("Layer 2 - GUI/MGridProsperity").visible = false
	get_node("Layer 2 - GUI/MGridFavor").visible = false
	get_node("Layer 2 - GUI/MGridHonor").visible = true
