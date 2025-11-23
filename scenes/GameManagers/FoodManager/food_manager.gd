extends Node

signal food_updated(amount: int)

var curr_food: int = 15:
	set(value):
		curr_food = value
		food_updated.emit(curr_food)

func add_food(amount) -> void:
	curr_food += amount
	food_updated.emit(curr_food)

func buy(amount) -> bool:
	if curr_food < amount:
		return false
	
	curr_food -= amount
	return true
