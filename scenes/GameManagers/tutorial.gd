class_name Tutorial extends CanvasLayer


signal finished()

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
var curr_idx = 1

func _ready() -> void:
	start()

func start() -> void:
	self.show()
	animated_sprite_2d.play("t1")

func next() -> void:
	audio_stream_player.play(0.09)
	curr_idx += 1
	if curr_idx > 5:
		finish()
		return
	
	animated_sprite_2d.modulate.a = 0.5 if curr_idx == 3 else 1.0
	animated_sprite_2d.play("t" + str(curr_idx))
	
	
func finish() -> void:
	finished.emit()
	timer.start()
	await timer.timeout
	self.queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") or event.is_action_pressed("right_click"):
		next()
