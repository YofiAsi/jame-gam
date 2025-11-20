class_name RiverTile extends Tile

func _ready() -> void:
	super._ready()
	self.tile_type = Types.Tile.WATER_TILE
	
