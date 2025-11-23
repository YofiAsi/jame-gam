class_name PlusNode extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $Node2D/HBoxContainer/TextureRect

func _ready() -> void:
	animation_player.animation_finished.connect(func(): queue_free())
