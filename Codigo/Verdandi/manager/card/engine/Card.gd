# CardWidget class - Renders a card
extends Node2D

var _card_data = null
var _is_ready  = false
var _is_invert = false

func _ready():
	_is_ready = true
	_update_card()


# Sets the data to use for displaying a card with this widget
func set_card_data(card_data):
	_card_data = card_data
	_update_card()
	#_card_data.connect("changed", self, "_update_card")

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
	if get_node("../../../../../").is_in_group("interface_runes"):
		get_node("../../../../../").set_rune_view(_card_data)
	if get_node("../../../../").is_in_group("interface_game"):
		get_node("../../../../").set_rune_view(_card_data, global_position)

func _on_SelectedManager_mouse_exited():
	$AnimationPlayer.play("unselected")
	if get_node("../../../../../").is_in_group("interface_runes"):
		get_node("../../../../../").hide_rune_view()
	if get_node("../../../../").is_in_group("interface_game"):
		get_node("../../../../").hide_rune_view()


func _on_SelectedManager_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index  == BUTTON_LEFT:
			if get_node("../../../../").is_in_group("interface_game"):
				get_node("../../../../").hide_rune_view()
				$AnimationPlayer.play("played")
				$SelectedManager.queue_free()
		if event.button_index  == BUTTON_RIGHT and _card_data.invertible:
				if(_is_invert):
					$AnimationPlayer.play("uninvert")
				else:
					$AnimationPlayer.play("invert")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "played":
		queue_free()
		if get_node("../../../../").is_in_group("interface_game"):
			var node = get_node("../../../../")
			node.set_rune_gui(_card_data.guifont,CardGame.index_effect, _is_invert)
			print(_card_data.alignment)
			node.update_alignament(_card_data.alignment, _is_invert)
			CardGame.index_effect+=1
			
	if anim_name == "uninvert":
		_is_invert = false
	if anim_name == "invert":
		_is_invert = true