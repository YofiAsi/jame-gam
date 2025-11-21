class_name Camp extends StationTile

@onready var men_count_label: Label = $VBoxContainer/MenCount

var cur_men_amount: int = 0:
	set(value):
		if cur_men_amount < Consts.MAX_MEN_AMOUNT \
		and value >= Consts.MAX_MEN_AMOUNT:
			_hide_buy_buttons()
		elif cur_men_amount >= Consts.MAX_MEN_AMOUNT \
		and value < Consts.MAX_MEN_AMOUNT:
			_show_buy_buttons()
		cur_men_amount = value
		_update_men_count_label()
var man_array: Array[Man] = []

func _ready() -> void:
	super._ready()
	$VBoxContainer/BuyMen.pressed.connect(_on_buy_man_button_pressed)

func _can_add_man() -> bool:
	if cur_men_amount >= Consts.MAX_MEN_AMOUNT:
		return false
	return true

func _add_man() -> void:
	print("_add_man not implemented")

func _update_men_count_label() -> void:
	men_count_label.text = str(cur_men_amount) + "/" + str(Consts.MAX_MEN_AMOUNT)

func _try_buy_man() -> bool:
	if not _can_add_man():
		_full_occupation()
		return false
	if not CurrencyManager.buy(Consts.MAN_PRICE):
		return false
	return true

func _on_buy_man_button_pressed() -> void:
	if _try_buy_man():
		_add_man()

func _full_occupation() -> void:
	pass

func _hide_buy_buttons() -> void:
	$VBoxContainer/BuyMen.hide()
	$VBoxContainer/BuyMen.set_disabled(true)

func _show_buy_buttons() -> void:
	$VBoxContainer/BuyMen.show()
	$VBoxContainer/BuyMen.set_disabled(false)

func add_resource(amount: int) -> void:
	print("add_resource not implemented")

func camp_hitted() -> void:
	if cur_men_amount <= 0:
		return
	var man_node: Man = man_array.pop_back()
	man_node.queue_free()
	cur_men_amount -= 1
	
