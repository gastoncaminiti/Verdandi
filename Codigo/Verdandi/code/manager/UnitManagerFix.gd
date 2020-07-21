extends KinematicBody2D
#DECLARACION DE VARIABLES
export(int,"N","NE","E","SE","S","SW","W","NW") var orientation_config = 0
var AREA_SCALE = 0.7
#ESTADISTICAS DEL LA UNIDAD
export var unit_stats = {
	"life": 100,
	"attack": 25,
	"defense": 20,
	"attack_speed": 1,
	"attack_range": 1,
	"move_range": 1,
	"my_orientation": 0,
}
var next_point
#FUNCION DE PREPARACION DEL NODO
func _ready():
	connect_parent_child("ready","_status_ready")
	connect_parent_child("units_moved","_status_manager")
	
#FUNCION EN RESPUESTA A LA SEÑAL DE CAMBIO DE ESTADO
func _status_manager():
	next_point = owner.map_ref.get_next_point(global_position,orientation_config)
	#global_position = owner.map_ref.get_next_point(global_position,orientation)
#FUNCION EN RESPUESTA A LA SEÑAL DE ESTADO INICIAL EN RELACION AL PADRE
func _status_ready():
	global_position = owner.map_ref.get_center_point(global_position)
#FUNCION PROCESS A EJECUTAR EN CADA TIC DE LA FISICA
func _physics_process(delta):
	#if $AnimationTree.get("parameters/playback").get_current_node() != "IDLE_N":
	#	var d: float = global_position.distance_to(next_point)
	#	#print(d)
	#	if global_position < next_point:
	#		global_position = global_position.linear_interpolate(next_point, 20 * delta / d)
	#		return
	#	if d < 5:
	#	#print("S")
	#		$AnimationTree.get("parameters/playback").travel("IDLE_N")
	pass
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
				get_parent().selected_unit(unit_stats.life,unit_stats.attack,unit_stats.defense,unit_stats.attack_speed,global_position)
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



