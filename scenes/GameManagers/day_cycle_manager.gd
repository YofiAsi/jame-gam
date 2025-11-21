extends Node

signal day_changed(curr_day: int)
signal day_started()
signal night_started()

var day_num: int = 1
var is_day: bool = true

func _ready() -> void:
	pass

func day_switch() -> void:
	if is_day:
		make_night()
	else:
		make_day()
	day_changed.emit(day_num)

func make_night() -> void:
	night_started.emit()
	is_day = false

func make_day() -> void:
	day_started.emit()
	is_day = true
	day_num += 1
