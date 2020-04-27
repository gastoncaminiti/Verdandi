extends TileMap

var FIX_POINT  = Vector2(10,35)
var POLY_COLOR = Color(1.0, 0.0, 0.0)
var COMPASS = PoolVector2Array ([
	Vector2(-1,-1),#NW 
	Vector2(0,-1), #N 
	Vector2(1, -1),#NE
	Vector2(1, 0), #E
	Vector2(1, 1), #SE
	Vector2(0, 1), #S
	Vector2(-1, 1),#SW
	Vector2(-1, 0) #W
])
# FUNCION QUE OBTIENE EL INDICE DE LA CELDA QUE CONTIENE UN PUNTO.
func _ready():
	#print(get_point_for_cell(Vector2(1,0)))
	#print(get_center_point_for_cell(Vector2(1,0)))
	#print(get_pollygon_tile(0))
	#print(COMPASS[1])
	pass
# FUNCION QUE OBTIENE EL INDICE DE LA CELDA QUE CONTIENE UN PUNTO.
func get_cell_for_point(point):
	return world_to_map(point)
# FUNCION QUE OBTIENE EL PUNTO DE ORIGEN DE UNA CELDA.
func get_point_for_cell(cell):
	return map_to_world(cell)
# FUNCION QUE OBTIENE EL PUNTO CENTRAL DE UNA CELDA.
func get_center_point_for_cell(cell):
	return map_to_world(cell) + FIX_POINT
# FUNCION QUE OBTIENE EL INDICE TILE DE UNA CELDA
func get_index_tileset(cell):
	return get_cellv(cell)
# FUNCION QUE OBTIENE EL POLIGONO DE NAVEGACION DE UN TILE
func get_pollygon_tile(id):
	return get_tileset().tile_get_navigation_polygon(id).get_vertices() 
# OBTENER SIGUIENTE PUNTO ORIENTADO
func get_next_point(posicion, orientacion):
	var cell_index = get_cell_for_point(posicion) + COMPASS[orientacion]
	get_tileset().get_shape_tile(1)
	return get_center_point_for_cell(cell_index)
