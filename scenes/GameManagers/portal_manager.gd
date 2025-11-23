class_name PortalManager
extends Node2D

@export var demon_scene: PackedScene
@export var demons_node: Node2D

@onready var spawn_timer: Timer = $SpawnTimer

var dead_demons: int = 0
var target_demons: int = 0 
var is_active: bool = false

func start_spawning(amount: int, radius: float = 0.0) -> void:
	spawn_timer.start()
	is_active = true
	dead_demons = 0
	target_demons = amount
	
	for _i in range(amount):
		if spawn_timer.paused:
			return
		
		_spawn_demon(radius)
		spawn_timer.start()
		
		await spawn_timer.timeout
		if spawn_timer.paused:
			return

func _spawn_demon(radius: float) -> void:
	var point := Vector2.ZERO
	
	# Add a random offset within the radius
	if radius > 0:
		var angle = randf() * TAU  # Random angle in radians
		var distance = radius  # Uniform distribution in circle
		var offset = Vector2(cos(angle), sin(angle)) * distance
		point += offset
	
	# Instantiate and add demon
	var demon_instance: Demon = demon_scene.instantiate()
	demon_instance.global_position = point
	demons_node.add_child(demon_instance)
	demon_instance.dead.connect(_on_demon_dead)

func _on_demon_dead() -> void:
	dead_demons += 1
	if dead_demons >= target_demons and is_active:
		is_active = false
		DayCycleManager.no_demons()

func stop_spawning() -> void:
	spawn_timer.stop()
	is_active = false
