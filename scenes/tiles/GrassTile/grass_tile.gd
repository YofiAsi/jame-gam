class_name GrassTile extends Tile

var textures: Array[Texture] = [
	preload("uid://bnroswrtgob0g"),
	preload("uid://ctkrvxy0b8ipv"),
	preload("uid://cdbfctu6hdk1e"),
	preload("uid://c4u1hnoow5jf5"),
]

func _ready() -> void:
	super._ready()
	$Sprite2D.texture = textures.pick_random()
