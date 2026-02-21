extends Node2D
class_name Level

const TILE_SIZE: int = 32

const WORLD_TO_CELL_OFFSET = Vector2(4,2)

##################################  TILES  #####################################

func world_to_cell(pos: Vector2) -> Vector2:
	"""
	Take a world coord/vector and convert it to a cell that can access the tile
	map layer
	"""
	# half_offset needs to be omited for world_to_cell
	return snap_to_tile(pos, false) / TILE_SIZE #- WORLD_TO_CELL_OFFSET
	
func cell_to_world(pos: Vector2, half_offset: bool = false, fix_display: bool = true):
	"""
	Take a cell and convert it to a coord/vector
	"""
	return snap_to_tile(pos * TILE_SIZE, half_offset, fix_display) + WORLD_TO_CELL_OFFSET*TILE_SIZE

func snap_to_tile(pos: Vector2, half_offset: bool = true, fix_display: bool = false) -> Vector2:
	pos += Vector2(16,0)
	var snapped = floor(pos/float(TILE_SIZE)) * TILE_SIZE
	#if fix_display:
		#snapped+=Vector2(10,-10) ## OFFSET BECAUSE OF GAME BOARD POSITIONING IN GAME SCENE
	if half_offset:
		snapped+=Vector2.ONE * TILE_SIZE * 0.5
		
	return snapped
