class_name TileManager extends Node

@export var world_map: WorldMap

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func place_tile(map_pos: Vector2i, tile_type: Types.Tile):
	var neighbors: Dictionary[Types.Direction, Tile] = world_map.get_tile_neighbors_instances(map_pos)
	var direction: Types.Direction = _calc_tile_direction(neighbors, tile_type)
	var tile_id: int = Consts.DIRECTION_TILE_ID.get(direction)
	world_map.set_tile(map_pos, tile_id, tile_type)
	_notify_neighbors(map_pos, tile_type)

func _notify_neighbors(map_pos: Vector2i, tile_type: Types.Tile):
	var neighbors := world_map.get_tile_neighbors(map_pos)
	for neighbor: Types.Direction in neighbors.keys():
		var instance: Tile = world_map.map_to_instance(neighbors.get(neighbor))
		if is_instance_valid(instance):
			if is_instance_of(instance, StationTile):
				continue
			if instance.tile_type == tile_type:
				var direction := _calc_tile_direction(world_map.get_tile_neighbors_instances(neighbors.get(neighbor)), tile_type, Consts.OP_DIRECTION.get(neighbor))
				var tile_id: int = Consts.DIRECTION_TILE_ID.get(direction)
				world_map.set_tile(neighbors.get(neighbor), tile_id, tile_type)
		elif not world_map.map_to_scene_mat.has(str(neighbor)):
			world_map.set_available_tile(neighbors.get(neighbor))

func _calc_tile_direction(neighbors: Dictionary[Types.Direction, Tile], tile_type: Types.Tile, apply_direction: Types.Direction = Types.Direction.NO_DIRECTION) -> Types.Direction:
	var direction := Types.Direction.NO_DIRECTION
	if not is_instance_valid(world_map):
		print_debug("no world map found")
		return direction
	
	var _direction_count: int = 0
	var neighbor: Tile
	
	neighbor = neighbors.get(Types.Direction.TOP_LEFT)
	if apply_direction == Types.Direction.TOP_LEFT \
		or (is_instance_valid(neighbor) and neighbor.tile_type == tile_type):
		_direction_count += 1
		direction = Types.Direction.TOP_LEFT
	
	neighbor = neighbors.get(Types.Direction.TOP_RIGHT)
	if apply_direction == Types.Direction.TOP_RIGHT \
	 or (is_instance_valid(neighbor) and neighbor.tile_type == tile_type):
		_direction_count += 1
		if direction == Types.Direction.TOP_LEFT:
			direction = Types.Direction.TURN_D
		else:
			direction = Types.Direction.TOP_RIGHT
	
	neighbor = neighbors.get(Types.Direction.BOTTOM_RIGHT)
	if apply_direction == Types.Direction.BOTTOM_RIGHT \
		or (is_instance_valid(neighbor) and neighbor.tile_type == tile_type):
		_direction_count += 1
		if direction == Types.Direction.TOP_RIGHT:
			direction = Types.Direction.TURN_L
		else:
			direction = Types.Direction.BOTTOM_RIGHT
	
	neighbor = neighbors.get(Types.Direction.BOTTOM_LEFT)
	if apply_direction == Types.Direction.BOTTOM_LEFT \
	or (is_instance_valid(neighbor) and neighbor.tile_type == tile_type):
		_direction_count += 1
		if direction == Types.Direction.BOTTOM_RIGHT:
			direction = Types.Direction.TURN_U
		elif direction == Types.Direction.TOP_LEFT:
			direction = Types.Direction.TURN_R
		else:
			direction = Types.Direction.BOTTOM_LEFT
		
	if _direction_count >= 3:
		direction = Types.Direction.CROSS
	
	return direction
