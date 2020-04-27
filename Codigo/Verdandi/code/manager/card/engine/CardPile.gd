# CardPile class - Holds not playable cards during a game
extends "CardContainer.gd"

# Imports
var CardRng = preload("CardRNG.gd")

signal card_drawn()

var _rng = CardRng.new()

func _init():
	_rng.set_seed(CardEngine.master_rng().randomi())

# Randomizes the card order in the pile
func shuffle():
	var shuffled = []
	for card in _cards:
		shuffled.insert(_rng.randomf()*shuffled.size(), card)
	_cards = shuffled

# Draws the top card of the pile
func draw():
	if _cards.empty(): return null
	var card = _cards.pop_back()
	emit_signal("size_changed", size())
	emit_signal("card_drawn")
	return card

# Draws the given amount of cards from the top of the pile
func draw_multiple(amount):
	var cards = []
	for i in range(amount):
		if !_cards.empty():
			cards.append(_cards.pop_back())
			emit_signal("card_drawn")
	emit_signal("size_changed", size())
	return cards