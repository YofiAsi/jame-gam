extends CanvasLayer

@onready var music: HSlider = $VBoxContainer/VBoxContainer/Music/MusicSlider
@onready var sfx: HSlider = $VBoxContainer/VBoxContainer/SXF/SfxSlider

func _ready():
	# Configure the sliders to match the volume range (-30 to 6 dB)
	music.min_value = -30
	music.max_value = 6
	music.value = clamp(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")), -30, 6)
	
	sfx.min_value = -30
	sfx.max_value = 6
	sfx.value = clamp(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")), -30, 6)
	
	music.value_changed.connect(_on_music_value_changed)
	sfx.value_changed.connect(_on_sfx_value_changed)

func _on_music_value_changed(value: float) -> void:
	if value <= music.min_value:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)  # -inf in dB to mute
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_sfx_value_changed(value: float) -> void:
	if value <= sfx.min_value:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)  # -inf in dB to mute
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
