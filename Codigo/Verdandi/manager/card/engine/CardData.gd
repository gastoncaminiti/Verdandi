extends Reference

var id         = ""    # Identifies the card, unique in the library
var alignment  = ""    # Specifies the card's category
var invertible = false # Specifies the card's type
var image      = ""
var effect    = {} # Lists the different image used to represent this card
var inverse   = {} # Lists the different numerical values for this card

# Gameplay data
var player = null # Specifies to which player the card belongs
var origin = null # Specifies from where the card comes (Pile, Hand, ...)

func duplicate():
	var copy = get_script().new()
	
	copy.id         = id
	copy.alignment  = alignment
	copy.invertible = invertible
	copy.image      = image
	copy.effect     = effect.duplicate()
	copy.inverse    = inverse.duplicate()

	return copy
	
func get_player():
	return player

func get_origin():
	return origin
