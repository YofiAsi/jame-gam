class_name SelectTextureButton extends TextureButton

signal pressed_texture(texture: Texture)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	self.set_modulate(Color("999999"))
	self.pressed.connect(_on_pressed)

func _on_mouse_entered() -> void:
	self.set_modulate(Color("ffffffff"))
	
func _on_mouse_exited() -> void:
	self.set_modulate(Color("999999"))

func _on_pressed() -> void:
	self.pressed_texture.emit(self.texture_normal)
