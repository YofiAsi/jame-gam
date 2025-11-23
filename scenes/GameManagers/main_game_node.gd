class_name MainGameNode extends Node2D

@onready var tile_manager: TileManager = $TileManager
@onready var h_box_container: HBoxContainer = $HUD/HBoxContainer
@onready var world_map: WorldMap = $WorldMap
@onready var background_canvas: BackgroundCanvas = $Background
@onready var guys_node: Node2D = $Guys
@onready var portal_manager: PortalManager = $PortalManager
@onready var day_cycle_timer: Timer = $DayCycleTimer
@onready var spawn_camp_timer: Timer = $SpawnCampTimer
@onready var spawn_demons_timer: Timer = $SpawnDemonsTimer

@onready var pause_button: TextureButton = $HUD/PauseContainer/PauseButton
@onready var buy_button_container: TileBuyContainer = $HUD/BuyButtonContainer
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@export var modulate_curve: Curve

var tile_sound: AudioStream = preload("uid://hqvv7kuu124c")
const DEMON_CLICK = preload("uid://c0evogvo6gn8c")

var tiles_signal_connected: bool = false
var buttons: Array[SelectTextureButton]

var game_raduis: int = 3
var min_dis: int = 3:
	set(value):
		min_dis = value
var max_dis: int = 4
var camps: int = 0

# night modulate vars
var modulate_progress: float
var current_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var target_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var spawn_land: bool = true

func _ready() -> void:
	pause_button.pressed.connect(func(): 
		Input.action_press("pause")
	)
	buy_button_container.buy_camp.connect(_on_camp_buy)
	
	TileCreationEmmiter.tile_created.connect(_on_tile_created)
	DayCycleManager.night_started.connect(_on_night_start)
	DayCycleManager.day_started.connect(_on_day_start)

func _connect_empty_tiles_signal() -> void:
	if tiles_signal_connected:
		return
	
	for child in world_map.get_children():
		var empty_tile: Tile = child
		if not empty_tile.tile_pressed.is_connected(_on_tile_pressed):
			empty_tile.tile_pressed.connect(_on_tile_pressed)
	
	tiles_signal_connected = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("money"):
		FoodManager.add_food(99999)
		CurrencyManager.add_money(99999)
	if Input.is_action_just_pressed("cycle_toggle"):
		DayCycleManager._day_switch()
	
	
	if not tiles_signal_connected:
		_connect_empty_tiles_signal()
	
	_process_color_transition(delta)

func _on_tile_created(tile: Tile) -> void:
	tile.tile_pressed.connect(_on_tile_pressed)
	tile.tile_secondary_pressed.connect(_on_tile_secondary_pressed)

func _on_tile_pressed(tile: Tile) -> void:
	if is_instance_of(tile, AvailableTile):
		_create_tile(tile.position)

func _on_tile_secondary_pressed(tile: Tile) -> void:
	if not DayCycleManager.is_day:
		return
	if tile.tile_type == Types.Tile.AVAILABLE_TILE:
		return
	_remove_tile(tile)

func _remove_tile(tile: Tile) -> void:
	tile_manager.remove_tile(tile)
	_create_tile_audio(DEMON_CLICK)
	var refund: int = buy_button_container.COST[tile.tile_type]
	CurrencyManager.add_money(refund)
	

func _create_tile(tile_position: Vector2) -> void:
	if not CurrencyManager.buy(buy_button_container.COST[buy_button_container.curr_buy]):
		return
	var map_pos: Vector2i = world_map.local_to_map(tile_position)
	tile_manager.place_tile(map_pos, buy_button_container.curr_buy)
	_create_tile_audio(tile_sound)

func _create_tile_audio(sound: AudioStream) -> void:
	var node: AudioStreamPlayer = AudioStreamPlayer.new()
	node.stream = sound
	node.bus = "SFX"
	add_child(node)
	node.finished.connect(func(): node.queue_free())
	node.play()

func _process_color_transition(delta: float) -> void:
	self.modulate_progress += Consts.NIGHT_TRANSITION_SPEED * delta
	self.modulate_progress = clamp(modulate_progress, 0.0, 1.0)
	var t = modulate_curve.sample(modulate_progress)
	
	current_color = current_color.lerp(target_color, t)
	canvas_modulate.color = current_color

func _on_day_start() -> void:
	_toggle_day_visuals(true)
	portal_manager.stop_spawning()
	_kill_all_demons()
	
	spawn_demons_timer.start()
	await spawn_demons_timer.timeout
	_wake_guys()

func _on_night_start() -> void:
	_toggle_day_visuals(false)
	_call_guys_home()
	spawn_demons_timer.start()
	await spawn_demons_timer.timeout
	portal_manager.start_spawning(10, world_map.map_to_local(Vector2i(game_raduis + 3, 0)).length())

func _wake_guys() -> void:
	for camp: Camp in get_tree().get_nodes_in_group("camp"):
		camp.wake_guys()

func _call_guys_home() -> void:
	for guy: Man in guys_node.get_children():
		guy.go_to_camp()

func _toggle_day_visuals(day: bool) -> void:
	if not day:
		background_canvas.switch_night()
		self.target_color = Color(0.439, 0.439, 0.439, 1.0)
	else:
		background_canvas.switch_day()
		self.target_color = Color(1.0, 1.0, 1.0, 1.0)
	
	self.modulate_progress = 0.0

func _kill_all_demons() -> void:
	for demon in $Demons.get_children():
		demon.queue_free()

func _on_button_pressed() -> void:
	DayCycleManager._timer_timeout()

func _on_camp_buy(land: bool, cost: int) -> void:
	if not FoodManager.buy(cost):
		return
	
	if camps == 0: 
		DayCycleManager.start_cycle()
	
	if land:
		tile_manager.randomize_land_camp(game_raduis, min_dis, max_dis)
	else:
		tile_manager.randomize_water_camp(game_raduis, min_dis, max_dis)
	
	#if camps % 2  == 0:
	if camps % 3 == 0:
		game_raduis += 1
		min_dis += 1
		max_dis += 1
	
	min_dis = min(min_dis, 5)
	max_dis = min(max_dis, 6)
	camps += 1
	
func station_die(station: StationTile, is_camp: bool) -> void:
	if is_camp:
		camps -= 1
	tile_manager.set_boulder(world_map.local_to_map(station.position))
