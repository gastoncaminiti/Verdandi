extends TileSet

var dic_tile_switch = {}

func create_tile_switch_for(id):
	dic_tile_switch[id] = get_last_unused_tile_id()
	dic_tile_switch[get_last_unused_tile_id()] = id
	create_tile(dic_tile_switch[id])
	tile_set_texture(dic_tile_switch[id], tile_get_texture(id))
	set_tile_modulate(id, Color.darkred)
	tile_set_region(dic_tile_switch[id], tile_get_region(id))
# FUNCION QUE OBTIEN EL INDICE DEL TILE PAR DEL DICCIONARIO DE TILES REMPLAZABLES.
func get_switch_index(id):
	return dic_tile_switch[id]

func set_tile_modulate(id, color):
	tile_set_modulate(dic_tile_switch[id], color)

func get_shape_tile(id):
	print(tile_get_shapes(id))
