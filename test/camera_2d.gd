class_name Camera extends Camera2D

const CAMERA_SPEED: float = 1000
const ZOOM_TICK: float = 0.03
@onready var path_2d: Path2D = $Path2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		self.position += delta * CAMERA_SPEED * Vector2.RIGHT
	if Input.is_action_pressed("left"):
		self.position += delta * CAMERA_SPEED * Vector2.LEFT
	if Input.is_action_pressed("down"):
		self.position += delta * CAMERA_SPEED * Vector2.DOWN
	if Input.is_action_pressed("up"):
		self.position += delta * CAMERA_SPEED * Vector2.UP
	if Input.is_action_just_pressed("wheel_down"):
		self.zoom -= ZOOM_TICK * Vector2.ONE
	if Input.is_action_just_pressed("wheel_up"):
		self.zoom += ZOOM_TICK * Vector2.ONE
