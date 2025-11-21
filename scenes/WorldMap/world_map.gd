class_name WorldMap extends TileMapLayer

var map_to_scene_mat: Dictionary
var init_cell_added: bool = false

func _ready() -> void:
	TileCreationEmmiter.tile_created.connect(_on_tile_created)
	TileCreationEmmiter.station_tile_created.connect(_on_tile_created)

func _set_map() -> void:
	self.map_to_scene_mat = Dictionary()
	for child: Node2D in self.get_children():
		var map_pos = self.local_to_map(child.position)
		self.map_to_scene_mat.set(str(map_pos), child)
	init_cell_added = true

func _process(_delta: float) -> void:
	if not init_cell_added:
		_set_map()

func _on_tile_created(tile: Tile) -> void:
	self._register_new_tile(tile)

func _register_new_tile(tile: Tile) -> void:
	map_to_scene_mat.set(str(local_to_map(tile.position)), tile)

func get_tile_neighbors(map_pos: Vector2i) -> Dictionary[Types.Direction, Vector2i]:
	var neighbors: Dictionary[Types.Direction, Vector2i] = {}
	neighbors.set(Types.Direction.TOP_LEFT, self.get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE))
	neighbors.set(Types.Direction.TOP_RIGHT, self.get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE))
	neighbors.set(Types.Direction.BOTTOM_LEFT, self.get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE))
	neighbors.set(Types.Direction.BOTTOM_RIGHT, self.get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE))
	
	return neighbors

func get_tile_neighbors_instances(map_pos: Vector2i) -> Dictionary[Types.Direction, Tile]:
	var neighbors_pos: Dictionary[Types.Direction, Vector2i] = get_tile_neighbors(map_pos)
	var neighbors: Dictionary[Types.Direction, Tile] = {}
	
	for key in neighbors_pos.keys():
		neighbors.set(key, map_to_instance(neighbors_pos.get(key)))
	
	return neighbors

func map_to_instance(map_pos: Vector2i) -> Tile:
	return self.map_to_scene_mat.get(str(map_pos))

func local_to_instance(local_pos: Vector2) -> Tile:
	var map_pos = self.local_to_map(local_pos)
	return self.map_to_scene_mat.get(str(map_pos))

func set_tile(map_pos: Vector2i, tile_id: int, tile_type: Types.Tile) -> void:
	self.set_cell(map_pos, Consts.TYPE_ATLAS[tile_type], Vector2i.ZERO, tile_id)

func set_available_tile(map_pos: Vector2i):
	self.set_cell(map_pos, 0, Vector2i.ZERO, 0)

func remove_tile(map_pos: Vector2i):
	self.set_cell(map_pos)
	self.map_to_scene_mat.erase(str(map_pos))

func is_pos_station(map_pos: Vector2i) -> bool:
	var instance: Tile = map_to_scene_mat.get(str(map_pos))
	return is_instance_valid(instance) and is_instance_of(instance, StationTile)
