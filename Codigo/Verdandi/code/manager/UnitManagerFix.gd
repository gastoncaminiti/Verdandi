extends KinematicBody2D
#DECLARACION DE VARIABLES
export(int,"N","NE","E","SE","S","SW","W","NW") var orientation = 0
var AREA_SCALE = 0.7
#ESTADISTICAS DEL LA UNIDAD
export var unit_stats = {
	"life": 100,
	"atack": 25,
	"attack_speed": 1,
	"attack_range": 1,
	"defense": 20,
	"cell_range": 1,
}
#FUNCION DE PREPARACION DEL NODO
func _ready():
	connect_parent_child("ready","_status_ready")
	connect_parent_child("units_moved","_status_manager")
	
	
#FUNCION EN RESPUESTA A LA SEÑAL DE CAMBIO DE ESTADO
func _status_manager():
	global_position = owner.map_ref.get_next_point(global_position,orientation)
#FUNCION EN RESPUESTA A LA SEÑAL DE ESTADO INICIAL EN RELACION AL PADRE
func _status_ready():
	global_position = owner.map_ref.get_center_point(global_position)
#FUNCION EN RESPUESTA A LA SEÑAL DE ENTRADA DEL MOUSE SOBRE LA UNIDAD.
func _on_Control_mouse_entered():
	owner.map_ref.switch_in_compass_order(global_position,1,get_unit_stat("cell_range"))
#FUNCION EN RESPUESTA A LA SEÑAL DE SALIDA DEL MOUSE SOBRE LA UNIDAD.
func _on_Control_mouse_exited():
	owner.map_ref.switch_in_compass_order(global_position,0,get_unit_stat("cell_range"))
#FUNCION EN RESPUESTA A LA SEÑAL DE EVENTO DEL MOUSE SOBRE LA UNIDAD.
func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if owner.is_in_group("Level"):
			if event.button_index  == BUTTON_LEFT and event.pressed:
				owner.map_ref.switch_in_compass_order(global_position,2,get_unit_stat("attack_range"))
			if event.button_index  == BUTTON_RIGHT and event.pressed:
				pass
#FUNCION SET ESTADISTICA DE UNIDAD.
func set_unit_stat(key_stat, value_stat):
	unit_stats[key_stat] = value_stat
#FUNCION GET ESTADISTICA DE UNIDAD.
func get_unit_stat(key_stat):
	return unit_stats[key_stat] 
#FUNCION QUE CONECTA UNA SEÑAL DEL NODO PADRE A UNA FUNCION DEL NODO HIJO
func connect_parent_child(nsignal, nfunction):
	if owner != null and owner.is_in_group("Level"):
		if owner.connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)



