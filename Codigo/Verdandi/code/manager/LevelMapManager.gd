extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var proto_matrix = [[true, true, true], [true, false, true], [true, true, true]]

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_select_map()
	show_grid_map()
	print(get_selected_for_cell(Vector2(2,2),get_cells_for(3, 1)))

func hide_select_map():
	$SelectMap.clear()

func show_grid_map():
	for cell in $Map.get_used_cells():
		if $Map.is_cell_tile(cell):
			set_selected_cell(cell, 3)

func set_selected_cell(cell,id_tile):
	$SelectMap.set_cellv(cell, id_tile)

func set_selected_cells(cells,id_tile):
	for i in cells.size():
		if $Map.is_cell_tile(cells):
			set_selected_cell(cells[i], id_tile)

func get_cells_for(orden, relation):
	var init_coord = Vector2(-1,-1) * relation
	var cells = PoolVector2Array()
	for i in range(orden):
		for j in range(orden):
			cells.append(init_coord + Vector2(i,j))
	return cells

func get_selected_for_cell(cell, cells):
	var ordinal_cells = PoolVector2Array()
	for i in cells.size():
		ordinal_cells.append(cell + cells[i])
	return ordinal_cells
	
func get_valid_cell(g_position):
	return $Map.valid_cell_selected(g_position)

func show_selected_grid(g_position,orden, relation,id_tile):
	if get_valid_cell(g_position):
		var used_cell = $Map.get_cell_for_point(g_position)
		var selected_cells = get_selected_for_cell(used_cell,get_cells_for(orden, relation))
		for cell in selected_cells:
			if $Map.is_cell_tile(cell) && cell != used_cell:
				set_selected_cell(cell, id_tile)
