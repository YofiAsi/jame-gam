class_name BackgroundCanvas extends CanvasLayer

@onready var shader_material: ShaderMaterial = $TextureRect.material
@export var curve: Curve

var target_color0: Color
var target_color1: Color
var current_color0: Color
var current_color1: Color
 # Adjust speed as needed
var progress: float = 0.0

func _ready() -> void:
	target_color0 = Color(0.53, 0.81, 0.92, 1.0)
	target_color1 = Color(0.27, 0.58, 0.80, 1.0)
	
	self.current_color0 = shader_material.get_shader_parameter("color0")
	self.current_color1 = shader_material.get_shader_parameter("color1")
	
	target_color0 = self.current_color0
	target_color1 = self.current_color1

func switch_night() -> void:
	self.progress = 0.0
	target_color0 = Color("21346eff")
	target_color1 = Color("122664ff")

func switch_day() -> void:
	self.progress = 0.0
	target_color0 = Color(0.53, 0.81, 0.92, 1.0)
	target_color1 = Color(0.27, 0.58, 0.80, 1.0)

func _process(delta):
	self.progress += Consts.NIGHT_TRANSITION_SPEED * delta
	self.progress = clamp(progress, 0.0, 1.0)
	var t = curve.sample(progress)
	
	# Smoothly interpolate the current colors toward the target colors
	current_color0 = current_color0.lerp(target_color0, t)
	current_color1 = current_color1.lerp(target_color1, t)

	# Update the shader with the interpolated colors
	shader_material.set_shader_parameter("color0", current_color0)
	shader_material.set_shader_parameter("color1", current_color1)
