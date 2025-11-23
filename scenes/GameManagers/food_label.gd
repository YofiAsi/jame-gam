extends Label

func _ready() -> void:
	FoodManager.food_updated.connect(_update_food_label)
	self.text = str(FoodManager.curr_food)

func _update_food_label(amount) -> void:
	self.text = str(amount)
