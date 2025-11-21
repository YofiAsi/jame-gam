extends CanvasLayer

@onready var button: Button = $Button

func _ready() -> void:
	button.pressed.connect(_daynight_button_pressed)

func _daynight_button_pressed() -> void:
	DayCycleManager.day_switch()
