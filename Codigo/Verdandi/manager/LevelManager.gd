extends Node2D

export(String) var deck_name   = "level_starter"
export(String) var player_name = "level0"

signal map_initiated
signal units_moved

var prosperity = 0
var favor      = 0
var honor      = 0


func _ready():
	CardGame.create_game(deck_name, player_name)
	emit_signal("map_initiated", $Navigation2D/TileMap)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("units_moved", $Navigation2D)
			$Line2D.points = get_node("Norse-Swordman").get_path()
			$Line2D.show()

func selected_unit(l,a,d,s,p):
	$GameInterface.set_selected_gui(l,a,d,s,p)

func unselected_unit():
	$GameInterface.set_unselected_gui()

func add_rune():
	CardGame.draw_one_card()
	$GameInterface.draw_card(CardGame.get_player_hand_cards().back())

func alignament_control(alignament, invertible):
	match alignament:
		"prosperity":
			prosperity += -1 if invertible else  1
		"favor":
			favor += -1 if invertible else  1
		"honor":
			honor += -1 if invertible else  1 
	
	if prosperity < 0: prosperity = 0
	if favor < 0: favor = 0
	if honor < 0: honor = 0
