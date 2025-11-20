class_name MainGameNode extends Node2D

@onready var tile_manager: TileManager = $TileManager
@onready var h_box_container: HBoxContainer = $HUD/HBoxContainer
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect
@onready var main_tile_map_layer: WorldMap = $WorldMap

@export var tile: PackedScene

var current_tile: Types.Tile
var tiles_signal_connected: bool = false
var buttons: Array[SelectTextureButton]


func _ready() -> void:
	TileCreationEmmiter.tile_created.connect(_on_tile_created)
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

func _on_texture_button_press(tile_type: Types.Tile) -> void:
	self.current_tile = tile_type

func _process(_delta: float) -> void:
	if not tiles_signal_connected:
		_connect_empty_tiles_signal()

func _input(event: InputEvent) -> void:
	pass

func _on_tile_created(tile: Tile) -> void:
	tile.tile_pressed.connect(_on_tile_pressed)

func _on_tile_pressed(tile: Tile) -> void:
	if is_instance_of(tile, AvailableTile):
		_create_tile(tile.position)
	
func _create_tile(tile_position: Vector2) -> void:
	var map_pos: Vector2i = main_tile_map_layer.local_to_map(tile_position)
	tile_manager.place_tile(map_pos, self.current_tile)
	
