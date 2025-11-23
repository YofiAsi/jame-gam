extends Label

func _process(_delta: float) -> void:
	if DayCycleManager.is_active:
		self.text = str(int(DayCycleManager.get_time_left()) + 1)
