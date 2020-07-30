extends KinematicBody2D
# VARIABLE CONSTANTS  
var AREA_SCALE   = 0.7
var SPEED_UNIT   = 20
var MIN_DISTANCE = 0.5
# UNIT STATISTICS VARIABLES 
export var unit_stats = {
	"life": 100,
	"attack": 25,
	"defense": 20,
	"attack_speed": 1,
	"attack_range": 1,
	"move_range": 1,
	"orientation": 0,
	"status": "IDLE"
}
# VARIABLES  
var next_point
#FUNCION DE PREPARACION DEL NODO
func _ready():
	connect_parent_child("ready","_status_ready")
	connect_parent_child("turn_started","_start_actions")
#FUNCION EN RESPUESTA A LA SEÑAL DE CAMBIO DE ESTADO
func _start_actions():
	set_next_point()
	_unit_walk_state()
#FUNCION EN RESPUESTA A LA SEÑAL DE ESTADO INICIAL EN RELACION AL PADRE
func _status_ready():
	set_position_center_to_cell()
#FUNCION PROCESS A EJECUTAR EN CADA TIC DE LA FISICA
func _physics_process(delta):
	if is_status("WALK"):
		if is_end_to_movement(delta):
			_unit_stop_state()
#FUNCTION CALL WHEN GO TO NEXT POINT
func is_end_to_movement(delta):
	var distance: float = global_position.distance_to(get_next_point())
	global_position = global_position.linear_interpolate(get_next_point(), SPEED_UNIT * delta / distance)
	return distance < MIN_DISTANCE
#FUNCTION SET NEXT POINT
func set_next_point():
	next_point = owner.map_ref.get_next_point(global_position,get_unit_stat("orientation"))
#FUNCTION GET NEXT POINT
func get_next_point():
	return next_point
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
	owner.map_ref.switch_in_compass_order(global_position,1,get_unit_stat("move_range"))
#FUNCION EN RESPUESTA A LA SEÑAL DE SALIDA DEL MOUSE SOBRE LA UNIDAD.
func _on_Control_mouse_exited():
	owner.map_ref.switch_in_compass_order(global_position,0,get_unit_stat("move_range"))
	get_parent().unselected_unit()
#FUNCION EN RESPUESTA A LA SEÑAL DE EVENTO DEL MOUSE SOBRE LA UNIDAD.
func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if owner.is_in_group("Level"):
			if event.button_index  == BUTTON_LEFT and event.pressed:
				owner.map_ref.switch_in_compass_order(global_position,2,get_unit_stat("attack_range"))
			if event.button_index  == BUTTON_RIGHT and event.pressed:
				_attack_started()
				#get_parent().selected_unit(unit_stats.life,unit_stats.attack,unit_stats.defense,unit_stats.attack_speed,global_position)
#FUNCTION CALL FOR CONECT A SIGNAL FROM PARENT TO CHILD.
func connect_parent_child(nsignal, nfunction):
	if owner != null and owner.is_in_group("Level"):
		if owner.connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)
