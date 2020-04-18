extends Node

var custom_rune = preload("res://deck/norse/Rune.tscn")

# Returns the path to the file containing the card database
func database_path():
	return "res://data/cards.json"

# Returns the path to the image with the given type and id
func card_image(img_id):
	return "res://deck/norse/img/Rune_"+img_id+".png"

# Returns an instance of the custom card design
func card_instance():
	return custom_rune.instance()
