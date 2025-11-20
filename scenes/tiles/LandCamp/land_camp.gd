class_name LandCamp extends StationTile

@onready var spawn_timer: Timer = $SpawnTimer

var simple_guy: PackedScene = preload("uid://koj7f8trhfju")

func _ready() -> void:
	super._ready()
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
func _process(delta: float) -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	var guy_node: SimpleGuy = simple_guy.instantiate()
	guy_node.global_position = self.global_position
	get_node("/root/Prototype/Guys").add_child(guy_node)
