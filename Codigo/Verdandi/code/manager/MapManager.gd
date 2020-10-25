extends TileMap
#DECLARACION DE VARIABLES
var FIX_POINT  = Vector2(0,8)
#var FIX_POINT  = Vector2(0,0)
#PoolVector2Array
var COMPASS = Array ([
	Vector2(0,-1),  #N 
	Vector2(1, -1), #NE
	Vector2(1, 0),  #E
	Vector2(1, 1),  #SE
	Vector2(0, 1),  #S
	Vector2(-1, 1), #SW
	Vector2(-1, 0), #W
	Vector2(-1,-1)  #NW
])
# FUNCION QUE OBTIENE EL INDICE DE LA CELDA QUE CONTIENE UN PUNTO.
func _ready():
	get_tileset().create_clones_tiles()
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
# FUNCION QUE INDICA SI LA CELDA USADA EXISTE ENTRE LAS UTILIZADAS
func is_used_cell(cell):
	return get_used_cells().has(cell)
# FUNCION QUE INDICA SI LA CELDA TIENE TILE
func is_cell_tile(cell):
	return get_index_tileset(cell) != INVALID_CELL and get_tileset().is_can_navigation(get_index_tileset(cell))
# OBTENER EL PUNTO CENTRADO DE LA CELDA EN POSICION
func get_center_point(posicion):
	var cell_index = get_cell_for_point(posicion)
	return get_center_point_for_cell(cell_index)
# OBTENER SIGUIENTE PUNTO ORIENTADO
func get_next_point(posicion, orientacion):
	var cell_index = get_cell_for_point(posicion) + COMPASS[orientacion]
	return get_center_point_for_cell(cell_index)
# FUNCION QUE VALIDA SI CELDA EN X POSICION TIENE UN TILE
func valid_cell_selected(posicion):
	return is_cell_tile(get_cell_for_point(posicion))
# FUNCION QUE CAMBIA EL TILE A SU PAR EDITABLE EN LA POSICION
func switch_tile(cell):
	 set_cellv(cell, get_tileset().get_switch_index(get_index_tileset(cell)))
# FUNCIONES QUE CAMBIAN EL TILE A SU TIPO DE PAR EDITABLE EN LA POSICION
func switch_order_cell(cell,order_id):
	 set_cellv(cell, get_tileset().get_tile_clone_index(get_index_tileset(cell),order_id))
# FUNCIONES QUE CAMBIAN TODOS LOS TILES EDITABLES EN BRUJULA DESDE LA POSICION
func switch_in_compass_order(posicion, order_id, rango):
	if valid_cell_selected(posicion):
		var cell_index =  get_cell_for_point(posicion)
		for a in range(rango):
			for i in COMPASS.size():
				var next_cell = (COMPASS[i] * (a+1)) + cell_index 
				if  is_cell_tile(next_cell):
					switch_order_cell(next_cell,order_id)
