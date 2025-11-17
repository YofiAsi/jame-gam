extends TileMapLayer
class_name MapLayerE

var map_to_scene_mat: Dictionary
var a = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_map() -> void:
	self.map_to_scene_mat = Dictionary()
	for child: Node2D in self.get_children():
		var map_pos = self.local_to_map(child.position)
		self.map_to_scene_mat.set(str(map_pos), child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if a:
		set_map()
		a = false
		
	
func local_to_scene(local_pos: Vector2) -> Node2D:
	var map_pos = self.local_to_map(local_pos)
	return self.map_to_scene_mat.get(str(map_pos))
