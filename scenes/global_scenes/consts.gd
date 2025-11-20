extends Node

const OP_DIRECTION: Dictionary[Types.Direction, Types.Direction] = {
	Types.Direction.NO_DIRECTION: Types.Direction.NO_DIRECTION,
	Types.Direction.TOP_LEFT: Types.Direction.BOTTOM_RIGHT,
	Types.Direction.TOP_RIGHT: Types.Direction.BOTTOM_LEFT,
	Types.Direction.BOTTOM_LEFT: Types.Direction.TOP_RIGHT,
	Types.Direction.BOTTOM_RIGHT: Types.Direction.TOP_LEFT,
}

const DIRECTION_TILE_ID: Dictionary[Types.Direction, int] = {
	Types.Direction.NO_DIRECTION: 1,
	Types.Direction.TOP_LEFT: 2,
	Types.Direction.TOP_RIGHT: 3,
	Types.Direction.BOTTOM_LEFT: 3,
	Types.Direction.BOTTOM_RIGHT: 2,
	Types.Direction.LINE_TOP_LEFT: 2,
	Types.Direction.LINE_TOP_RIGHT: 3,
	Types.Direction.CROSS: 4,
	Types.Direction.TURN_L: 6,
	Types.Direction.TURN_R: 7,
	Types.Direction.TURN_D: 5,
	Types.Direction.TURN_U: 8,
}

const TYPE_ATLAS: Dictionary[Types.Tile, int] = {
	Types.Tile.ROAD_TILE: 0,
	Types.Tile.WATER_TILE: 2,
	Types.Tile.CANYON_TILE: 3,
}

const INIT_MONEY: int = 10
const MEN_PRICE: int = 1
const MAX_MEN_AMOUNT: int = 20
