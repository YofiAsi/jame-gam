class_name MainMenu extends Node2D

@export var fade_out_speed: float = 0.3
@export var fade_in_speed: float = 0.3
@export var fade_out_pattern: String = "fade"
@export var fade_in_pattern: String = "fade"
@export var fade_out_smoothness = 0.1 # (float, 0, 1)
@export var fade_in_smoothness = 0.1 # (float, 0, 1)
@export var fade_out_inverted: bool = false
@export var fade_in_inverted: bool = false
@export var color: Color = Color(0, 0, 0)
@export var timeout: float = 0.0
@export var clickable: bool = false
@export var add_to_back: bool = true

@onready var fade_out_options = SceneManager.create_options(fade_out_speed, fade_out_pattern, fade_out_smoothness, fade_out_inverted)
@onready var fade_in_options = SceneManager.create_options(fade_in_speed, fade_in_pattern, fade_in_smoothness, fade_in_inverted)
@onready var general_options = SceneManager.create_general_options(color, timeout, clickable, add_to_back)

@onready var volume: HSlider = $CanvasLayer/Title2/HBoxContainer/VolumeSlider

func _on_start_button_pressed() -> void:
	SceneManager.change_scene("GameRoot", fade_out_options, fade_in_options, general_options)

func _ready():
	AudioManager.play_main_song()
	# Configure the sliders to match the volume range (-30 to 6 dB)
	volume.min_value = -30
	volume.max_value = 6
	volume.value = clamp(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")), -30, 6)
	
	volume.value_changed.connect(_on_music_value_changed)

func _on_music_value_changed(value: float) -> void:
	if value <= volume.min_value:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)  # -inf in dB to mute
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)  # -inf in dB to mute
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
