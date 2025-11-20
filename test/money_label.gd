extends Label

func _ready() -> void:
	CurrencyManager.currency_changed.connect(_update_money_label)
	self.text = str(CurrencyManager.curr_money)
	
func _update_money_label(amount) -> void:
	self.text = str(amount)
