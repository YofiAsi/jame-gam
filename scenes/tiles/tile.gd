class_name Tile extends Node2D

signal tile_pressed(node: Tile)
signal tile_secondary_pressed(node: Tile)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var empty_sprite: Sprite2D = $EmptySprite

var is_empty: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.hide()
	empty_sprite.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_texture(texture: Texture) -> void:
	sprite_2d.texture = texture

func _on_area_2d_mouse_entered() -> void:
	if is_empty:
		self._brighten_sprite()
	
func _on_area_2d_mouse_exited() -> void:
	self._reset_sprite()

func _brighten_sprite() -> void:
	empty_sprite.set_modulate(Color("ffffff64"))

func _reset_sprite() -> void:
	empty_sprite.set_modulate(Color("ffffff1e"))

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		tile_pressed.emit(self)
	if event.is_action_pressed("right_click"):
		tile_secondary_pressed.emit(self)
		deactivate_tile()

func deactivate_tile() -> void:
	self.is_empty = true
	set_texture(null)
	sprite_2d.hide()
	empty_sprite.show()

func activate_tile(texture: Texture) -> void:
	self.is_empty = false
	set_texture(texture)
	sprite_2d.show()
	empty_sprite.hide()
