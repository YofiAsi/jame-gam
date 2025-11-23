class_name MainMenu extends Node2D

@onready var volume: VSlider = $CanvasLayer/HBoxContainer/VolumeSlider

func _on_start_button_pressed() -> void:
	SceneManager.change_scene(
		"res://scenes/GameManagers/GameRoot/GameRoot.tscn", {
			"pattern_enter": "squares",
			"pattern_leave": "squares",
		}
	)

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
