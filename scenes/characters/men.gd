class_name Man extends Node2D

var curr_dest: Vector2
var curr_dest_idx: int = 0
var dest_array: Array[Tile]
var has_dest: bool = false

var camp_tile: StationTile
var coin_tile: StationTile
var shrine_tile: StationTile
var speed: float = 300.0
var curr_state: State = State.IDLE
var job: Job
var target_reachable: bool = false

const SPEED_MODIFIER: float  = 0
const TO_SLEEP_SPEED: float  = 700.0

var on_link: bool = false
var link_exit: Vector2 = Vector2.ZERO

var carry: bool = false


@onready var nav_agent_timer: Timer = $NavAgentTimer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

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
	navigation_agent_2d.link_reached.connect(_on_link_reached)
	self.curr_state = State.WORKING
	if len(dest_array) > 0:
		if is_instance_valid(dest_array[0]):
			curr_dest = dest_array[0].global_position
			_refresh_agent()

func _is_in_active_state() -> bool:
	if self.curr_state in [State.IN_CAMP, State.DEAD, State.IDLE]:
		return false
	
	return true

func _refresh_agent() -> void:
	if _is_in_active_state() and not target_reachable:
		target_reachable = true
		navigation_agent_2d.target_position = curr_dest

func _physics_process(delta: float) -> void:
	if not _is_in_active_state():
		return

	var target_point: Vector2
	if on_link and curr_state == State.WORKING:
		# Move toward the link exit instead of next path point
		target_point = link_exit
	else:
		# Normal path following
		target_point = navigation_agent_2d.get_next_path_position()

	var direction = target_point - global_position
	if direction.length() > 10.0:
		direction = direction.normalized()
		var walk_speed: float = TO_SLEEP_SPEED if curr_state == State.TO_SLEEP else speed
		global_position += direction * walk_speed * delta

		var carry_walk: String = "carry" if carry else "walk"
		animated_sprite.animation = carry_walk+"_back" if direction.y < 0 else carry_walk+"_front"
		if not animated_sprite.is_playing():
			animated_sprite.play()
		if not animation_player.is_playing():
			animation_player.play("walk")
	else:
		# Target reached
		if on_link:
			on_link = false  # link finished, resume normal path
		elif curr_dest.direction_to(self.global_position).length() <= 100.0:
			if curr_state == State.TO_SLEEP:
				sleep()
				return
			if navigation_agent_2d.is_target_reachable():
				if curr_dest_idx + 1 >= len(dest_array):
					if carry:
						camp_tile.add_resource(1)
					curr_dest_idx = 0
					carry = false
				else:
					if curr_dest_idx == 0:
						carry = true
					curr_dest_idx += 1
				_set_destination()

		if animation_player.is_playing():
			animation_player.stop()
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
	if is_instance_valid(dest_array[curr_dest_idx]):
		curr_dest = dest_array[curr_dest_idx].global_position
		navigation_agent_2d.target_position = curr_dest

func sleep() -> void:
	curr_state = State.IN_CAMP
	carry = false
	self.hide()

func awake() -> void:
	curr_state = State.WORKING
	carry = false
	self.show()

func go_to_camp() -> void:
	self.curr_state = State.TO_SLEEP
	self.curr_dest_idx = -1
	carry = false
	curr_dest = camp_tile.global_position
	navigation_agent_2d.target_position = curr_dest

func _on_link_reached(details: Dictionary) -> void:
	if details.get("link_exit_position"):
		on_link = true
		link_exit = details.get("link_exit_position")
