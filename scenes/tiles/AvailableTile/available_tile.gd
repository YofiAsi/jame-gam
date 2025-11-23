class_name AvailableTile extends Tile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_reset_sprite()
	DayCycleManager.night_started.connect(disable_self)
	DayCycleManager.day_started.connect(show_self)
	self.area_2d.mouse_entered.connect(_on_area_2d_mouse_entered)
	self.area_2d.mouse_exited.connect(_on_area_2d_mouse_exited)

func disable_self() -> void:
	self.hide()

func show_self() -> void:
	self.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _brighten_sprite() -> void:
	sprite.set_modulate(Color("ffffffff"))

func _reset_sprite() -> void:
	sprite.set_modulate(Color("ffffff87"))

func _on_area_2d_mouse_entered() -> void:
	self._brighten_sprite()
	
func _on_area_2d_mouse_exited() -> void:
	self._reset_sprite()
