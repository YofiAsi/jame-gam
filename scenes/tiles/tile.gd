class_name Tile extends Node2D

signal tile_pressed(node: Tile)
signal tile_secondary_pressed(node: Tile)

@export var tile_type: Types.Tile

@onready var sprite: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	self.area_2d.input_event.connect(_on_area_2d_input_event)
	self.area_2d.mouse_entered.connect(_on_mouse_entered)
	self.area_2d.mouse_exited.connect(_on_mouse_exited)
	TileCreationEmmiter.emit_tile_creation(self)

func _process(_delta: float) -> void:
	pass

func set_texture(texture: Texture) -> void:
	sprite.texture = texture

func _on_mouse_entered() -> void:
	if Input.is_action_pressed("click"):
		tile_pressed.emit(self)

func _on_mouse_exited() -> void:
	pass

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		tile_pressed.emit(self)
	if event.is_action_pressed("right_click"):
		tile_secondary_pressed.emit(self)

func enable_navigation_links() -> void:
	var links: Node = self.find_child("NavigationLinks")
	if is_instance_valid(links):
		for link: NavigationLink2D in links.get_children():
			link.enabled = true
		
	var nav_region: NavigationRegion2D = self.find_child("NavigationRegion2D")
	if is_instance_valid(nav_region):
		nav_region.enabled = true

func disable_navigation_links() -> void:
	var links: Node = self.find_child("NavigationLinks")
		
	if is_instance_valid(links):
		for link: NavigationLink2D in links.get_children():
			link.enabled = false
	
	var nav_region: NavigationRegion2D = self.find_child("NavigationRegion2D")
	if is_instance_valid(nav_region):
		nav_region.enabled = true
