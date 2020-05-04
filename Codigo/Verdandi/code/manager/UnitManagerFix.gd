extends KinematicBody2D
#DECLARACION DE VARIABLES
export(int,"N","NE","E","SE","S","SW","W","NW") var orientation = 0
#FUNCION DE PREPARACION DEL NODO
func _ready():
	connect_parent_child("units_moved","_actions_manager")
#FUNCION QUE CONECTA UNA SEÑAL DEL NODO PADRE A UNA FUNCION DEL NODO HIJO
func _actions_manager():
	global_position = get_parent().map_ref.get_next_point(global_position,orientation)
#FUNCION QUE CONECTA UNA SEÑAL DEL NODO PADRE A UNA FUNCION DEL NODO HIJO
func connect_parent_child(nsignal, nfunction):
	if owner.is_in_group("Level"):
		if owner.connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)

func _on_Level0T2_ready():
	global_position = get_parent().map_ref.get_center_point(global_position)
