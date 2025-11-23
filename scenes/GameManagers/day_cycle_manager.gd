extends Node

signal day_changed(curr_day: int)
signal day_started()
signal night_started()

var timer: Timer
var night_wait_timer: Timer

var day_num: int = 1
var is_day: bool = true
var is_active: bool = false

var DAY_TIME: float = 30.0
var NIGHT_TIME: float = 30.0

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_timer_timeout)
	add_child(timer)
	
	night_wait_timer = Timer.new()
	night_wait_timer.one_shot = true
	add_child(night_wait_timer)

func _timer_timeout() -> void:
	make_night()

func start_cycle() -> void:
	timer.start(DAY_TIME)
	is_active = true
	day_started.emit()

func _day_switch() -> void:
	if is_day:
		make_night()
	else:
		make_day()

func make_night() -> void:
	night_started.emit()
	is_day = false
	AudioManager.night_ambience.play()

func make_day() -> void:
	day_started.emit()
	is_day = true
	day_num += 1
	timer.start(DAY_TIME + 4*day_num)
	day_changed.emit(day_num)
	AudioManager.night_ambience.stop()

func get_time_left() -> float:
	return timer.time_left

func no_demons() -> void:
	night_wait_timer.start(1)
	await night_wait_timer.timeout
	
	make_day()
	
