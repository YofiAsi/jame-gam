class_name LandCamp extends Camp

var food_tile: LandFood
var coin_tile: LandCoin
var shrine_tile: LandShrine
var simple_guy: PackedScene = preload("uid://koj7f8trhfju")
const PLUS_ANIMATION = preload("uid://b3a0nohwqtrqo")

func _ready() -> void:
	super._ready()

func _process(_delta: float) -> void:
	super._process(_delta)

func _add_man() -> void:
	var guy_node: SimpleGuy = simple_guy.instantiate()
	guy_node.camp_tile = self
	guy_node.global_position = self.global_position
	if is_instance_valid(food_tile):
		guy_node.dest_array = [food_tile, self]
	else:
		guy_node.dest_array = [coin_tile, shrine_tile, self]
	get_tree().get_nodes_in_group("guys_node")[0].add_child(guy_node)
	guy_node.sleep()
	man_array.push_back(guy_node)
	cur_men_amount += 1
	

func add_resource(amount: int) -> void:
	if is_instance_valid(food_tile):
		FoodManager.add_food(amount)
		add_child(PLUS_ANIMATION.instantiate())
	else:
		CurrencyManager.add_money(amount)

func _set_agent_dest() -> void:
	if is_instance_valid(food_tile):
		self.navigation_agent_2d.target_position = food_tile.global_position

func camp_hitted() -> void:
	super.camp_hitted()
	if is_instance_valid(food_tile):
		food_tile.die()
	if is_instance_valid(self):
		self.die()
