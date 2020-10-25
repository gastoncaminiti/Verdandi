extends KinematicBody2D
# VARIABLE CONSTANTS  
var AREA_SCALE   = 0.7
var SPEED_UNIT   = 20
var MIN_DISTANCE = 0.5
# UNIT STATISTICS VARIABLES 
export var unit_stats = {
	"name": "Sigurd",
	"life": 100,
	"attack": 25,
	"defense": 20,
	"attack_speed": 1,
	"attack_range": 1,
	"move_range": 1,
	"orientation": 0,
	"status": "IDLE"
}
#VARIABLES  
var next_point
var flag_turn setget set_turn_status, get_turn_status
var my_astar_path = PoolVector2Array()
#FUNCION DE PREPARACION DEL NODO
func _ready():
	connect_parent_child("ready","_status_ready")
	connect_parent_child("turn_started","_start_actions")
	set_turn_status(false)
#FUNCION EN RESPUESTA A LA SEÑAL DE CAMBIO DE ESTADO
func _start_actions():
	set_turn_status(true)
	_unit_walk_state()
#FUNCION EN RESPUESTA A LA SEÑAL DE ESTADO INICIAL EN RELACION AL PADRE
func _status_ready():
	set_position_center_to_cell()
	set_next_point()
#FUNCION PROCESS A EJECUTAR EN CADA TIC DE LA FISICA
func _physics_process(delta):
	if is_status("WALK"):
		if is_end_to_movement(delta):
			_unit_stop_state()
#FUNCTION CALL WHEN GO TO NEXT POINT
func is_end_to_movement(delta):
	var distance: float = global_position.distance_to(my_astar_path[my_astar_path.size()- 1])
	global_position = global_position.linear_interpolate(my_astar_path[my_astar_path.size()- 1], SPEED_UNIT * delta / distance)
	return distance < MIN_DISTANCE
#FUNCTION SET NEXT POINT
func set_next_point():
	next_point = owner.map_ref.get_next_point(global_position,get_unit_stat("orientation"))
	# A* test
	my_astar_path = owner.gui_map_ref.get_astar_path(global_position,next_point)
	#print(owner.gui_map_ref.path_computed(my_astar_path))
	set_unit_stat("orientation",int(owner.gui_map_ref.in_compass(owner.gui_map_ref.path_computed(my_astar_path))))
	#print(get_unit_stat("orientation"))
	#print(my_astar_path)
#FUNCTION GET NEXT POINT
func get_next_point():
	return next_point
#FUNCTION SET FLAG TURN
func set_turn_status(new_status):
	flag_turn = new_status
#FUNCTION GET FLAG TURN
func get_turn_status():
	return flag_turn
#FUNCTION GET POSITION CENTER
func set_position_center_to_cell():
	global_position = owner.map_ref.get_center_point(global_position)
#FUNCTION SET UNIT STATISTICS.
func set_unit_stat(key_stat, value_stat):
	unit_stats[key_stat] = value_stat
#FUNCTION GET UNIT STATISTICS.
func get_unit_stat(key_stat):
	return unit_stats[key_stat] 
#FUNCTION CHECK UNIT STATUS
func is_status(status):
	return get_unit_stat("status") ==  status
#FUNCTION CALL WHEN ATTACK IS STARTED.
func _attack_started():
	if is_status("IDLE"):
		_unit_attack_state()
#FUNCTION CALL WHEN ATTACK IS FINISHED.
func _attack_finished():
	if is_status("ATTACK"):
		_unit_guard_state()
#FUNCTION CALL WHEN WALK STATUS IS NEED.
func _unit_walk_state():
	set_unit_stat("status","WALK")
	$FSM.update_walk_choise()
#FUNCTION CALL WHEN STOP STATUS IS NEED.
func _unit_stop_state():
	set_unit_stat("status","IDLE")
	$FSM.update_walk_choise()
	set_next_point()
	$FSM.update_idle_choises()
	$FSM.update_brain_choises()
	set_turn_status(false)
#FUNCTION CALL WHEN ATTACK STATUS IS NEED.
func _unit_attack_state():
	set_unit_stat("status","ATTACK")
	$FSM.update_attack_choise()
#FUNCTION CALL WHEN GUARD STATUS IS NEED.
func _unit_guard_state():
	set_unit_stat("status","IDLE")
	$FSM.update_attack_choise()
#FUNCION EN RESPUESTA A LA SEÑAL DE ENTRADA DEL MOUSE SOBRE LA UNIDAD.
func _on_Control_mouse_entered():
	if !get_turn_status():
		owner.gui_map_ref.set_selected_path(my_astar_path,2)
		get_parent().selected_unit(unit_stats)
#FUNCION EN RESPUESTA A LA SEÑAL DE SALIDA DEL MOUSE SOBRE LA UNIDAD.
func _on_Control_mouse_exited():
	owner.gui_map_ref.hide_select_map()
	get_parent().unselected_unit()
#FUNCION EN RESPUESTA A LA SEÑAL DE EVENTO DEL MOUSE SOBRE LA UNIDAD.
func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if owner.is_in_group("Level"):
			if event.button_index  == BUTTON_LEFT and event.pressed  and !get_turn_status():
				owner.gui_map_ref.show_selected_grid(global_position,5,2,0)
			if event.button_index  == BUTTON_RIGHT and event.pressed and !get_turn_status():
				#_attack_started()
				owner.gui_map_ref.show_selected_grid(global_position,3,1,1)
#FUNCTION CALL FOR CONECT A SIGNAL FROM PARENT TO CHILD.
func connect_parent_child(nsignal, nfunction):
	if owner != null and owner.is_in_group("Level"):
		if owner.connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)
