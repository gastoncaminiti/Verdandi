extends Node

var custom_rune = preload("res://game/decks/norse/Rune.tscn")

# Returns the path to the file containing the card database
func database_path():
	return "res://data/cards.json"

# Returns the path to the image with the given type and id
func card_image(img_id):
	return "res://game/decks/norse/img/Rune_"+img_id+".png"

# Returns an instance of the custom card design
func card_instance():
	return custom_rune.instance()

func card_icon(img_id):
	return "res://interfaces/norse/img/Runes/Icon/RuneI_"+img_id+".png"

func card_font(img_id):
	return "res://interfaces/norse/img/Runes/Font/RuneF_"+img_id+".png"
