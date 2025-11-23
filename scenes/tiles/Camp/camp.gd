class_name Camp extends StationTile

@onready var men_count_label: Label = $VBoxContainer/MenCount
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var no_route_sprite: Sprite2D = $NoRoute
@onready var point_light_2d: PointLight2D = $PointLight2D

var cur_men_amount: int = 0
var man_array: Array[Man] = []
var curr_out: int = 0
var out_timer: Timer
var guys_node: Guys
var _init_guys: bool = true
var _cheking_route: bool = false
var check_route_timer: Timer

func _ready() -> void:
	super._ready()
	add_to_group("camp")
	DayCycleManager.day_started.connect(_show_buy_buttons)
	DayCycleManager.night_started.connect(_start_lights)
	out_timer = Timer.new()
	out_timer.autostart = false
	out_timer.one_shot = true
	add_child(out_timer)
	guys_node = get_tree().get_nodes_in_group("guys_node")[0]
	point_light_2d.hide()
	
	check_route_timer = Timer.new()
	check_route_timer.autostart = false
	check_route_timer.wait_time = 0.05
	check_route_timer.one_shot = true
	check_route_timer.timeout.connect(func():
		if not navigation_agent_2d.is_target_reachable():
			no_route_sprite.show()
		_cheking_route = false
	)
	add_child(check_route_timer)

func _set_agent_dest() -> void:
	pass

func _process(_delta: float) -> void:
	if _init_guys:
		for _i in Consts.MAX_MEN_AMOUNT:
			_add_man()
		_set_agent_dest()
		_init_guys = false

	if not navigation_agent_2d.is_target_reachable():
		if check_route_timer.is_stopped():
			if not _cheking_route:
				check_route_timer.start()
				_cheking_route = true
		return
	
	no_route_sprite.hide()

	if curr_out < len(man_array) and out_timer.is_stopped() and DayCycleManager.is_day:
		man_array[curr_out].awake()
		curr_out += 1
		out_timer.start()

func wake_guys() -> void:
	curr_out = 0
	point_light_2d.hide()

func _can_add_man() -> bool:
	if cur_men_amount >= Consts.MAX_MEN_AMOUNT:
		return false
	return true

func _add_man() -> void:
	print("_add_man not implemented")

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
		
		guys_node.curr_amount += 1

func _full_occupation() -> void:
	pass

func _start_lights() -> void:
	point_light_2d.show()

func _show_buy_buttons() -> void:
	pass

func add_resource(amount: int) -> void:
	print("add_resource not implemented")

func camp_hitted() -> void:
	for man in man_array:
		if is_instance_valid(man):
			man.queue_free()
