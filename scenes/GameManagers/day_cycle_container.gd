extends HBoxContainer

@onready var texture_rect: TextureRect = $TextureRect
@onready var day_cycle_progress: ProgressBar = $DayCycleProgress

func _ready() -> void:
	DayCycleManager.night_started.connect(self.hide)
	DayCycleManager.day_started.connect(self.show)

func _process(_delta: float) -> void:
	if DayCycleManager.is_day:
		day_cycle_progress.value = 100 * (DayCycleManager.timer.wait_time - DayCycleManager.timer.time_left) / DayCycleManager.timer.wait_time
