extends TileMap
#DECLARACION DE VARIABLES
var FIX_POINT  = Vector2(2,2)
var POLY_COLOR = Color(1.0, 0.0, 0.0)
var COMPASS = PoolVector2Array ([
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
	get_tileset().create_tile_switch_for(8)
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
	return get_index_tileset(cell) != INVALID_CELL
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

func switch_in_compass(posicion):
	if valid_cell_selected(posicion):
		var cell_index =  get_cell_for_point(posicion)
		for i in COMPASS.size():
			var next_cell = cell_index + COMPASS[i]
			if  is_cell_tile(next_cell):
				switch_tile(next_cell)

func switch_in_compass_color(posicion,color):
	if valid_cell_selected(posicion):
		var cell_index =  get_cell_for_point(posicion)
		for i in COMPASS.size():
			var next_cell = cell_index + COMPASS[i]
			if  is_cell_tile(next_cell):
				set_switch_tile_color(get_index_tileset(next_cell),color)
				switch_tile(next_cell)

# TESTEO DE CAMBIO DE TILE
func switch_valid_tileA(posicion):
	if valid_cell_selected(posicion):
		 var cell = get_cell_for_point(posicion)
		 set_switch_tile_color(get_index_tileset(cell),Color.gray)
		 switch_tile(cell)

func switch_valid_tileC(posicion):
	if valid_cell_selected(posicion):
		 var cell = get_cell_for_point(posicion)
		 set_switch_tile_color(get_index_tileset(cell),Color.darkred)
		 switch_tile(cell)

func switch_valid_tileB(posicion):
	if valid_cell_selected(posicion):
		 switch_tile(get_cell_for_point(posicion))

func set_switch_tile_color(id,color):
	get_tileset().set_tile_modulate(id, color)
