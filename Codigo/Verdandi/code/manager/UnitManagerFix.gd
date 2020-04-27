extends KinematicBody2D

var test_i = 0

func _ready():
	connect_parent_child("units_moved","_actions_manager")
	
func _actions_manager(nav):
	global_position = get_parent().map_ref.get_next_point(global_position,test_i)
	if test_i < 7:
		test_i += 1 
	else:
		test_i  = 0

# Función que permite conectar una señal de nodo padre con una función del nodo hijo.
func connect_parent_child(nsignal, nfunction):
	if get_parent().is_in_group("Level"):
		if get_parent().connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)
