extends KinematicBody2D

# Editable VAR
export(int) var move_range = 62
export(int) var move_speed = 250
export(int) var cell_range =  1
export(int) var path_dimension  =  3
export(int, "North", "South","West","East","NorthWest","NorthEast","SouthWest","SouthEast") var orientation = 0
# Private VAR
var my_map:  TileMap
var my_path: PoolVector2Array
var my_index_path
var size_cell_x
var size_cell_y 

func _ready():
	connect_parent_child("map_initiated","_goMapConfig")
	connect_parent_child("units_moved","_goPahtConfig")

func get_unit_position():
	return global_position

func get_path():
	return my_path
	
func get_north_position():
	orientation = 0
	return $North.global_position

func get_south_position():
	orientation = 1
	return $South.global_position

func get_west_position():
	orientation = 2
	return $West.global_position

func get_east_position():
	orientation = 3
	return $East.global_position

func get_northwest_position():
	orientation = 4
	return $NorthWest.global_position

func get_northeast_position():
	orientation = 5
	return $NorthEast.global_position

func get_distance_to(distance):
	return global_position.distance_to(distance)

func move(point, speed):
	orientation_animation()
	global_position = global_position.linear_interpolate(point, speed)
	
func set_animated(name):
	$AnimatedSprite.play(name)

# Función que permite conectar una señal de nodo padre con una función del nodo hijo.
func connect_parent_child(nsignal, nfunction):
	if get_parent().is_in_group("Level"):
		if get_parent().connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)

func _goMapConfig(map):
	my_map = map
	size_cell_x = my_map.cell_size.x / 2
	size_cell_y = my_map.cell_size.y / 2
	global_position = set_center_position_by_cell(get_position_by_cell_index(get_cell_index(global_position)))
	coordinates_reposition()
	orientation_reposition()

func _goPahtConfig(nav):
	if(my_path):
		if(my_index_path < my_path.size()):
			if(my_path[0] == my_path[1]):
				if(my_path.size() == 2):
					orientation_reorientation()
					set_new_path(nav)
					print(orientation)
				else:
					my_index_path = 2
			global_position = set_center_position_by_cell(get_position_by_cell_index(get_cell_index(my_path[my_index_path]))) 
			my_index_path+=1
		else:
			set_new_path(nav)
			orientation_reposition()
			set_center_path()
	else:
		set_new_path(nav)
		orientation_reposition()
		set_center_path()
		global_position = set_center_position_by_cell(get_position_by_cell_index(get_cell_index(my_path[my_index_path]))) 
	print(my_path)
	

func get_cell_index(pos):
	return my_map.world_to_map(pos)

func get_position_by_cell_index(index):
	return my_map.map_to_world(index)

func set_center_position_by_cell(pos):
	pos.y += size_cell_y
	return pos

func set_center_path():
	for i in my_path.size():
		my_path[i] = set_center_position_by_cell(get_position_by_cell_index(get_cell_index(my_path[i])))

func set_new_path(my_nav):
	my_path = my_nav.get_simple_path(global_position, orientation_global_position(), false)
	my_index_path = 1
	

func coordinates_reposition():
	var index_unit_pos = get_cell_index(global_position)
	$North.global_position = set_center_position_by_cell(get_position_by_cell_index(Vector2(index_unit_pos.x,index_unit_pos.y -  cell_range)))
	$South.global_position = set_center_position_by_cell(get_position_by_cell_index(Vector2(index_unit_pos.x,index_unit_pos.y +  cell_range)))
	$West.global_position  =  set_center_position_by_cell(get_position_by_cell_index(Vector2(index_unit_pos.x - cell_range,index_unit_pos.y)))
	$East.global_position  =  set_center_position_by_cell(get_position_by_cell_index(Vector2(index_unit_pos.x + cell_range,index_unit_pos.y)))
	$NorthWest.global_position = set_center_position_by_cell(get_position_by_cell_index(Vector2(index_unit_pos.x - cell_range,index_unit_pos.y - cell_range)))
	$NorthEast.global_position = set_center_position_by_cell(get_position_by_cell_index(Vector2(index_unit_pos.x + cell_range,index_unit_pos.y - cell_range)))
	$SouthWest.global_position = set_center_position_by_cell(get_position_by_cell_index(Vector2(index_unit_pos.x - cell_range,index_unit_pos.y + cell_range)))
	$SouthEast.global_position = set_center_position_by_cell(get_position_by_cell_index(Vector2(index_unit_pos.x + cell_range,index_unit_pos.y + cell_range)))
	#$North.position.y -= move_range 
	#$South.position.y += move_range
	#$West.position.x  -= move_range
	#$East.position.x  += move_range
	#$NorthWest.position.y -=move_range
	#$NorthWest.position.x -=move_range
	#$NorthEast.position.y -=move_range
	#$NorthEast.position.x +=move_range
	#$SouthWest.position.y +=move_range
	#$SouthWest.position.x -=move_range
	#$SouthEast.position.y +=move_range
	#$SouthEast.position.x +=move_range

func orientation_reposition():
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
		4:
			$AnimatedSprite.flip_h = true
			set_animated("idle_diagonal_north")
		5:
			$AnimatedSprite.flip_h = false
			set_animated("idle_diagonal_north")
		6:
			$AnimatedSprite.flip_h = true
			set_animated("idle_diagonal_south")
		7:
			$AnimatedSprite.flip_h = false
			set_animated("idle_diagonal_south")

func orientation_animation():
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
		4:
			$AnimatedSprite.flip_h = true
			set_animated("walk_diagonal_north")
		5:
			$AnimatedSprite.flip_h = false
			set_animated("walk_diagonal_north")
		6:
			$AnimatedSprite.flip_h = true
			set_animated("walk_diagonal_south")
		7:
			$AnimatedSprite.flip_h = false
			set_animated("walk_diagonal_south")

func orientation_global_position():
	match orientation:
		0:
			return $North.global_position
		1:
			return $South.global_position
		2:
			return $West.global_position
		3:
			return $East.global_position
		4:
			return $NorthWest.global_position
		5:
			return $NorthEast.global_position
		6:
			return $SouthWest.global_position
		7:
			return $SouthEast.global_position

func orientation_reorientation():
	match orientation:
		0:
			orientation = 5
		1:
			orientation = 6
		2:
			orientation = 4
		3:
			orientation = 7
		4:
			orientation = 0
		5:
			orientation = 3
		6:
			orientation = 2
		7:
			orientation = 1