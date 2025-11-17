extends Node2D

var hover_movement: float = 5
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	sprite_2d.position += Vector2.UP * hover_movement


func _on_area_2d_mouse_exited() -> void:
	self._reset_position()


func _reset_position() -> void:
	sprite_2d.position = Vector2.ZERO


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		self._reset_position()
