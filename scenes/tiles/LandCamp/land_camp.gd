class_name LandCamp extends StationTile



@onready var spawn_timer: Timer = $SpawnTimer

var cur_men_amount: int = 0
var simple_guy: PackedScene = preload("uid://koj7f8trhfju")

func _ready() -> void:
	super._ready()
	$BuyManButton.pressed.connect(_on_man_buy_button_pressed)
	
func _process(delta: float) -> void:
	pass

func add_man() -> void:
	
		_add_man()

func _can_add_man() -> bool:
	if cur_men_amount >= Consts.MAX_MEN_AMOUNT:
		return false
	return true

func _add_man() -> void:
	var guy_node: SimpleGuy = simple_guy.instantiate()
	guy_node.global_position = self.global_position
	get_node("/root/MainGameNode/Guys").add_child(guy_node)
	

func _on_man_buy_button_pressed() -> void:
	if not _can_add_man():
		_full_occupation()
		return
	if not CurrencyManager.buy(Consts.MEN_PRICE):
		return
	_add_man()

func _full_occupation() -> void:
	pass
