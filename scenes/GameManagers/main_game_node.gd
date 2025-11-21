class_name MainGameNode extends Node2D

@onready var tile_manager: TileManager = $TileManager
@onready var h_box_container: HBoxContainer = $HUD/HBoxContainer
@onready var world_map: WorldMap = $WorldMap
@onready var background_canvas: BackgroundCanvas = $Background
@onready var guys_node: Node2D = $Guys
@onready var portal_manager: PortalManager = $PortalManager

@export var modulate_curve: Curve

var current_tile: Types.Tile
var tiles_signal_connected: bool = false
var buttons: Array[SelectTextureButton]

# night modulate vars
var modulate_progress: float
var current_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var target_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var transition_speed: float = 0.3 

func _ready() -> void:
	TileCreationEmmiter.tile_created.connect(_on_tile_created)
	DayCycleManager.night_started.connect(_on_night_start)
	DayCycleManager.day_started.connect(_on_day_start)
	for node: Node in h_box_container.get_children():
		var button: SelectTextureButton = node
		buttons.append(button)
		button.pressed_texture.connect(_on_texture_button_press)

func _connect_empty_tiles_signal() -> void:
	if tiles_signal_connected:
		return
	
	for child in world_map.get_children():
		var empty_tile: Tile = child
		if not empty_tile.tile_pressed.is_connected(_on_tile_pressed):
			empty_tile.tile_pressed.connect(_on_tile_pressed)
	
	tiles_signal_connected = true

func _on_texture_button_press(tile_type: Types.Tile) -> void:
	self.current_tile = tile_type

func _process(delta: float) -> void:
	if not tiles_signal_connected:
		_connect_empty_tiles_signal()
	
	_process_color_transition(delta)

func _input(event: InputEvent) -> void:
	pass

func _on_tile_created(tile: Tile) -> void:
	tile.tile_pressed.connect(_on_tile_pressed)
	tile.tile_secondary_pressed.connect(_on_tile_secondary_pressed)

func _on_tile_pressed(tile: Tile) -> void:
	if is_instance_of(tile, AvailableTile):
		_create_tile(tile.position)

func _on_tile_secondary_pressed(tile: Tile) -> void:
	if tile.tile_type == Types.Tile.AVAILABLE_TILE:
		return
	_remove_tile(tile)

func _remove_tile(tile: Tile) -> void:
	tile_manager.remove_tile(tile)

func _create_tile(tile_position: Vector2) -> void:
	var map_pos: Vector2i = world_map.local_to_map(tile_position)
	tile_manager.place_tile(map_pos, self.current_tile)

func _process_color_transition(delta: float) -> void:
	self.modulate_progress += transition_speed * delta
	self.modulate_progress = clamp(modulate_progress, 0.0, 1.0)
	var t = modulate_curve.sample(modulate_progress)
	
	current_color = current_color.lerp(target_color, t)
	self.modulate = current_color

func _on_day_start() -> void:
	_toggle_day_visuals(true)
	_wake_guys()

func _on_night_start() -> void:
	_toggle_day_visuals(false)
	_call_guys_home()
	portal_manager.start_spawning(10)

func _wake_guys() -> void:
	for guy: SimpleGuy in guys_node.get_children():
		guy.awake()

func _call_guys_home() -> void:
	for guy: SimpleGuy in guys_node.get_children():
		guy.go_to_camp()

func _toggle_day_visuals(day: bool) -> void:
	if not day:
		background_canvas.switch_night()
		self.target_color = Color(0.439, 0.439, 0.439, 1.0)
	else:
		background_canvas.switch_day()
		self.target_color = Color(1.0, 1.0, 1.0, 1.0)
	
	self.modulate_progress = 0.0


func _on_button_2_pressed() -> void:
	tile_manager.randomize_camp()
