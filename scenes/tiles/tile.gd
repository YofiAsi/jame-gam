class_name Tile extends Node2D

signal tile_pressed(node: Tile)
signal tile_secondary_pressed(node: Tile)

@onready var sprite: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	self.area_2d.input_event.connect(_on_area_2d_input_event)
	self.area_2d.mouse_entered.connect(_on_mouse_entered)
	self.area_2d.mouse_exited.connect(_on_mouse_exited)
	TileManager.emit_tile_creation(self)

func _process(_delta: float) -> void:
	pass

func set_texture(texture: Texture) -> void:
	sprite.texture = texture

func _on_mouse_entered() -> void:
	pass

func _on_mouse_exited() -> void:
	pass

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		tile_pressed.emit(self)
	if event.is_action_pressed("right_click"):
		tile_secondary_pressed.emit(self)
