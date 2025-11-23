class_name SelectTextureButton extends TextureButton

signal pressed_texture(tile_type: Types.Tile)

@export var tile_type: Types.Tile

var toggle: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	self.set_modulate(Color("999999"))
	self.pressed.connect(_on_pressed)

func _on_mouse_entered() -> void:
	bright()
	
func _on_mouse_exited() -> void:
	if toggle:
		return
	dark()

func bright() -> void:
	self.set_modulate(Color("ffffffff"))

func dark() -> void:
	self.set_modulate(Color("999999"))

func _on_pressed() -> void:
	self.pressed_texture.emit(tile_type)
