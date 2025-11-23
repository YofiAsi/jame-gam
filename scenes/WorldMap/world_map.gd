extends TileMapLayer
class_name WorldMap

var map_to_scene_mat: Dictionary = {}
var available_tile: PackedScene = preload("uid://d3lap2gnkm7jj")

func _ready() -> void:
	pass

func set_tile(map_pos: Vector2i, scene: PackedScene) -> Tile:
	remove_tile(map_pos)
	var tile: Tile = scene.instantiate()
	tile.position = map_to_local(map_pos)
	add_child(tile)
	map_to_scene_mat[map_pos] = tile
	return tile

func set_available_tile(map_pos: Vector2i) -> void:
	set_tile(map_pos, available_tile)

func remove_tile(map_pos: Vector2i) -> void:
	var instance: Tile = map_to_scene_mat.get(map_pos, null)
	if instance:
		if instance.is_inside_tree():
			instance.queue_free()
		map_to_scene_mat.erase(map_pos)

func get_tile_neighbors(map_pos: Vector2i) -> Dictionary[Types.Direction, Vector2i]:
	var neighbors: Dictionary[Types.Direction, Vector2i] = {}
	neighbors[Types.Direction.TOP_LEFT] = get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE)
	neighbors[Types.Direction.TOP_RIGHT] = get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE)
	neighbors[Types.Direction.BOTTOM_LEFT] = get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE)
	neighbors[Types.Direction.BOTTOM_RIGHT] = get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE)
	return neighbors

func get_tile_neighbors_instances(map_pos: Vector2i) -> Dictionary[Types.Direction, Tile]:
	var neighbors_pos = get_tile_neighbors(map_pos)
	var neighbors_instances: Dictionary[Types.Direction, Tile] = {}
	for key in neighbors_pos.keys():
		neighbors_instances[key] = map_to_instance(neighbors_pos[key])
	return neighbors_instances

func map_to_instance(map_pos: Vector2i) -> Tile:
	return map_to_scene_mat.get(map_pos, null)

func local_to_instance(local_pos: Vector2) -> Tile:
	var map_pos = local_to_map(local_pos)
	return map_to_scene_mat.get(map_pos, null)

func is_pos_station(map_pos: Vector2i) -> bool:
	var instance = map_to_scene_mat.get(map_pos, null)
	if instance == null:
		return false
	if is_instance_of(instance, DefenceTower):
		return true
	if is_instance_of(instance, StationTile):
		return true
	return false
