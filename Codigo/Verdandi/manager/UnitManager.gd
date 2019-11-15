extends KinematicBody2D

# Editable VAR
export(int) var move_speed = 100
export(int) var cell_range =  2
export(int) var path_dimension  =  3
export(int, "North", "South","West","East","NorthWest","NorthEast","SouthWest","SouthEast") var orientation = 0
export(int, "North", "South","West","East","NorthWest","NorthEast","SouthWest","SouthEast") var priority_orientation = 0
# Game VAR
export(int) var life = 100
export(int) var attack = 20
export(int) var attack_speed = 2
export(int) var defense = 20
# Private VAR
var my_map:  TileMap
var my_path: PoolVector2Array
var my_goal_position
var my_index_path
var size_cell_x
var size_cell_y 
var flag_move = false
var flag_priority = false
var flag_attack = false

func _ready():
	connect_parent_child("map_initiated","_goMapConfig")
	connect_parent_child("units_moved","_goPahtConfig")
	hide_areas()

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
	orientation_animation("walk")
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
	orientation_animation("idle")

func _goPahtConfig(nav):
		if(my_path):
			var index_end =  my_path.size() - 1
			if(my_index_path  < index_end):
				#print("En Camino")
				my_index_path+=1 
				my_goal_position = set_center_position_by_cell(get_position_by_cell_index(get_cell_index(my_path[my_index_path])))
				flag_move = true
			else:
				#print("Reorientado")
				if(my_index_path == index_end):
					orientation_reorientation()
					search_path(nav)
					orientation_animation("idle")
					#set_center_path()
					my_index_path+=1 
					my_goal_position = set_center_position_by_cell(get_position_by_cell_index(get_cell_index(my_path[my_index_path])))
					flag_move = true
			
		else:
			search_path(nav)
			orientation_animation("idle")
			set_center_path()
			my_index_path+=1 
			my_goal_position = set_center_position_by_cell(get_position_by_cell_index(get_cell_index(my_path[my_index_path]))) 
			flag_move = true
	
func valid_path(my_path, my_nav):
	if( get_cell_index(my_path[0]) == get_cell_index(my_path[1])):
		return false
	if(my_path.size() < path_dimension):
		return false
	set_center_path()
	#print(my_path[0].distance_to(my_path[1]))
	if(my_path[0].distance_to(my_path[1]) < my_map.cell_size.y):
		return false
	return true
	
func search_path(my_nav):
	set_new_path(my_nav)
	while !valid_path(my_path, my_nav):
		orientation_reorientation()
		set_new_path(my_nav)

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
	my_path = my_nav.get_simple_path(global_position, orientation_global_position(), true)
	my_index_path = 0
	

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

func orientation_animation(prefix):
	match orientation:
		0:
			$AnimatedSprite.flip_h = false
			set_animated(prefix + "_north")
		1:
			$AnimatedSprite.flip_h = true
			set_animated(prefix + "_east")
		2:
			$AnimatedSprite.flip_h = true
			set_animated(prefix + "_north")
		3:
			$AnimatedSprite.flip_h = false
			set_animated(prefix + "_east")
		4:
			$AnimatedSprite.flip_h = false
			set_animated(prefix + "_north_west")
		5:
			$AnimatedSprite.flip_h = false
			set_animated(prefix + "_north_east")
		6:
			$AnimatedSprite.flip_h = true
			set_animated(prefix + "_north_east")
		7:
			$AnimatedSprite.flip_h = false
			set_animated(prefix + "_south_east")

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
			orientation = 3
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

func _process(delta: float) -> void:
	if flag_move:
		orientation_animation("walk")
		var d: float = global_position.distance_to(my_goal_position)
		if d > 1:
			move(my_goal_position, (move_speed * delta)/d)
		else:
			flag_move = false
			orientation_animation("idle")
			
	if flag_attack and !flag_move:
			orientation_animation("attack")

func _on_SelectedManager_mouse_entered():
	show_areas()

func _on_SelectedManager_mouse_exited():
	hide_areas()
	if get_parent().is_in_group("Level"):
		get_parent().unselected_unit()

func hide_areas():
	$North/AreaCoordinateNorth/Sprite.visible = false
	$South/AreaCoordinateSouth/Sprite.visible = false
	$East/AreaCoordinateEast/Sprite.visible   = false
	$West/AreaCoordinateWest/Sprite.visible   = false
	$NorthWest/AreaCoordinateNorthWest/Sprite.visible = false
	$NorthEast/AreaCoordinateNorthEast/Sprite.visible = false
	$SouthWest/AreaCoordinateSouthWest/Sprite.visible = false
	$SouthEast/AreaCoordinateSouthEast/Sprite.visible = false

func show_areas():
	$North/AreaCoordinateNorth/Sprite.visible = true
	$South/AreaCoordinateSouth/Sprite.visible = true
	$East/AreaCoordinateEast/Sprite.visible   = true
	$West/AreaCoordinateWest/Sprite.visible   = true
	$NorthWest/AreaCoordinateNorthWest/Sprite.visible = true
	$NorthEast/AreaCoordinateNorthEast/Sprite.visible = true
	$SouthWest/AreaCoordinateSouthWest/Sprite.visible = true
	$SouthEast/AreaCoordinateSouthEast/Sprite.visible = true


func _on_SelectedManager_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index  == BUTTON_LEFT and event.pressed:
			if get_parent().is_in_group("Level"):
				get_parent().selected_unit(life,attack,defense,attack_speed,global_position)

# AREA ENTERED SECCTION
func _on_AreaCoordinateNorth_body_entered(body):
	if(body.name != name):
		print(body.name)
		print("ENEMY IN NORTH")
		flag_attack = true
		orientation = 0

func _on_AreaCoordinateSouth_body_entered(body):
	print(name)
	if(body.name != name):
		print(body.name)
		print("ENEMY IN SOUTH")
		flag_attack = true
		orientation = 1

func _on_AreaCoordinateEast_body_entered(body):
	print(name)
	if(body.name != name):
		print(body.name)
		print("ENEMY IN EAST")
		flag_attack = true
		orientation = 3

func _on_AreaCoordinateWest_body_entered(body):
	print(name)
	if(body.name != name):
		print(body.name)
		print("ENEMY IN WEST")
		flag_attack = true
		orientation = 2

func _on_AreaCoordinateNorthWest_body_entered(body):
	print(name)
	if(body.name != name):
		print(body.name)
		print("ENEMY IN NorthWest")
		flag_attack = true
		orientation = 4

func _on_AreaCoordinateNorthEast_body_entered(body):
	print(name)
	if(body.name != name):
		print(body.name)
		print("ENEMY IN NorthEast")
		flag_attack = true
		orientation = 5


func _on_AreaCoordinateSouthWest_body_entered(body):
	print(name)
	if(body.name != name):
		print(body.name)
		print("ENEMY IN SouthWest")
		flag_attack = true
		orientation = 6


func _on_AreaCoordinateSouthEast_body_entered(body):
	print(name)
	if(body.name != name):
		print(body.name)
		print("ENEMY IN SouthEast")
		flag_attack = true
		orientation = 7
