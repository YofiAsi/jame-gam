extends Label

@onready var game_node: MainGameNode = get_tree().get_nodes_in_group("game_node")[0]

func _process(_delta: float) -> void:
	self.text = str(game_node.camps * 10) + " / 150"
