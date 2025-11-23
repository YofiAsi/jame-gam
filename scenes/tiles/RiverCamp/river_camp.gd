class_name RiverCamp extends Camp

var coin_tile: RiverCoin
var shrine_tile: RiverShrine
var food_tile: RiverFood
var boat: PackedScene = preload("uid://cf1eiy0ygwiga")
const PLUS_ANIMATION = preload("uid://b3a0nohwqtrqo")
const COIN_LOGO = preload("uid://d3igahfln5k14")

func _ready() -> void:
	super._ready()

func _process(_delta: float) -> void:
	super._process(_delta)
	
func _add_man() -> void:
	var boat_node: Boat = boat.instantiate()
	boat_node.camp_tile = self
	#boat_node.speed = 400
	boat_node.global_position = self.global_position
	if is_instance_valid(food_tile):
		boat_node.dest_array = [food_tile, self]
	else:
		boat_node.dest_array = [coin_tile, shrine_tile]
	get_tree().get_nodes_in_group("guys_node")[0].add_child(boat_node)
	boat_node.sleep()
	man_array.push_back(boat_node)
	cur_men_amount += 1

func add_resource(amount: int) -> void:
	if is_instance_valid(food_tile):
		FoodManager.add_food(amount)
		
	else:
		CurrencyManager.add_money(amount)
		if is_instance_valid(shrine_tile):
			var animation_node: PlusNode = PLUS_ANIMATION.instantiate()
			shrine_tile.add_child(animation_node)
			animation_node.texture_rect.texture = COIN_LOGO

func _set_agent_dest() -> void:
	if is_instance_valid(coin_tile):
		self.navigation_agent_2d.target_position = coin_tile.global_position

func camp_hitted() -> void:
	super.camp_hitted()
	if is_instance_valid(coin_tile):
		coin_tile.die()
	if is_instance_valid(shrine_tile):
		shrine_tile.die()
	if is_instance_valid(self):
		self.die()
