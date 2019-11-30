extends Node2D

export(String) var deck_name   = "level_starter"
export(String) var player_name = "player1"
export(int)    var alignment_limit = 3

signal map_initiated
signal units_moved
signal units_affected

var prosperity = 0
var favor      = 0
var honor      = 0

# Control Variables
var size_deck  = 0

var effects = []
var papyrus = []


func _ready():
	CardGame.create_game(deck_name, player_name)
	emit_signal("map_initiated", $Navigation2D/TileMap)
	size_deck = CardGame.player_deck.size()
	$GameInterface.set_bag_num_runes(String(size_deck))
	$GameInterface.alignment_default(alignment_limit)

func battle_turn():
	emit_signal("units_moved", $Navigation2D)

func selected_unit(l,a,d,s,p):
	$GameInterface.set_selected_gui(l,a,d,s,p)

func unselected_unit():
	$GameInterface.set_unselected_gui()

func add_rune():
	if size_deck > 0:
		CardGame.draw_one_card()
		$GameInterface.draw_card(CardGame.get_player_hand_cards().back())
		size_deck -= 1
		$GameInterface.set_bag_num_runes(String(size_deck))

func alignament_control(alignament, invertible):
	match alignament:
		"prosperity":
			prosperity += -1 if invertible else  1
		"favor":
			favor += -1 if invertible else  1
		"honor":
			honor += -1 if invertible else  1 
	# Validar valores de alineamiento 
	if prosperity < 0: 
		prosperity = 0
		return
	if favor < 0: 
		favor = 0
		return
	if honor < 0: 
		honor = 0
		return
	if prosperity > alignment_limit: 
		next_level()
		return
	if favor > alignment_limit:
		next_level()
		return 
	if honor > alignment_limit: 
		next_level()
		return

func apply_effect(data , key):
	effects.append(data)
	papyrus.append({"key": key, "milestone": data.milestone[0]})
	emit_signal("units_affected", data, player_name)

func next_level():
	$GameInterface.show_next_gui()
	var aux_key = String(DataManager.user_data.progression.saga_index) + String(DataManager.user_data.progression.act_index)
	DataManager.user_data.progression.legends[aux_key] = papyrus
	DataManager.update_data()
