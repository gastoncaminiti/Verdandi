extends Node2D
# -------------------------------------LEVELMAPMANAGER SCRIPT -------------------------------------
# Containers VAR
var map_astar = null
var point_dic = {}
#FUNCTION READY
func _ready():
	hide_select_map()
	init_points_astar2D()
	connect_point_dic()
#-------------------------------------SECTION A*  MAP FUNCTION-------------------------------------
#FUNCTION
func init_points_astar2D():
	map_astar = AStar2D.new()
	var used_cells = $Map.get_used_cells()
	for cell in used_cells:
		var point_astar_id = map_astar.get_available_point_id()
		map_astar.add_point(point_astar_id,$Map.get_center_point_for_cell(cell), 1)
		point_dic[get_index_point_dic(cell)] = point_astar_id
#FUNCTION
func get_index_point_dic(cell):
	return str(int(round(cell.x)))+","+str(int(round(cell.y)))
#FUNCTION
func connect_point_dic():
	for cell in $Map.get_used_cells():
		for x in [-1,0]:
			for y in [-1,0]:
				var v2 = Vector2(x,y)
				if v2 == Vector2(0,0):
					continue
				if get_index_point_dic(v2+cell) in point_dic:
					var id1 = point_dic[get_index_point_dic(cell)]
					var id2 = point_dic[get_index_point_dic(cell + v2)]
					if !map_astar.are_points_connected(id1,id2):
						map_astar.connect_points(id1,id2,true)
#FUNCTION
func get_astar_path(start,end):
	var mp_start = get_index_point_dic($Map.get_cell_for_point(start))
	var mp_end = get_index_point_dic($Map.get_cell_for_point(end))
	return map_astar.get_point_path(get_valid_astar_id(mp_start,start), get_valid_astar_id(mp_end,end))
#FUNCTION
func get_valid_astar_id(id,point):
	return point_dic[id] if id in point_dic else map_astar.get_closest_point(point)
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
