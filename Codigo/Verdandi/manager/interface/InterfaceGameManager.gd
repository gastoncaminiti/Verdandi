extends Node

func _ready():
	pass

func animated_orden():
	var avatar = get_node("Layer 2 - GUI/Sidgrida/AnimatedSprite")
	avatar.play("atack")
	avatar.set_frame(0)
	
	
func set_selected_gui(l,a,d,s,p):
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCLife/NLife").set_text(String(l))
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCAttack/NAttack").set_text(String(a))
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCDefense/NDefense").set_text(String(d))
	get_node("Layer 2 - GUI/StatusInterface/BackRect/VContainer/HCSpeed/NSpeed").set_text(String(s))
	var aux_node = get_node("Layer 2 - GUI/StatusInterface")
	aux_node.global_position = p
	aux_node.global_position.y -=190
	aux_node.global_position.x -=55
	aux_node.visible = true

func set_unselected_gui():
	get_node("Layer 2 - GUI/StatusInterface").visible = false

func _on_ButtonBag_pressed():
	var bag    = get_node("Layer 2 - GUI/Bag")
	bag.play("open")
	bag.set_frame(0)
	if get_parent().is_in_group("Level"):
		get_parent().add_rune()

func draw_cards(cards):
	for card in cards:
		var card_widget  = CardConfig.card_instance()
		card_widget.set_card_data(card)
		for slot in get_node("Layer 2 - GUI/Hand").get_children(): 
			slot.add_child(card_widget)
