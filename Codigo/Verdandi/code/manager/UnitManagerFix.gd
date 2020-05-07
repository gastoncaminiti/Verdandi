extends KinematicBody2D
#DECLARACION DE VARIABLES
export(int,"N","NE","E","SE","S","SW","W","NW") var orientation = 0
#FUNCION DE PREPARACION DEL NODO
func _ready():
	connect_parent_child("ready","_status_ready")
	connect_parent_child("units_moved","_status_manager")
	pass
#FUNCION EN RESPUESTA A LA SEÑAL DE CAMBIO DE ESTADO
func _status_manager():
	global_position = owner.map_ref.get_next_point(global_position,orientation)
#FUNCION EN RESPUESTA A LA SEÑAL DE ESTADO INICIAL EN RELACION AL PADRE
func _status_ready():
	global_position = owner.map_ref.get_center_point(global_position)
#FUNCION EN RESPUESTA A LA SEÑAL DE ENTRADA DEL MOUSE SOBRE LA UNIDAD.
func _on_Control_mouse_entered():
	owner.map_ref.switch_in_compass_move(global_position)
#FUNCION EN RESPUESTA A LA SEÑAL DE SALIDA DEL MOUSE SOBRE LA UNIDAD.
func _on_Control_mouse_exited():
	owner.map_ref.switch_in_compass_origin(global_position)
func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if owner.is_in_group("Level"):
			if event.button_index  == BUTTON_LEFT and event.pressed:
				owner.map_ref.switch_in_compass_battle(global_position)
			if event.button_index  == BUTTON_RIGHT and event.pressed:
				pass
#FUNCION QUE CONECTA UNA SEÑAL DEL NODO PADRE A UNA FUNCION DEL NODO HIJO
func connect_parent_child(nsignal, nfunction):
	if owner != null and owner.is_in_group("Level"):
		if owner.connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)



