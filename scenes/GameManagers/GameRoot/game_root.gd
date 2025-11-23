extends Node2D

@onready var main_game_node: MainGameNode = $MainGameNode
@onready var pause_menu: CanvasLayer = $PauseMenu

var curr_state: State = State.IN_GAME
enum State {
	PAUSE,
	IN_GAME,
}

func _ready() -> void:
	pause_menu.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_pause_toggle()

func _pause_toggle():
	if curr_state == State.PAUSE:
		_unpause()
		return
	if curr_state == State.IN_GAME:
		_pause()
		
func _unpause() -> void:
	get_tree().paused = false
	pause_menu.hide()
	curr_state = State.IN_GAME

func _pause() -> void:
	get_tree().paused = true
	pause_menu.show()
	curr_state = State.PAUSE
