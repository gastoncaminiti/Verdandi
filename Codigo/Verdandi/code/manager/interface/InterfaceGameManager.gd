extends Node

var flag_hourglass = false
var hourglass

func _ready():
	hourglass = get_node("Layer 2 - GUI/Hourglass")
	disable_battlebutton(true)
	
func animated_orden():
	pass

func _process(delta):
	if flag_hourglass:
		hourglass.play("tic-tac")
		hourglass.global_position = get_viewport().get_mouse_position()

func disiable_hourglass():
	flag_hourglass = false
	hourglass.global_position = Vector2(1200,400)

func set_selected_gui(l,a,d,s,p):
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCLife/NLife").set_text(String(l))
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCAttack/NAttack").set_text(String(a))
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCDefense/NDefense").set_text(String(d))
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCSpeed/NSpeed").set_text(String(s))
	var aux_node = get_node("Layer 2 - GUI/StatusInterface")
	aux_node.global_position = p
	aux_node.global_position.y -=100
	aux_node.global_position.x -=50
	aux_node.visible = true

func set_unselected_gui():
	get_node("Layer 2 - GUI/StatusInterface").visible = false

func _on_ButtonBag_pressed():
	if(CardGame.get_player_hand_cards().size() < CardGame.HAND_LIMIT):
		get_node("Layer 2 - GUI/Sidgrida").hide_tip()
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
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLEContainer/LEffect").text = data.effect.text
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLEContainer/Label").text = String(data.effect.duration) +" turns"
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/LIEffect").text = data.inverse.text
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/LIEffect").visible = true
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/Label").visible = true
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCEffectDescription/LEffectDescription").text = TranslationServer.translate(data.effect.description)+" "+TranslationServer.translate("KEY_OR")+" "+TranslationServer.translate(data.inverse.description)
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/Label").text = String(data.inverse.duration) +" turns"
	else:
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/CCRuneStatus/LRuneStatus").text = "KEY_NOINVERTIBLE"
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLEContainer/LEffect").text = data.effect.text
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLEContainer/Label").text = String(data.effect.duration) +" turns"
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/LIEffect").visible = false
		get_node("Layer 2 - GUI/RuneDetailInterface/BackRect/VContainer/HCEffect/VLIEContainer/Label").visible = false
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
	get_node("Layer 2 - GUI/RuneDetailInterface").global_position.y = pos.y - 235 
	
func hide_rune_view():
	get_node("Layer 2 - GUI/RuneDetailInterface").visible = false

func update_turn_gui_one_effect(i,t):
	get_node("Layer 2 - GUI/GridEffectMy").get_child(i).get_child(1).text = t

func set_rune_gui(character,index, b, card_data):
	var avatar = get_node("Layer 2 - GUI/Sidgrida/AnimatedSprite")
	avatar.play("atack")
	avatar.set_frame(0)
	var c = character  if b else character.to_upper() 
	#var node_effect_gui = "Layer 2 - GUI/GridEffectMy/CEffect"+String(index)+"/Effect"+String(index)
	var node_papyrus_gui = "Layer 2 - GUI/Papyrus/GridPapyrus/CChar"+String(index)+"/Char"+String(index)
	if(get_node(node_papyrus_gui)):
		get_node(node_papyrus_gui).text  =  c
		get_node(node_papyrus_gui).get_parent().hint_tooltip = card_data.inverse.milestone[0]  if b else card_data.effect.milestone[0]
	if b:
		var aux_inverse = $CEInverse.duplicate()
		aux_inverse.get_child(0).text = c
		aux_inverse.get_child(1).text =  String(card_data.inverse.duration)
		aux_inverse.hint_tooltip = card_data.inverse.description
		get_node("Layer 2 - GUI/GridEffectMy").add_child(aux_inverse)
		$Tween.interpolate_property(aux_inverse, "modulate",   Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	else:
		var aux_effect  = $CEffect.duplicate()
		aux_effect.get_child(0).text = c
		aux_effect.get_child(1).text = String(card_data.effect.duration)
		aux_effect.hint_tooltip = card_data.effect.description
		get_node("Layer 2 - GUI/GridEffectMy").add_child(aux_effect)
		$Tween.interpolate_property(aux_effect, "modulate",   Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()

func erase_effect_gui(k):
	for e in get_node("Layer 2 - GUI/GridEffectMy").get_children():
		if e.get_child(0).text == k:
			$TweenEnd.interpolate_property(e, "modulate",   Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$TweenEnd.start()
			return

func update_alignament(alignament, invert, card_data):
	if get_parent().is_in_group("Level"):
		var node_level = get_parent()
		if node_level.alignament_control(alignament, invert):
			var c  = Color(1,1,1,1)
			var c2 = Color(0,0,0,0.8)
			match alignament:
				"prosperity":
					var node = get_node("Layer 2 - GUI/AlignmentContainer/VCProsperity/IconContainer")
					if node_level.prosperity > 0: 
						if(invert):
							if(node_level.prosperity - 2 > 0):
								node.get_children()[node_level.prosperity - 2].modulate = c2
							else:
								node.get_children()[0].modulate = c2
						else:
							node.get_children()[node_level.prosperity - 1].modulate = c
					else:
						node.get_children()[0].modulate = c2
				"favor":
					var node = get_node("Layer 2 - GUI/AlignmentContainer/VCFavor/IconContainer")
					if node_level.favor > 0: 
						if(invert):
							print(invert)
							if(node_level.favor - 2 > 0):
								print("NO")
								node.get_children()[node_level.favor - 2].modulate = c2
							else:
								print("ACA")
								node.get_children()[0].modulate = c2
						else:
							node.get_children()[node_level.favor - 1].modulate = c
					else:
						node.get_children()[0].modulate = c2
				"honor":
					var node = get_node("Layer 2 - GUI/AlignmentContainer/VCHonor/IconContainer")
					if node_level.honor > 0: 
						if(invert):
							if(node_level.honor - 2 > 0):
								node.get_children()[node_level.honor - 2].modulate = c2
							else:
								node.get_children()[0].honor = c2
						else:
							node.get_children()[node_level.honor - 1].modulate = c
					else:
						node.get_children()[0].modulate = c2
			var effect = card_data.inverse  if invert else  card_data.effect
			node_level.apply_effect(effect, card_data.guifont if invert else card_data.guifont.to_upper())
			disable_battlebutton(false)

func set_bag_num_runes(value):
 get_node("Layer 2 - GUI/Bag/LabelBag").text = value

func show_next_gui(status, message):
	var next_gui = get_node("Layer 2 - GUI/NextInterface").update_next_inteface(status,message,300,320)

func alignment_default(limit):
	var c = Color(0,0,0,0.8)
	for i in range(limit):
		var aux_coin = $Coin.duplicate()
		var aux_eye  = $Eye.duplicate()
		var aux_axe  = $Axe.duplicate()
		aux_coin.modulate = c
		aux_eye.modulate  = c
		aux_axe.modulate  = c
		get_node("Layer 2 - GUI/AlignmentContainer/VCProsperity/IconContainer").add_child(aux_coin)
		get_node("Layer 2 - GUI/AlignmentContainer/VCFavor/IconContainer").add_child(aux_eye)
		get_node("Layer 2 - GUI/AlignmentContainer/VCHonor/IconContainer").add_child(aux_axe)
	

func _on_TweenEnd_tween_completed(object, key):
	object.queue_free()

func decrement_my_turn_gui():
	for gui_effect in get_node("Layer 2 - GUI/GridEffectMy").get_children():
		#var aux = gui_effect.get_child(1).text
		#print(aux)
		gui_effect.get_child(1).text = String( int(gui_effect.get_child(1).text) - 1)


func _on_BattleButton_pressed():
	get_parent().battle_turn()
	
func disable_battlebutton(flag):
	var button = get_node("Layer 2 - GUI/BattleButton")
	button.set_disabled(flag)
	button.set_pressed(false)
	
func show_tip():
	get_node("Layer 2 - GUI/Sidgrida").tip_manager()
