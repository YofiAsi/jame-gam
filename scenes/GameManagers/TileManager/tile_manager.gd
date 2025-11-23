class_name TileManager extends Node

enum TileEvent {
	ADD,
	DELETE
}

const grass_tile: PackedScene = preload("uid://lgqlregvm5l1")
const BOULDER_TILE = preload("uid://1npf5cq7opa")

@export var world_map: WorldMap


var stations_amount: int = 0

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func place_tile(map_pos: Vector2i, tile_type: Types.Tile):
	if tile_type == Types.Tile.GRASS:
		world_map.set_tile(map_pos, grass_tile)
		_notify_neighbors(map_pos, tile_type)
		return
	
	var neighbors: Dictionary[Types.Direction, Tile] = world_map.get_tile_neighbors_instances(map_pos)
	var direction: Types.Direction = _calc_tile_direction(neighbors, tile_type)
	world_map.set_tile(map_pos, Consts.TYPE_PKS[tile_type][direction])
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
		if event == TileEvent.ADD and tile_type != Types.Tile.CANYON_TILE:
			world_map.set_available_tile(map_pos)
		return
	if is_instance_of(instance, StationTile):
		return
	if instance.tile_type == Types.Tile.AVAILABLE_TILE:
		if _should_remove_available_tile(map_pos):
			world_map.remove_tile(map_pos)
			instance.queue_free()
		return
	if instance.tile_type == tile_type:
		if tile_type == Types.Tile.GRASS:
			return
		var apply_direction = event_direction if event == TileEvent.ADD else Types.Direction.NO_DIRECTION
		var direction := _calc_tile_direction(world_map.get_tile_neighbors_instances(map_pos), tile_type, apply_direction)
		world_map.set_tile(map_pos, Consts.TYPE_PKS[tile_type][direction])
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
		if instance.tile_type == Types.Tile.BOULDER:
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

# --- New Logic Starts Here ---

func randomize_land_camp(radius: int, min_dist: int, max_dist: int) -> void:
	var color = Consts.STATION_COLORS[stations_amount % Consts.STATION_COLORS.size()]
	stations_amount += 1
	
	# 1. Spawn Camp (Global Random within radius)
	var camp_pos = _find_valid_position(Vector2i.ZERO, 0, radius, true, radius)
	if camp_pos == Vector2i.MAX: 
		return # Failed to find spot
		
	var camp_tile: Camp = world_map.set_tile(camp_pos, Consts.STATIONS["land_camp"])
	camp_tile.set_color(color)
	_notify_neighbors(camp_pos, Types.Tile.ROAD_TILE, TileEvent.ADD)
	
	# 2. Spawn Food (Relative to Camp, but strictly inside global radius)
	var food_pos = _find_valid_position(camp_pos, min_dist, max_dist, false, radius)
	if food_pos != Vector2i.MAX:
		var food_tile = world_map.set_tile(food_pos, Consts.STATIONS["land_food"])
		food_tile.set_color(color)
		_notify_neighbors(food_pos, Types.Tile.ROAD_TILE, TileEvent.ADD)
		camp_tile.food_tile = food_tile

func randomize_water_camp(radius: int, min_dist: int, max_dist: int) -> void:
	var color = Consts.STATION_COLORS[stations_amount % Consts.STATION_COLORS.size()]
	stations_amount += 1
	
	# 1. Spawn Camp (Global Random within radius)
	var camp_pos = _find_valid_position(Vector2i.ZERO, 0, radius, true, radius)
	if camp_pos == Vector2i.MAX: 
		return
		
	var camp_tile: Camp = world_map.set_tile(camp_pos, Consts.STATIONS["river_camp"])
	camp_tile.set_color(color)
	_notify_neighbors(camp_pos, Types.Tile.WATER_TILE, TileEvent.ADD)

	# 2. Spawn Coin (Relative to Camp, but strictly inside global radius)
	var coin_pos = _find_valid_position(camp_pos, min_dist, max_dist, false, radius)
	if coin_pos == Vector2i.MAX:
		return # Stop chain if we can't place coin
		
	var coin_tile = world_map.set_tile(coin_pos, Consts.STATIONS["river_coin"])
	coin_tile.set_color(color)
	_notify_neighbors(coin_pos, Types.Tile.WATER_TILE, TileEvent.ADD)
	camp_tile.coin_tile = coin_tile
	
	# 3. Spawn Shrine (Relative to Coin, but strictly inside global radius)
	var shrine_pos = _find_valid_position(coin_pos, min_dist, max_dist, false, radius)
	if shrine_pos != Vector2i.MAX:
		var shrine_tile = world_map.set_tile(shrine_pos, Consts.STATIONS["river_shrine"])
		shrine_tile.set_color(color)
		_notify_neighbors(shrine_pos, Types.Tile.WATER_TILE, TileEvent.ADD)
		camp_tile.shrine_tile = shrine_tile

func _find_valid_position(
	origin: Vector2i, 
	min_dist: int, 
	max_dist: int, 
	is_global_random: bool = false, 
	max_global_radius: int = -1
) -> Vector2i:
	
	var attempts := 300
	
	while attempts > 0:
		attempts -= 1
		
		var target_pos: Vector2i
		
		if is_global_random:
			# Random spot in the world within radius of 0,0
			var dx = randi_range(-max_dist, max_dist)
			var dy = randi_range(-max_dist*2, max_dist*2)
			target_pos = Vector2i(dx, dy)
		else:
			# Random spot relative to origin
			var dx = randi_range(-max_dist, max_dist)
			var dy = randi_range(-max_dist*2, max_dist*2)
			target_pos = origin + Vector2i(dx, dy)
		
		# Check global radius bound (Distance from World Center 0,0)
		if max_global_radius > 0:
			if target_pos.distance_to(Vector2i.ZERO) > max_global_radius:
				continue

		# Check relative distance bounds
		var dist = target_pos.distance_to(origin)
		# If global random, we treat origin (0,0) as center, so min_dist is usually 0
		if not is_global_random:
			if dist < min_dist or dist > max_dist:
				continue
		
		# Check if occupied
		if world_map.is_pos_station(target_pos):
			continue
			
		# Check neighbors for crowding
		var neighbors = world_map.get_tile_neighbors(target_pos)
		var near_station := false
		for n in neighbors.values():
			if world_map.is_pos_station(n):
				near_station = true
				break
		if near_station:
			continue
			
		return target_pos
		
	push_error("Could not find valid tile position after 300 attempts")
	return Vector2i.MAX

func set_boulder(map_pos: Vector2i):
	world_map.set_tile(map_pos, BOULDER_TILE)
	_notify_neighbors(map_pos, Types.Tile.BOULDER)
