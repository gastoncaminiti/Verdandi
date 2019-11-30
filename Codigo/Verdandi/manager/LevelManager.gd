extends Node2D

export(String) var deck_name   = "level_starter"
export(String) var player_name = "player1"
export(String) var enemy_name  = "player2"
export(int)    var alignment_limit = 3
export(int)    var cooldown_time = 3

export(int)    var saga_index = 0
export(int)    var act_index = 0

signal map_initiated
signal units_moved
signal units_affected

var prosperity = 0
var favor      = 0
var honor      = 0

# Control Variables
var size_deck  = 0
var unit_checks  = 0
var effects = []
var papyrus = []

var all_units = []
var my_units = []
var my_enemies = []
var my_hero_dead = false
var _cooldown = Timer.new()

func _ready():
	CardGame.create_game(deck_name, player_name)
	emit_signal("map_initiated", $Navigation2D/TileMap)
	size_deck = CardGame.player_deck.size()
	$GameInterface.set_bag_num_runes(String(size_deck))
	$GameInterface.alignment_default(alignment_limit)
	DataManager.user_data.progression.saga_index = saga_index
	DataManager.user_data.progression.act_index  = act_index
	my_units   = get_tree().get_nodes_in_group(player_name)
	my_enemies = get_tree().get_nodes_in_group(enemy_name)
	all_units =  get_tree().get_nodes_in_group("unit")
	_cooldown.one_shot = true
	_cooldown.wait_time = cooldown_time
	add_child(_cooldown)
	_cooldown.connect("timeout", self, "_on_cooldown_timeout")

func battle_turn():
	unit_checks = 0
	get_tree().get_root().set_disable_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_cooldown.start()
	emit_signal("units_moved", $Navigation2D)

func selected_unit(l,a,d,s,p):
	$GameInterface.set_selected_gui(l,a,d,s,p)

func unselected_unit():
	$GameInterface.set_unselected_gui()

func add_rune():
	if size_deck > 0:
		CardGame.draw_one_card()
		$GameInterface.draw_card(CardGame.get_player_hand_cards().back())
		size_deck -= 1
		$GameInterface.set_bag_num_runes(String(size_deck))

func alignament_control(alignament, invertible):
	match alignament:
		"prosperity":
			prosperity += -1 if invertible else  1
		"favor":
			favor += -1 if invertible else  1
		"honor":
			honor += -1 if invertible else  1 
	# Validar valores de alineamiento 
	if prosperity < 0: 
		prosperity = 0
		return
	if favor < 0: 
		favor = 0
		return
	if honor < 0: 
		honor = 0
		return
	if prosperity > alignment_limit: 
		next_level(false, "KEY_LOSE_PROSPERITY")
		return
	if favor > alignment_limit:
		next_level(false,"KEY_LOSE_FAVOR")
		return 
	if honor > alignment_limit: 
		next_level(false,"KEY_LOSE_HONOR")
		return

func apply_effect(data , key):
	effects.append(data)
	papyrus.append({"key": key, "milestone": data.milestone[0]})
	emit_signal("units_affected", data, player_name)

func erase_unit(unit):
	my_units.erase(unit)

func erase_enemy(unit):
	my_enemies.erase(unit)

func next_level(status, message):
	$GameInterface.show_next_gui(status, message)

func is_all_check():
	return unit_checks >= all_units.size()

func unit_check():
	unit_checks+=1
	
func _on_cooldown_timeout():
	if is_all_check():
		print(unit_checks)
		print(my_hero_dead)
		get_tree().get_root().set_disable_input(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if my_hero_dead:
			next_level(false, "KEY_LOSE_ENEMY")
			return
		if my_enemies.size() == 0:
			next_level(true, "KEY_WIN_HERO")
			var aux_key = String(DataManager.user_data.progression.saga_index) + String(DataManager.user_data.progression.act_index)
			DataManager.user_data.progression.legends[aux_key] = papyrus
			DataManager.update_data()
			return
		if CardGame.get_player_hand_cards().size() == 0 and size_deck == 0:
			next_level(false, "KEY_LOSE_TABLE")
			return
	else:
		_cooldown.start()

