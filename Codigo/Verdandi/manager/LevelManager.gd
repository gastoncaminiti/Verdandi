extends Node2D

onready var nav : Navigation2D = $Navigation2D
onready var map : TileMap = $Navigation2D/TileMap

onready var size_cell_x = $Navigation2D/TileMap.cell_size.x / 2
onready var size_cell_y = $Navigation2D/TileMap.cell_size.y / 2

var pos_unit = Vector2()

var path : PoolVector2Array
export var speed := 250

signal map_initiated

func _ready():
	emit_signal("map_initiated", $Navigation2D/TileMap)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			select_path()
			$Line2D.points = PoolVector2Array(path)
			$Line2D.show()
			
func _process(delta: float) -> void:
	if path.size() > 0:
		var k: float = get_node("Norse-Swordman").get_distance_to(path[0])
		if k > 10:
			get_node("Norse-Swordman").move(path[0], (speed * delta)/k)
		else:
			path.remove(0)
#	if get_node("Norse-Swordman").get_distance_to(goal) < 31:
#		get_node("Norse-Swordman").stop()
func select_path():
	
	#pos_unit.x =  stepify(get_node("Norse-Swordman").get_unit_postion().x,size_cell_x) 
	#pos_unit.y =  stepify(get_node("Norse-Swordman").get_unit_postion().y , size_cell_y)
	var node_soldier = get_node("Norse-Swordman")
	print(node_soldier.get_unit_position())
	path = nav.get_simple_path(node_soldier.get_unit_position(), nav.get_closest_point(node_soldier.get_northeast_position()), true)
	print(path)
	#print(map.world_to_map (get_node("Norse-Swordman").get_east_postion()))
	var tl = map.map_to_world(map.world_to_map (get_node("Norse-Swordman").get_northeast_position()))
	#print(map.world_to_map (get_node("Norse-Swordman").get_east_postion()))
	path[path.size()-1].x = tl.x 
	path[path.size()-1].y = tl.y + size_cell_y 
	
	#path = nav.get_simple_path( pos_unit, nav.get_closest_point(node_soldier.get_north_postion()), true)
	#if path.size() > 2 and node_soldier.get_distance_to(path[0]) > 10:
	#	path[path.size()-1].x = stepify(path[path.size()-1].x,size_cell_x) 
	#	path[path.size()-1].y = stepify(path[path.size()-1].y , size_cell_y)
	#	return
	#path = nav.get_simple_path( pos_unit, nav.get_closest_point(node_soldier.get_south_postion()), true)
	#if path.size() > 2 and node_soldier.get_distance_to(path[0]) > 10:
	#	path[path.size()-1].x = stepify(path[path.size()-1].x,size_cell_x) 
	#	path[path.size()-1].y = stepify(path[path.size()-1].y , size_cell_y)
	#	return
	#path = nav.get_simple_path( pos_unit, nav.get_closest_point(node_soldier.get_west_postion()), true)
	#if path.size() > 2 and node_soldier.get_distance_to(path[0]) > 10:
	#	path[path.size()-1].x = stepify(path[path.size()-1].x,size_cell_x) 
	#	path[path.size()-1].y = stepify(path[path.size()-1].y , size_cell_y)
	#	return
	#path = nav.get_simple_path( pos_unit, nav.get_closest_point(node_soldier.get_east_postion()), true)
	#path[path.size()-1].x = stepify(path[path.size()-1].x,size_cell_x) 
	#path[path.size()-1].y = stepify(path[path.size()-1].y , size_cell_y)
