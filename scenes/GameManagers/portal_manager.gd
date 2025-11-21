class_name PortalManager extends Node2D

@export var demon_scene: PackedScene
@export var demons_node: Node2D

@onready var path_2d: Path2D = $Path2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var spawn_timer: Timer = $SpawnTimer

func start_spawning(amount: int) -> void:
	for _i in range(amount):
		_spawn_demon()
		spawn_timer.start()
		await spawn_timer.timeout

func _spawn_demon() -> void:
	path_follow.progress_ratio = randf()
	var point := path_follow.global_position
	
	var demon_instance: Demon = demon_scene.instantiate()
	demon_instance.global_position = point
	demons_node.add_child(demon_instance)
