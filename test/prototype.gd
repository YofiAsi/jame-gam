extends Node2D

var current_texture: Texture
var tiles_signal_connected: bool = false
@onready var h_box_container: HBoxContainer = $CanvasLayer/HBoxContainer
var buttons: Array[SelectTextureButton]
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect
@onready var main_tile_map_layer: TileMapLayer = $MainTileMapLayer

@export var tile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node: Node in h_box_container.get_children():
		var button: SelectTextureButton = node
		buttons.append(button)
		button.pressed_texture.connect(_on_texture_button_press)

func _connect_empty_tiles_signal() -> void:
	if tiles_signal_connected:
		return
	
	for child in main_tile_map_layer.get_children():
		var empty_tile: Tile = child
		empty_tile.tile_pressed.connect(_on_tile_pressed)
	
	tiles_signal_connected = true

func _on_texture_button_press(texture: Texture) -> void:
	self.current_texture = texture
	texture_rect.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not tiles_signal_connected:
		_connect_empty_tiles_signal()

func _on_tile_pressed(tile: Tile) -> void:
	tile.activate_tile(self.current_texture)
	
