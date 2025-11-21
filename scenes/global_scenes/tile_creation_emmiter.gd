extends Node

signal tile_created(tile: Tile)
signal station_tile_created(tile: StationTile)

func emit_tile_creation(tile: Tile) -> void:
	if tile is StationTile:
		station_tile_created.emit(tile)
	else:
		tile_created.emit(tile)
