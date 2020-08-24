extends Node2D

func _ready():
	hide_select_map()
#-------------------------------------SECTION A*  MAP FUNCTION-------------------------------------

#-------------------------------------SECTION GUI MAP FUNCTION-------------------------------------
#FUNCTION CLEAR ALL TILES IN SELECTMAP.
func hide_select_map():
	$SelectMap.clear()
#FUNCTION SHOW TILES IN ALL VALID CELLS.
func show_grid_map():
	for cell in $Map.get_used_cells():
		if $Map.is_cell_tile(cell):
			set_selected_cell(cell, 3)
#FUNCTION SHOW TILE IN ONE VALID CELLS.
func set_selected_cell(cell,id_tile):
	$SelectMap.set_cellv(cell, id_tile)
#FUNCTION SHOW TILES IN ESPECIFICS CELLS.
func set_selected_cells(cells,id_tile):
	for i in cells.size():
		if $Map.is_cell_tile(cells[i]):
			set_selected_cell(cells[i], id_tile)
#FUNCTION GENERATE ESPECIFICS CELLS FOR ORDENxRELATION MATRIX.
func get_cells_for(orden, relation):
	var init_coord = Vector2(-1,-1) * relation
	var cells = PoolVector2Array()
	for i in range(orden):
		for j in range(orden):
			cells.append(init_coord + Vector2(i,j))
	return cells
#FUNCTION GENERATE ORDINAL CELLS FOR ORDENxRELATION MATRIX IN CELL.
func get_selected_for_cell(cell, cells):
	var ordinal_cells = PoolVector2Array()
	for i in cells.size():
		ordinal_cells.append(cell + cells[i])
	return ordinal_cells
#FUNCTION TEST VALID SELECTED TEST IN MAP.
func get_valid_cell(g_position):
	return $Map.valid_cell_selected(g_position)
#FUNCTION SHOW GRID ORDINAL CELLS FOR A CELL.
func show_selected_grid(g_position,orden, relation,id_tile):
	if get_valid_cell(g_position):
		var used_cell = $Map.get_cell_for_point(g_position)
		var selected_cells = get_selected_for_cell(used_cell,get_cells_for(orden, relation))
		for cell in selected_cells:
			if $Map.is_cell_tile(cell) && cell != used_cell:
				set_selected_cell(cell, id_tile)
