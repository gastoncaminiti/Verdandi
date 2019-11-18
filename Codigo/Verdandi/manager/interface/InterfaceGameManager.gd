extends Node

func _ready():
	pass

func animated_orden():
	pass

func set_selected_gui(l,a,d,s,p):
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCLife/NLife").set_text(String(l))
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCAttack/NAttack").set_text(String(a))
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCDefense/NDefense").set_text(String(d))
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCSpeed/NSpeed").set_text(String(s))
	var aux_node = get_node("Layer 2 - GUI/StatusInterface")
	aux_node.global_position = p
	aux_node.global_position.y -=190
	aux_node.global_position.x -=50
	aux_node.visible = true

func set_unselected_gui():
	get_node("Layer 2 - GUI/StatusInterface").visible = false

func _on_ButtonBag_pressed():
	var bag = get_node("Layer 2 - GUI/Bag")
	bag.play("open")
	bag.set_frame(0)
	if get_parent().is_in_group("Level"):
		get_parent().add_rune()

func draw_card(card):
	var card_widget  = CardConfig.card_instance()
	card_widget.set_card_data(card)
	for slot in get_node("Layer 2 - GUI/Hand").get_children(): 
		if !slot.get_children():
			slot.add_child(card_widget)
			return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_rune_view(data, pos):
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
	get_node("Layer 2 - GUI/RuneDetailInterface").global_position.x = pos.x - 75 
	get_node("Layer 2 - GUI/RuneDetailInterface").global_position.y = pos.y - 230 
	
func hide_rune_view():
	get_node("Layer 2 - GUI/RuneDetailInterface").visible = false

func set_rune_gui(character,index, b, card_data):
	var node_effect_gui = "Layer 2 - GUI/GridEffectMy/CEffect"+String(index)+"/Effect"+String(index)
	var node_papyrus_gui = "Layer 2 - GUI/Papyrus/GridPapyrus/CChar"+String(index)+"/Char"+String(index)
	var c = character  if b else character.to_upper() 
	if(get_node(node_effect_gui)):
		get_node(node_effect_gui).text  =  c
		get_node(node_effect_gui).get_parent().hint_tooltip = card_data.inverse.description  if b else card_data.effect.description
	else:
		var effect_container = get_node("Layer 2 - GUI/GridEffectMy")
		effect_container.add_child(effect_container.get_children().back().duplicate())
		effect_container.get_children().back().set_name("CEffect"+String(index))
		effect_container.get_children().back().get_children().back().set_name("Effect"+String(index))
		get_node(node_effect_gui).text  =  c
	if(get_node(node_papyrus_gui)):
		get_node(node_papyrus_gui).text  =  c
		get_node(node_papyrus_gui).get_parent().hint_tooltip = card_data.inverse.milestone[0]  if b else card_data.effect.milestone[0]
	var avatar = get_node("Layer 2 - GUI/Sidgrida/AnimatedSprite")
	avatar.play("atack")
	avatar.set_frame(0)

func update_alignament(alignament, invert, card_data):
	if get_parent().is_in_group("Level"):
		var node_level = get_parent()
		node_level.alignament_control(alignament, invert)
		match alignament:
			"prosperity":
				var node = get_node("Layer 2 - GUI/AlignmentContainer/VCProsperity/IconContainer")
				if  node.get_child_count() < node_level.prosperity:
					node.add_child($Coin.duplicate())
				else:
					if(node.get_children()):
						node.get_children().back().queue_free()
			"favor":
				var node = get_node("Layer 2 - GUI/AlignmentContainer/VCFavor/IconContainer")
				if  node.get_child_count() < node_level.favor:
					node.add_child($Eye.duplicate())
				else:
					if(node.get_children()):
						node.get_children().back().queue_free()
			"honor":
				var node = get_node("Layer 2 - GUI/AlignmentContainer/VCHonor/IconContainer")
				if  node.get_child_count() < node_level.honor:
					node.add_child($Axe.duplicate())
				else:
					if(node.get_children()):
						node.get_children().back().queue_free()
		var effect = card_data.inverse  if invert else  card_data.effect
		node_level.apply_effect(effect)
		node_level.battle_turn()

func set_bag_num_runes(value):
 get_node("Layer 2 - GUI/Bag/LabelBag").text = value

func show_next_gui():
	var next_gui = get_node("Layer 2 - GUI/NextInterface")
	next_gui.global_position.x = 300
	next_gui.global_position.y = 320
	