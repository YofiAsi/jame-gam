class_name Man extends Node2D

var curr_dest: Vector2
var curr_dest_idx: int = 0
var dest_array: Array[Tile]
var has_dest: bool = false

var camp_tile: StationTile
var coin_tile: StationTile
var shrine_tile: StationTile
var speed: float = 500.0
var curr_state: State = State.IDLE
var job: Job
var target_reachable: bool = false

const SPEED_MODIFIER: float  = 100.0
const TO_SLEEP_SPEED: float  = 800.0

@onready var nav_agent_timer: Timer = $NavAgentTimer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: Sprite2D = $Sprite2D

enum State {
	IDLE,
	WORKING,
	TO_SLEEP,
	IN_CAMP,
	DEAD,
}

enum Job {
	COIN,
	FOOD
}

func _ready() -> void:
	self.speed += randf_range(-1.0, 1.0) * SPEED_MODIFIER
	nav_agent_timer.timeout.connect(_refresh_agent)

func _is_in_active_state() -> bool:
	if self.curr_state in [State.IN_CAMP, State.DEAD, State.IDLE]:
		return false
	
	return true

func _refresh_agent() -> void:
	if _is_in_active_state() \
	 and not target_reachable:
		target_reachable = true
		navigation_agent_2d.target_position = curr_dest

func _process(delta: float) -> void:
	if not _is_in_active_state():
		return
	
	if navigation_agent_2d.is_target_reached():
		if self.curr_state == State.TO_SLEEP:
			sleep()
			return

		if self.curr_dest_idx + 1 >= len(dest_array):
			camp_tile.add_resource(1)
			self.curr_dest_idx = 0
		else:
			self.curr_dest_idx += 1
		_set_destination()
	
	var next_point = navigation_agent_2d.get_next_path_position()
	var direction = (next_point - global_position)

	if direction.length() > 10.0:
		direction = direction.normalized()
		
		var walk_speed: float = TO_SLEEP_SPEED if curr_state == State.TO_SLEEP else speed
		global_position += direction * walk_speed * delta
	else:
		if not navigation_agent_2d.is_target_reachable():
			target_reachable = false


func _find_destinations() -> void:
	if not is_instance_valid(coin_tile):
		coin_tile = get_node("/root/MainGameNode/WorldMap/LandCoin")
	if not is_instance_valid(shrine_tile):
		shrine_tile = get_node("/root/MainGameNode/WorldMap/LandShrine")
	if not is_instance_valid(camp_tile):
		camp_tile = get_node("/root/MainGameNode/WorldMap/LandCamp")

func _set_destination() -> void:
	self.curr_dest = dest_array[curr_dest_idx].global_position
	navigation_agent_2d.target_position = self.curr_dest

func sleep() -> void:
	curr_state = State.IN_CAMP
	self.hide()

func awake() -> void:
	curr_state = State.WORKING
	self.show()

func go_to_camp() -> void:
	self.curr_state = State.TO_SLEEP
	self.curr_dest_idx = -1
	
	_set_destination()
