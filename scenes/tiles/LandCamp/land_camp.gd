class_name LandCamp extends Camp

var food_tile: LandFood
var simple_guy: PackedScene = preload("uid://koj7f8trhfju")

func _ready() -> void:
	super._ready()

func _add_man() -> void:
	var guy_node: SimpleGuy = simple_guy.instantiate()
	guy_node.camp_tile = self
	guy_node.global_position = self.global_position
	guy_node.dest_array = [food_tile, self]
	get_node("/root/MainGameNode/Guys").add_child(guy_node)
	man_array.push_back(guy_node)
	cur_men_amount += 1
	_update_men_count_label()

func add_resource(amount: int) -> void:
	FoodManager.add_food(amount)
