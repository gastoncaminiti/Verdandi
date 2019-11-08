# Adaptation from Card Game Engine https://www.braindead.bzh/page/cardengine-home
# CardEngineManager class - Singleton keeping track of the CardEngine state
extends Node

# Imports
var CardLibrary = preload("engine/CardLibrary.gd")
var CardRng     = preload("engine/CardRNG.gd")

# The Library is created as a singleton
var _library = CardLibrary.new()

# The Master RNG is used to seed other RNG in sub system 
var _master_rng = CardRng.new()

# Intializes CardEngine
func _init():
	_library.load_from_database(CardConfig.database_path())
	print(library())

# Returns the Library singleton
func library():
	return _library

# Returns the Master RNG
func master_rng():
	return _master_rng

# Returns the path to the image with the given type and id
func card_image(img_id):
	return CardConfig.card_image(img_id)

# Returns the given value with buffs/debuffs taken into account
func final_value(card_data, value):
	if !card_data.values.has(value):
		return 0
	else:
		return CardConfig.calculate_final_value(card_data, value)

# Returns the given text with placeholders replaced with the corresponding final value
func final_text(card_data, text):
	var final_text = card_data.texts[text]
	for value in card_data.values:
		final_text = final_text.replace("$%s" % value, "%d" % final_value(card_data, value))
	return final_text

