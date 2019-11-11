# CardWidget class - Renders a card
extends Node2D

var _card_data = null
var _is_ready = false

func _ready():
	_is_ready = true
	_update_card()


# Sets the data to use for displaying a card with this widget
func set_card_data(card_data):
	_card_data = card_data
	_update_card()
	_card_data.connect("changed", self, "_update_card")

# Returns the date used by this widget
func get_card_data():
	return _card_data

func _update_card():
	if _card_data == null || !_is_ready: return
	$Sprite.set_texture(load(CardEngine.card_image(_card_data.image)))
	# Images update
	#var node = find_node(FORMAT_IMAGE % image)
	#if node != null:
	#	node.texture = load(CardEngine.card_image(_card_data.image))
	
	# Value update
	#for value in _card_data.values:
	#	var node = find_node(FORMAT_LABEL % value)
	#	if node != null:
	#		node.text = "%d" % CardEngine.final_value(_card_data, value)
	
	# Text update
	#for text in _card_data.texts:
	#	var node = find_node(FORMAT_LABEL % text)
	#	if node != null:
	#		if node is RichTextLabel:
	#		node.bbcode_text = CardEngine.final_text(_card_data, text)
	#		else:
	#			node.text = CardEngine.final_text(_card_data, text)

func _on_SelectedManager_mouse_entered():
	$AnimationPlayer.play("selected")
	get_node("../../../../../").set_rune_view(_card_data)

func _on_SelectedManager_mouse_exited():
	$AnimationPlayer.play("unselected")
	get_node("../../../../../").hide_rune_view()
