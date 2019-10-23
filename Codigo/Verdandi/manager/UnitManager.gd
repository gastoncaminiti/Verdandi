extends KinematicBody2D

# Editable VAR
export(int) var move_range = 62
export(int, "North", "South","West","East") var orientation = 0
# Private VAR


func _ready():
	connect_parent_child("units_centered","_goGridCenter")
	# Configure Coordinate View
	$North.position.y -= move_range 
	$South.position.y += move_range
	$West.position.x  -= move_range
	$East.position.x  += move_range
	match orientation:
		0:
			set_animated("idle_north")
		1:
			set_animated("idle_south")
		2:
			$AnimatedSprite.flip_h = true
			set_animated("idle_side")
		3:
			$AnimatedSprite.flip_h = false
			set_animated("idle_side")

func get_unit_postion():
	return global_position

func get_north_postion():
	orientation = 0
	return $North.global_position

func get_south_postion():
	orientation = 1
	return $South.global_position

func get_west_postion():
	orientation = 2
	return $West.global_position

func get_east_postion():
	orientation = 3
	return $East.global_position

func get_distance_to(distance):
	return global_position.distance_to(distance)

func move(point, speed):
	match orientation:
		0:
			set_animated("walk_north")
		1:
			set_animated("walk_south")
		2:
			$AnimatedSprite.flip_h = true
			set_animated("walk_side")
		3:
			$AnimatedSprite.flip_h = false
			set_animated("walk_side")
	global_position = global_position.linear_interpolate(point, speed)
	
func set_animated(name):
	$AnimatedSprite.play(name)

func stop():
	set_animated("default")
	
# Función que permite conectar una señal de nodo padre con una función del nodo hijo.
func connect_parent_child(nsignal, nfunction):
	if get_parent().is_in_group("Level"):
		if get_parent().connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)

func _goGridCenter(x,y):
	position.x =  stepify(global_position.x,x) 
	position.y =  stepify(global_position.y ,y) -10