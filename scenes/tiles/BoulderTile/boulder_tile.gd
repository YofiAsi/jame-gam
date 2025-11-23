extends StationTile

const textures: Array[Texture] = [
	preload("uid://cu41bk8uug3eq"),
	preload("uid://dl3v42kplx6id"),
	preload("uid://dwq4yoanwmv6s")
]

func _ready() -> void:
	super._ready()
	$Sprite2D.texture = textures.pick_random()
