class_name SimpleGuy extends Node2D

var curr_dest: Vector2
var curr_dest_idx: int = 0
var dest_array: Array[Tile]
var has_dest: bool = false

@export var camp_tile: LandCamp
@export var coin_tile: LandCoin
@export var shrine_tile: LandShrine
@export var speed: float = 500.0

@onready var nav_agent_timer: Timer = $NavAgentTimer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not self.has_dest:
		_find_destinations()
		dest_array = [coin_tile, shrine_tile, camp_tile]
		self.curr_dest = dest_array[curr_dest_idx].global_position
		_set_destination()
		self.has_dest = true
	
	if navigation_agent_2d.is_target_reached():
		if self.curr_dest_idx + 1 >= len(dest_array):
			self.queue_free()
		else:
			self.curr_dest_idx += 1
			_set_destination()
	
	var next_point = navigation_agent_2d.get_next_path_position()
	var direction = (next_point - global_position)

	if direction.length() > 10.0:
		direction = direction.normalized()
		global_position += direction * speed * delta

func _find_destinations() -> void:
	if not is_instance_valid(coin_tile):
		coin_tile = get_node("/root/Prototype/WorldMap/LandCoin")
	if not is_instance_valid(shrine_tile):
		shrine_tile = get_node("/root/Prototype/WorldMap/LandShrine")
	if not is_instance_valid(camp_tile):
		camp_tile = get_node("/root/Prototype/WorldMap/LandCamp")

func _set_destination() -> void:
	self.curr_dest = dest_array[curr_dest_idx].global_position
	navigation_agent_2d.target_position = self.curr_dest
