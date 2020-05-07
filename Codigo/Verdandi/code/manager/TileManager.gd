extends TileSet

var dic_tile_switch = {}
# VARIABLE DE DICCIONARIO DE TILE CLONADOS
var dictionary_clone_tiles = {}
# CONSTANTES DE TIPO DE INDICES TILE EN DICCIONARIO
var O_INDEX = 0
var M_INDEX = 1
var B_INDEX = 2


func create_tile_switch_for(id):
	print(tile_get_name(id))
	dic_tile_switch[id] = get_last_unused_tile_id()
	dic_tile_switch[get_last_unused_tile_id()] = id
	create_tile(dic_tile_switch[id])
	tile_set_texture(dic_tile_switch[id], tile_get_texture(id))
	tile_set_name(dic_tile_switch[id],tile_get_name(id))
	set_tile_modulate(id, Color.darkred)
	tile_set_region(dic_tile_switch[id], tile_get_region(id))
	print(tile_get_name(dic_tile_switch[id]))
# CLONAR DOS TILES DE SUSTITUCION EN OTRO COLOR Y AGREGAR REFERENCIAS AL DICCIONARIO
func create_clones_for_tile(id):
	var aux_array = []
	aux_array.append(id)
	aux_array.append(clone_tile_color(id, Color.gray))
	aux_array.append(clone_tile_color(id, Color.darkred))
	dictionary_clone_tiles[tile_get_name(id)] = aux_array
	#print(dictionary_clone_tiles[tile_get_name(id)][O_INDEX])
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
func get_tile_o_index(id):
	return dictionary_clone_tiles[tile_get_name(id)][O_INDEX]
# FUNCION QUE OBTIEN EL INDICE DEL TILE REMPLAZABLE DE MOVIMIENTO.
func get_tile_m_index(id):
	return dictionary_clone_tiles[tile_get_name(id)][M_INDEX]
# FUNCION QUE OBTIEN EL INDICE DEL TILE REMPLAZABLE DE BATALLA.
func get_tile_b_index(id):
	return dictionary_clone_tiles[tile_get_name(id)][B_INDEX]
# FUNCION QUE OBTIEN EL INDICE DEL TILE PAR DEL DICCIONARIO DE TILES REMPLAZABLES.
func get_switch_index(id):
	return dic_tile_switch[id]
func set_tile_modulate(id, color):
	tile_set_modulate(dic_tile_switch[id], color)

func get_shape_tile(id):
	print(tile_get_shapes(id))
