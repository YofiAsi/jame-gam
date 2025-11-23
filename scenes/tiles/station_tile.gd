class_name StationTile extends Tile

const SPAWN_ANIMATION = preload("uid://c6kf0003ko84k")

func set_color(c: Color) -> void:
	var circle: Circle = get_node("Circle")
	circle.set_color(c)
	
func _ready() -> void:
	super._ready()
	AudioManager.tiles_places_3.play()
	var spawn_animation_player: AnimatedSprite2D = SPAWN_ANIMATION.instantiate()
	add_child(spawn_animation_player)
	spawn_animation_player.position.y -= 100
	spawn_animation_player.animation_finished.connect(func(): spawn_animation_player.queue_free())
	spawn_animation_player.play("spawn")

func die() -> void:
	var game_node: MainGameNode = get_tree().get_nodes_in_group("game_node")[0]
	game_node.station_die(self, is_instance_of(self, Camp))
