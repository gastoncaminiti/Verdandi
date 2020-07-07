extends TileSet
# VARIABLE DE DICCIONARIO DE TILE CLONADOS
export(Array, String) var navigation_tiles_key
var dictionary_clone_tiles = {}
# CLONAR DOS TILES DE SUSTITUCION EN OTRO COLOR Y AGREGAR REFERENCIAS EN ORDEN AL DICCIONARIO
func create_clones_tiles():
	var list_tiles = get_tiles_ids()
	for i in list_tiles.size():
		if is_can_navigation(list_tiles[i]):
			create_clones_for_tile(list_tiles[i])
# CLONAR DOS TILES DE SUSTITUCION EN OTRO COLOR Y AGREGAR REFERENCIAS EN ORDEN AL DICCIONARIO
func create_clones_for_tile(id):
	var aux_array = []
	aux_array.append(id)
	aux_array.append(clone_tile_color(id, Color.darkgreen))
	aux_array.append(clone_tile_color(id, Color.darkred))
	dictionary_clone_tiles[tile_get_name(id)] = aux_array
# CLONAR TILE CON OTRO COLOR Y RETORNAR INDICE
func clone_tile_color(id_tile, new_color):
	var id_new_tile = get_last_unused_tile_id()
	create_tile(id_new_tile)
	tile_set_name(id_new_tile,tile_get_name(id_tile))
	tile_set_texture(id_new_tile, tile_get_texture(id_tile))
	tile_set_modulate(id_new_tile, new_color)
	tile_set_region(id_new_tile, tile_get_region(id_tile))
	return id_new_tile
# FUNCION QUE OBTIEN EL INDICE DEL TILE REMPLAZABLE ORIGINAL.
func get_tile_clone_index(id,order_id):
	return dictionary_clone_tiles[tile_get_name(id)][order_id]
# FUNCION QUE DETERMINA SI EL TILE ES NAVEGABLE
func is_can_navigation(id):
	return navigation_tiles_key.has(tile_get_name(id)) 
