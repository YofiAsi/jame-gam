extends Node

signal currency_changed(curr_amount: int)
signal buy_declined()

var curr_money: int = Consts.INIT_MONEY:
	set(value):
		curr_money = value
		currency_changed.emit(curr_money)

func add_money(amount: int) -> void:
	curr_money += amount

func can_afford(amount: int) -> bool:
	return amount <= self.curr_money

func buy(amount: int) -> bool:
	if not can_afford(amount):
		buy_declined.emit()
		return false
		
	curr_money -= amount
	return true

func reset() -> void:
	self.curr_money = Consts.INIT_MONEY
	#_disconnect_signals()

#func _disconnect_signals() -> void:
	#for _signal in get_signal_list():
		#for connection in get_signal_connection_list(_signal.get("name")):
			#disconnect(_signal.get("name"), connection.get("callable"))
