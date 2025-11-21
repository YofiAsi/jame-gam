class_name TileManager extends Node

enum TileEvent {
	ADD,
	DELETE
}

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

func _notify_neighbors(map_pos: Vector2i, tile_type: Types.Tile, event: TileEvent = TileEvent.ADD):
	var neighbors := world_map.get_tile_neighbors(map_pos)
	for neighbor_dir: Types.Direction in neighbors.keys():
		var neighbor_pos: Vector2i = neighbors.get(neighbor_dir)
		_update_tile(neighbor_pos, tile_type, event, Consts.OP_DIRECTION.get(neighbor_dir))

func _update_tile(
	map_pos: Vector2i,
	tile_type: Types.Tile,
	event: TileEvent,
	event_direction: Types.Direction
	):
	var instance: Tile = world_map.map_to_instance(map_pos)
	if not is_instance_valid(instance):
		if event == TileEvent.ADD:
			world_map.set_available_tile(map_pos)
		return
	if is_instance_of(instance, StationTile):
		return
	if instance.tile_type == Types.Tile.AVAILABLE_TILE \
		and event == TileEvent.DELETE:
		if _should_remove_available_tile(map_pos):
			world_map.remove_tile(map_pos)
			instance.queue_free()
		return
	if instance.tile_type == tile_type:
		var apply_direction = event_direction if event == TileEvent.ADD else Types.Direction.NO_DIRECTION
		var direction := _calc_tile_direction(world_map.get_tile_neighbors_instances(map_pos), tile_type, apply_direction)
		var tile_id: int = Consts.DIRECTION_TILE_ID.get(direction)
		world_map.set_tile(map_pos, tile_id, tile_type)
		return
	
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

func _should_remove_available_tile(map_pos: Vector2i) -> bool:
	var neighbors := world_map.get_tile_neighbors(map_pos)
	for neighbor in neighbors:
		var instance: Tile = world_map.map_to_instance(neighbors.get(neighbor))
		if not is_instance_valid(instance):
			continue
		if not instance.tile_type == Types.Tile.AVAILABLE_TILE:
			return false
	
	return true

func _should_set_available_tile(map_pos: Vector2i) -> bool:
	var neighbors := world_map.get_tile_neighbors(map_pos)
	for neighbor_dir: Types.Direction in neighbors.keys():
		var neighbor_pos: Vector2i = neighbors.get(neighbor_dir)
		var instance: Tile = world_map.map_to_instance(neighbor_pos)
		if not is_instance_valid(instance):
			continue
		if instance.tile_type != Types.Tile.AVAILABLE_TILE:
			return true
		
	return false

func remove_tile(tile: Tile) -> void:
	var map_pos: Vector2i = world_map.local_to_map(tile.position)
	var tile_type: Types.Tile = tile.tile_type
	tile.queue_free()
	world_map.remove_tile(map_pos)
	_notify_neighbors(map_pos, tile_type, TileEvent.DELETE)
	
	if _should_set_available_tile(map_pos):
		world_map.set_available_tile(map_pos)

func _randomize_pos() -> Vector2i:
	return Vector2i(randi_range(0,10), randi_range(0,10))

func _get_unoccupide_tile() -> Vector2i:
	var pos: Vector2i = _randomize_pos()
	while true:
		if not world_map.is_pos_station(pos):
			return pos
		pos = _randomize_pos()
	return Vector2i.ZERO

func randomize_camp() -> void:
	var food_pos: Vector2i = _get_unoccupide_tile()
	world_map.set_cell(food_pos, 1, Vector2i.ZERO, 4)
	var food_tile: LandFood = await TileCreationEmmiter.station_tile_created
	_notify_neighbors(food_pos, Types.Tile.ROAD_TILE, TileEvent.ADD)
	
	var camp_pos: Vector2i = _get_unoccupide_tile()
	world_map.set_cell(camp_pos, 1, Vector2i.ZERO, 1)
	var camp_tile: LandCamp = await TileCreationEmmiter.station_tile_created
	_notify_neighbors(camp_pos, Types.Tile.ROAD_TILE, TileEvent.ADD)
	camp_tile.food_tile = food_tile
	
