# DemoGame class - Contains the game logic for the demo game
extends Node

# Imports
var CardHand = preload("engine/CardHand.gd")
var CardPile = preload("engine/CardPile.gd")
var CardRng  = preload("engine/CardRNG.gd")

# Time to wait between step to account for animations
const STEP_WAIT_TIME = 2.0

#signal player_energy_changed()
signal turn_started()

# Constant values
const HAND_SIZE = 0
const HAND_LIMIT = 3

var index_effect = 0

var character = ""

var player_deck    = null
var player_hand    = CardHand.new()
var player_draw    = CardPile.new()
var player_discard = CardPile.new()

#var player_energy     = 3
var player_max_energy = 3

var _stepper = Timer.new()
var _steps = ["start_turn"]
var _current_step = 0
var _discard_rng = CardRng.new()

func _init():
	_stepper.one_shot = true
	_stepper.wait_time = STEP_WAIT_TIME
	add_child(_stepper)
	_stepper.connect("timeout", self, "_on_stepper_timeout")
	
	_discard_rng.set_seed(CardEngine.master_rng().randomi())

# Creates a new game with the given deck
func create_game(deck_id, character_name):
	character = character_name
	player_deck = CardEngine.library().deck(deck_id)
	if player_deck == null:
		printerr("Invalid deck ID while creating a game")
	
	_current_step = 0
	index_effect = 0
	
	player_hand.clear()
	player_draw.clear()
	player_discard.clear()
	
	player_draw.copy_from(player_deck)
	player_draw.shuffle()

	_stepper.start()

func draw_one_card():
	player_hand.append(player_draw.draw())
	

func draw_cards(amount):
	player_hand.append_multiple(player_draw.draw_multiple(amount))

func discard_random_card():
	var card = player_hand.discard(floor(_discard_rng.randomf()*player_hand.size()))
	player_discard.append(card)

func _step_start_turn():
	draw_cards(HAND_SIZE)
	emit_signal("turn_started")

func _on_stepper_timeout():
	var step = _steps[_current_step]
	if step == "start_turn":
		_step_start_turn()
	
	_current_step += 1
	if _current_step >= _steps.size():
		_current_step = 0

func get_player_hand_cards():
	return player_hand.cards() 