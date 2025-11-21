extends Label

func _ready() -> void:
	self.text = "1"
	DayCycleManager.day_changed.connect(_update_day)

func _update_day(day: int) -> void:
	self.text = str(day)
