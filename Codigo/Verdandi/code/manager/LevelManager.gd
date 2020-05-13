extends Node2D
# ------------------ LEVELMANAGER SCRIPT ------------------
# Script manejador de los eventos del nivel.
# Configrable VAR.
export(String) var deck_name   = "level_starter"
export(String) var player_name = "player1"
export(String) var enemy_name  = "player2"
export(int)    var alignment_limit = 3
export(int)    var cooldown_time = 3
export(int)    var saga_index = 0
export(int)    var act_index = 0
# Signals
signal map_initiated
signal units_moved
signal units_affected
# Control VAR
var prosperity = 0
var favor      = 0
var honor      = 0
var size_deck  = 0
var unit_checks  = 0
var my_hero_dead = false
var turn_index = 0
# Containers VAR
var effects = []
var papyrus = []
var all_units = []
var my_units = []
var my_enemies = []

#MAPA REFERENCIA
var map_ref
# Timer VAR
var _cooldown = Timer.new()

# Función: Configuración de variables iniciales.
func _ready():
	CardGame.create_game(deck_name, player_name)
	#emit_signal("map_initiated", $Navigation2D/TileMap)
	size_deck = CardGame.player_deck.size()
	# Configuración inicial de interfaz de juego.
	$GameInterface.set_bag_num_runes(String(size_deck))
	$GameInterface.alignment_default(alignment_limit)
	# Configuración inicial de indices de nivel.
	DataManager.user_data.progression.saga_index = saga_index
	DataManager.user_data.progression.act_index  = act_index
	# Carga inicial de contenedores.
	my_units   = get_tree().get_nodes_in_group(player_name)
	my_enemies = get_tree().get_nodes_in_group(enemy_name)
	all_units =  get_tree().get_nodes_in_group("unit")
	# Configuración de timer.
	_cooldown.one_shot = true
	_cooldown.wait_time = cooldown_time
	add_child(_cooldown)
	_cooldown.connect("timeout", self, "_on_cooldown_timeout")
	# Light Config
	set_global_light_status(false)
	map_ref = $Navigation2D/Map

func _input(event):
	#TEST MOVOMIMIENTO DE UNIDADES
	if Input.is_key_pressed(KEY_SPACE):
		emit_signal("units_moved")

# Función: Definición de eventos durante el combate.
func battle_turn():
	unit_checks = 0
	#aca antes llamaba a update_effects_status() (VER BIEN DONDE SE CALCULAN LOS EFECTOS DE TURNOS)
	# Desactivar input y ocultar cursor.
	get_tree().get_root().set_disable_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$GameInterface.flag_hourglass = true
	# Iniciar reloj y señal de movimiento a unidades.
	turn_index +=1
	_cooldown.start()
	#emit_signal("units_moved", $Navigation2D)
	emit_signal("units_moved")

# Función: Actualizar interfaz de unidad seleccionada.
func selected_unit(l,a,d,s,p):
	$GameInterface.set_selected_gui(l,a,d,s,p)

# Función: Ocultar interfaz de unidad seleccionada.
func unselected_unit():
	$GameInterface.set_unselected_gui()

# Función: Agregar una runa a la mesa de destino y actulizar el indicador de interfaz.
func add_rune():
	if size_deck > 0:
		size_deck -= 1
		CardGame.draw_one_card()
		$GameInterface.draw_card(CardGame.get_player_hand_cards().back())
		$GameInterface.set_bag_num_runes(String(size_deck))

# Función: Control de estado de alineación a razón de la runa jugada.
func alignament_control(alignament, invertible):
	# Determinar valores de alineación
	match alignament:
		"prosperity":
			prosperity += -1 if invertible else  1
		"favor":
			favor += -1 if invertible else  1
		"honor":
			honor += -1 if invertible else  1  
	if prosperity < 0: 
		prosperity = 0
		return true
	if favor < 0: 
		favor = 0
		return true
	if honor < 0: 
		honor = 0
		return true
	# Verificación de estado de partida a razón de la alineación.
	if prosperity > alignment_limit: 
		next_level(false, "KEY_LOSE_PROSPERITY")
		return false
	if favor > alignment_limit:
		next_level(false,"KEY_LOSE_FAVOR")
		return false
	if honor > alignment_limit: 
		next_level(false,"KEY_LOSE_HONOR")
		return false
	return true
# Función: Aplicar efectos de runa jugada al nivel.
func apply_effect(data , key):
	effects.append({"key": key,"order": CardGame.index_effect, "effect": data , "turns":data.duration})
	papyrus.append({"key": key, "milestone": data.milestone[0]})
	match data.key:
		"resilience":
			for i in range(effects.size()):
				if effects[i].effect.type == "spell":
					if !effects[i].effect.value:
						effects[i].turns = 0
						$GameInterface.update_turn_gui_one_effect(i,String(effects[i].turns))
						return
				if effects[i].effect.type == "statistics":
					if int(effects[i].effect.value) < 0:
						effects[i].turns = 0
						$GameInterface.update_turn_gui_one_effect(i,String(effects[i].turns))
						return
		"strategy":
			if effects[0]:
				effects[0].turns += 1
				$GameInterface.update_turn_gui_one_effect(0,String(effects[0].turns))
		"imprudence":
			if effects[0]:
				effects[0].turns -= 1
				$GameInterface.update_turn_gui_one_effect(0,String(effects[0].turns))
		"provisions":
			emit_signal("units_affected", data, player_name)
		_:
			# Efecto de Estadisticas de unidades.
			emit_signal("units_affected", data, player_name)

func erase_unit(unit):
	my_units.erase(unit)

func erase_enemy(unit):
	my_enemies.erase(unit)
	
func erase_all(unit):
	all_units.erase(unit)

func next_level(status, message):
	$GameInterface.show_next_gui(status, message)

func is_all_check():
	return unit_checks >= all_units.size()

func unit_check():
	unit_checks+=1
	
func _on_cooldown_timeout():
	if is_all_check():
		$GameInterface.disiable_hourglass()
		get_tree().get_root().set_disable_input(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pass_turn_effects()
		update_effects_status()
		$GameInterface.decrement_my_turn_gui()
		$GameInterface.disable_battlebutton(true)
		$GameInterface.show_tip()
		if my_hero_dead:
			next_level(false, "KEY_LOSE_ENEMY")
			return
		if my_enemies.size() == 0:
			next_level(true, "KEY_WIN_HERO")
			var aux_key = String(DataManager.user_data.progression.saga_index) + String(DataManager.user_data.progression.act_index)
			DataManager.user_data.progression.legends[aux_key] = papyrus
			DataManager.save_user_data_encrypted()
			return
		if CardGame.get_player_hand_cards().size() == 0 and size_deck == 0:
			next_level(false, "KEY_LOSE_TABLE")
			return
	else:
		_cooldown.start()

func pass_turn_effects():
	for e in effects:
		e.turns -=1

func update_effects_status():
	for e in effects:
		if(e.turns < 1):
			$GameInterface.erase_effect_gui(e.key)
			reverse_card_effect(e)
			effects.erase(e)
		else:
			if e.effect.has("cast"):
				match e.effect.cast:
					"provisions":
						emit_signal("units_affected", e.effect, player_name)

func reverse_card_effect(data):
	if(data.effect.type == "statistics"):
		data.effect.value = int(data.effect.value) * -1
		emit_signal("units_affected", data.effect, player_name)
		return
	if(data.effect.type == "spell"):
		data.effect.value = !data.effect.value
		emit_signal("units_affected", data.effect, player_name)
		return

func set_global_light_status(status):
	$BlackLight.enabled = status
	
