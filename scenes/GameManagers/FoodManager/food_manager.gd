extends Node

signal food_updated(amount: int)

var curr_food: int = 0

func add_food(amount) -> void:
	curr_food += amount
	food_updated.emit(curr_food)
