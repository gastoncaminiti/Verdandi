extends Node2D

var runes = null
func _ready():
	runes = CardEngine.library()
	for card in runes.cards():
		var card_widget  = CardConfig.card_instance()
		var node_control = CenterContainer.new()
		card_widget.set_card_data(card)
		node_control.set_custom_minimum_size(Vector2(160,160))
		get_node("Layer 2 - GUI/MGrid/Grid").add_child(node_control)
		node_control.add_child(card_widget)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
