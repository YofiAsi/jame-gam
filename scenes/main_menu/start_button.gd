extends TextureButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2


func _on_mouse_entered() -> void:
	audio_stream_player.play()


func _on_pressed() -> void:
	audio_stream_player_2.play(0.09)
