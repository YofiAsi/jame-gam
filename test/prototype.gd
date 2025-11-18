extends Node2D

var current_texture: Texture
var tiles_signal_connected: bool = false
@onready var h_box_container: HBoxContainer = $CanvasLayer/HBoxContainer
var buttons: Array[SelectTextureButton]
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect
@onready var main_tile_map_layer: MapLayerE = $MainTileMapLayer

@export var tile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TileManager.tile_created.connect(_on_tile_created)
	for node: Node in h_box_container.get_children():
		var button: SelectTextureButton = node
		buttons.append(button)
		button.pressed_texture.connect(_on_texture_button_press)

func _connect_empty_tiles_signal() -> void:
	if tiles_signal_connected:
		return
	
	for child in main_tile_map_layer.get_children():
		var empty_tile: Tile = child
		if not empty_tile.tile_pressed.is_connected(_on_tile_pressed):
			empty_tile.tile_pressed.connect(_on_tile_pressed)
	
	tiles_signal_connected = true

func _on_texture_button_press(texture: Texture) -> void:
	self.current_texture = texture
	texture_rect.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not tiles_signal_connected:
		_connect_empty_tiles_signal()

func _on_tile_created(tile: Tile) -> void:
	tile.tile_pressed.connect(_on_tile_pressed)

func _on_tile_pressed(tile: Tile) -> void:
	if is_instance_of(tile, EmptyTile):
		_create_tile(tile.position, self.current_texture)
	
func _create_tile(tile_position: Vector2, texture: Texture) -> void:
	var map_pos: Vector2i = main_tile_map_layer.local_to_map(tile_position)
	main_tile_map_layer.set_cell(map_pos, 0, Vector2i.ZERO, 2)
	_create_empty_tile_neighbors(map_pos)

func _get_tile_neighbors(map_pos: Vector2i) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []
	neighbors.append(main_tile_map_layer.get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE))
	neighbors.append(main_tile_map_layer.get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE))
	neighbors.append(main_tile_map_layer.get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE))
	neighbors.append(main_tile_map_layer.get_neighbor_cell(map_pos, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE))
	
	return neighbors

func _create_empty_tile_neighbors(map_pos: Vector2i) -> void:
	var neighbors := _get_tile_neighbors(map_pos)

	for neighbor in neighbors:
		if not main_tile_map_layer.map_to_scene_mat.has(str(neighbor)):
			main_tile_map_layer.set_cell(neighbor, 0, Vector2i.ZERO, 3)
	
	
