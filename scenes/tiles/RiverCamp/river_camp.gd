class_name RiverCamp extends Camp

var coin_tile: LandShrine
var shrine_tile: LandCoin
var boat: PackedScene = preload("uid://cf1eiy0ygwiga")

func _add_man() -> void:
	var boat_node: Boat = boat.instantiate()
	boat_node.camp_tile = self
	boat_node.global_position = self.global_position
	boat_node.dest_array = [coin_tile, shrine_tile, self]
	get_node("/root/MainGameNode/Guys").add_child(boat_node)
	man_array.push_back(boat_node)
	cur_men_amount += 1
	_update_men_count_label()

func add_resource(amount: int) -> void:
	CurrencyManager.add_money(amount)
