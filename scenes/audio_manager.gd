extends Node

@onready var player_action: Node = $PlayerAction
@onready var demon_click: AudioStreamPlayer = $PlayerAction/Demon_click
@onready var map_hover: AudioStreamPlayer = $PlayerAction/Map_Hover
@onready var tiles_boogle: AudioStreamPlayer = $PlayerAction/TilesBoogle
@onready var tiles_hover: AudioStreamPlayer = $PlayerAction/TilesHover
@onready var tiles_places_1: AudioStreamPlayer = $PlayerAction/TilesPlaces1
@onready var tiles_places_2: AudioStreamPlayer = $PlayerAction/TilesPlaces2
@onready var tiles_places_3: AudioStreamPlayer = $PlayerAction/TilesPlaces3
@onready var tiles_select_grab: AudioStreamPlayer = $PlayerAction/TilesSelectGrab
@onready var ambience: Node = $Ambience
@onready var wind_ambient: AudioStreamPlayer = $Ambience/Wind_ambient
@onready var campfire: AudioStreamPlayer = $Ambience/Campfire
@onready var footsteps: AudioStreamPlayer = $Ambience/Footsteps
@onready var night_ambience: AudioStreamPlayer = $"Ambience/Night-ambience"
@onready var effect: Node = $Effect
@onready var tower_zap: AudioStreamPlayer = $Effect/TowerZap
@onready var coincollected: AudioStreamPlayer = $Effect/Coincollected
@onready var demon_kill: AudioStreamPlayer = $Effect/demon_kill
@onready var prayer_collected: AudioStreamPlayer = $Effect/Prayer_collected
@onready var music: Node = $Music
@onready var main_song: AudioStreamPlayer = $Music/MainSong
@onready var ui: Node = $UI
@onready var slider_thick: AudioStreamPlayer = $UI/SliderThick

func _ready() -> void:
	pass

func play_main_song() -> void:
	$Music/MainSong.play()
