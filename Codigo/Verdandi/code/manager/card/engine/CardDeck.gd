# Adaptation from Card Game Engine https://www.braindead.bzh/page/cardengine-home

extends "CardContainer.gd"

var id = ""

func get_id():
	return id

# Creates a copy of the deck, necessary if you don't want to modify the original deck
func duplicate():
	var copy = get_script().new()
	copy.id = id
	copy._cards = duplicate_cards()
	return copy
