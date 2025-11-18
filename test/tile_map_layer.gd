extends TileMapLayer
class_name MapLayerE

var map_to_scene_mat: Dictionary
var init_cell_added: bool = false

func _ready() -> void:
	TileManager.tile_created.connect(_on_tile_created)

func set_map() -> void:
	self.map_to_scene_mat = Dictionary()
	for child: Node2D in self.get_children():
		var map_pos = self.local_to_map(child.position)
		self.map_to_scene_mat.set(str(map_pos), child)
	init_cell_added = true

func _process(_delta: float) -> void:
	if not init_cell_added:
		set_map()
		
func local_to_scene(local_pos: Vector2) -> Node2D:
	var map_pos = self.local_to_map(local_pos)
	return self.map_to_scene_mat.get(str(map_pos))

func _on_tile_created(tile: Tile) -> void:
	self._register_new_tile(tile)

func _register_new_tile(tile: Tile) -> void:
	map_to_scene_mat.set(str(local_to_map(tile.position)), tile)
