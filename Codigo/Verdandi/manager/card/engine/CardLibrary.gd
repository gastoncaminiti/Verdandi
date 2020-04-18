# Adaptation from Card Game Engine https://www.braindead.bzh/page/cardengine-home
# CardLibrary class - Holds all the card loaded from the database
extends Reference

# Imports
var CardData = preload("CardData.gd")
var CardDeck = preload("CardDeck.gd")

var _cards = {}
var _decks = {}

# Loads the Library from the given file
func load_from_database(path):
	var file = File.new()
	var err = file.open(path, File.READ)
	if err == OK:
		var json = JSON.parse(file.get_as_text())
		if json.error == OK:
			_load_cards(json.result)
			_load_decks(json.result)
		else:
			printerr("Error while parsing card database: ", json.error_string)
	else:
		printerr("Error while opening card database: ", file.get_error())

# Returns all the cards as an array
func cards():
	return _cards.values()

# Returns the card with the given ID, duplicates the card by default
func card(card_id, duplicate = true):
	if !_cards.has(card_id): return null
	
	if duplicate:
		return _cards[card_id].duplicate()
	else:
		return _cards[card_id]

# Returns the number of cards in the library
func size():
	return _cards.size()

# Returns the deck with the given ID, duplicates the deck by default
func deck(deck_id, duplicate = true):
	if !_decks.has(deck_id): return null
	
	if duplicate:
		return _decks[deck_id].duplicate()
	else:
		return _decks[deck_id]

func _load_cards(raw_data):
	var cards = _extract_data(raw_data, "cards", {})
	#print(raw_data)
	for card_id in cards:
		var card = CardData.new()
		
		card.id         = card_id
		card.alignment  = _extract_data(cards[card_id], "alignment", "")
		card.invertible = _extract_data(cards[card_id], "invertible", false)
		card.image      = _extract_data(cards[card_id], "image", "")
		card.guifont    = _extract_data(cards[card_id], "guifont", "")
		card.effect     = _extract_data(cards[card_id], "effect", {})
		if(card.invertible):
			card.inverse    = _extract_data(cards[card_id], "inverse", {})
		_cards[card_id] = card

func _load_decks(raw_data):
	var decks = _extract_data(raw_data, "decks", {})
	
	for deck_id in decks:
		var deck = CardDeck.new()
		
		deck.id = deck_id
		
		var deck_data = decks[deck_id]
		for card_id in deck_data:
			var quantity = _extract_data(deck_data[card_id], "quantity", 0)
			for i in range(quantity):
				deck.append(card(card_id))
		
		_decks[deck_id] = deck

func _extract_data(dict, key, default):
	if dict.has(key):
		return dict[key]
	else:
		return default
