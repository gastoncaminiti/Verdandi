extends Node2D

export(String) var deck_name   = "level_starter"
export(String) var player_name = "player1"

signal map_initiated
signal units_moved
signal units_affected

var prosperity = 0
var favor      = 0
var honor      = 0
var size_deck  = 0

var effects = []
var papyrus = []

func _ready():
	CardGame.create_game(deck_name, player_name)
	emit_signal("map_initiated", $Navigation2D/TileMap)
	size_deck = CardGame.player_deck.size()
	$GameInterface.set_bag_num_runes(String(size_deck))

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
	
	if prosperity < 0: prosperity = 0
	if favor < 0: favor = 0
	if honor < 0: honor = 0
	
func apply_effect(data):
	effects.append(data)
	papyrus.append(data.milestone[0])
