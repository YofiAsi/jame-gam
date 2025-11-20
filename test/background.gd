extends Node2D


@onready var shader_material: ShaderMaterial = $CanvasLayer/TextureRect.material

func _ready() -> void:
	shader_material.set_shader_parameter("color0", Color(0.53, 0.81, 0.92, 1.0))
	shader_material.set_shader_parameter("color1", Color(0.27, 0.58, 0.80, 1.0))
