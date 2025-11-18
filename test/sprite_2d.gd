extends Sprite2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var speed := 200.0

func _ready() -> void:
	navigation_agent_2d.target_position = Vector2(1000, 1060)

func _process(delta: float) -> void:
	if not navigation_agent_2d.is_target_reachable():
		return
	var next_point = navigation_agent_2d.get_next_path_position()
	var direction = (next_point - global_position)

	if direction.length() > 10.0:
		direction = direction.normalized()
		global_position += direction * speed * delta
