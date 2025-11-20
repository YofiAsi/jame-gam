extends Node

signal tile_created(tile: Tile)

func emit_tile_creation(tile: Tile) -> void:
	tile_created.emit(tile)
