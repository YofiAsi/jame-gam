extends Node

const OP_DIRECTION: Dictionary[Types.Direction, Types.Direction] = {
	Types.Direction.NO_DIRECTION: Types.Direction.NO_DIRECTION,
	Types.Direction.TOP_LEFT: Types.Direction.BOTTOM_RIGHT,
	Types.Direction.TOP_RIGHT: Types.Direction.BOTTOM_LEFT,
	Types.Direction.BOTTOM_LEFT: Types.Direction.TOP_RIGHT,
	Types.Direction.BOTTOM_RIGHT: Types.Direction.TOP_LEFT,
}

const ROAD_DIR_PKS: Dictionary[Types.Direction, PackedScene] = {
	Types.Direction.NO_DIRECTION: preload("uid://dosmjew5732vi"),
	Types.Direction.TOP_LEFT:preload("uid://b20cri01gitni"),
	Types.Direction.TOP_RIGHT: preload("uid://d3n3te2y4jf6b"),
	Types.Direction.BOTTOM_LEFT: preload("uid://d3n3te2y4jf6b"),
	Types.Direction.BOTTOM_RIGHT: preload("uid://b20cri01gitni"),
	Types.Direction.LINE_TOP_LEFT: preload("uid://b20cri01gitni"),
	Types.Direction.LINE_TOP_RIGHT: preload("uid://d3n3te2y4jf6b"),
	Types.Direction.CROSS: preload("uid://bg86qb1k6fj4k"),
	Types.Direction.TURN_L: preload("uid://bg63j7buoojol"),
	Types.Direction.TURN_R: preload("uid://dy3pcjggkyebv"),
	Types.Direction.TURN_D: preload("uid://8kf75te0iv3x"),
	Types.Direction.TURN_U: preload("uid://p0geuyjfq0xf"),
}

const WATER_DIR_PKS: Dictionary[Types.Direction, PackedScene] = {
	Types.Direction.NO_DIRECTION:preload("uid://r7jrxf77dk3o"),
	Types.Direction.TOP_LEFT: preload("uid://df5tkdre8tcb0"),
	Types.Direction.TOP_RIGHT: preload("uid://dryhnh5vrhii2"),
	Types.Direction.BOTTOM_LEFT: preload("uid://dryhnh5vrhii2"),
	Types.Direction.BOTTOM_RIGHT: preload("uid://df5tkdre8tcb0"),
	Types.Direction.LINE_TOP_LEFT: preload("uid://df5tkdre8tcb0"),
	Types.Direction.LINE_TOP_RIGHT: preload("uid://dryhnh5vrhii2"),
	Types.Direction.CROSS: preload("uid://dakiflhfpvgvr"),
	Types.Direction.TURN_L: preload("uid://b6112lhio2xtd"),
	Types.Direction.TURN_R: preload("uid://min48iynk1c3"),
	Types.Direction.TURN_D: preload("uid://dgy270av1sq74"),
	Types.Direction.TURN_U: preload("uid://cyf2oa3ganyr5"),
}

const TYPE_PKS: Dictionary[Types.Tile, Dictionary] = {
	Types.Tile.ROAD_TILE: ROAD_DIR_PKS,
	Types.Tile.WATER_TILE: WATER_DIR_PKS,
	Types.Tile.CANYON_TILE: DEFENSE
}

const DEFENSE: Dictionary[Types.Direction, PackedScene] = {
	Types.Direction.NO_DIRECTION: preload("uid://dd5b8nry8ybc4"),
	Types.Direction.TOP_LEFT:preload("uid://dd5b8nry8ybc4"),
	Types.Direction.TOP_RIGHT: preload("uid://dd5b8nry8ybc4"),
	Types.Direction.BOTTOM_LEFT: preload("uid://dd5b8nry8ybc4"),
	Types.Direction.BOTTOM_RIGHT: preload("uid://dd5b8nry8ybc4"),
	Types.Direction.LINE_TOP_LEFT: preload("uid://dd5b8nry8ybc4"),
	Types.Direction.LINE_TOP_RIGHT: preload("uid://dd5b8nry8ybc4"),
	Types.Direction.CROSS: preload("uid://dd5b8nry8ybc4"),
	Types.Direction.TURN_L: preload("uid://dd5b8nry8ybc4"),
	Types.Direction.TURN_R: preload("uid://dd5b8nry8ybc4"),
	Types.Direction.TURN_D: preload("uid://dd5b8nry8ybc4"),
	Types.Direction.TURN_U: preload("uid://dd5b8nry8ybc4"),
}

const TYPE_ATLAS: Dictionary[Types.Tile, int] = {
	Types.Tile.ROAD_TILE: 0,
	Types.Tile.WATER_TILE: 2,
	Types.Tile.CANYON_TILE: 3,
}

const STATIONS: Dictionary[String, PackedScene] = {
	"land_camp": preload("uid://df8sfaohnnknh"),
	"land_food": preload("uid://cqi7crrvxmn2o"),
	"land_coin": preload("uid://cseccuf4hh0e6"),
	"land_shrine": preload("uid://d2kj5ipk2os4x"),
	"river_camp": preload("uid://b2k8mvmffwj3k"),
	"river_coin": preload("uid://8ewiiyqwsygy"),
	"river_shrine": preload("uid://j0us1iqsxnht"),
	"river_food": preload("uid://d22lfevmi4lgq"),
}

const INIT_MONEY: int = 20
const MAN_PRICE: int = 1
const MAX_MEN_AMOUNT: int = 10

const STATION_COLORS: Array[Color] = [
  Color("#E6194B"),
  Color("#3CB44B"),
  Color("#0082C8"),
  Color("#F58231"),
  Color("#911EB4"),
  Color("#46F0F0"),
  Color("#F032E6"),
  Color("#D2F53C"),
  Color("#FABEBE"),
  Color("#008080"),
  Color("#E6BEFF"),
  Color("#AA6E28"),
  Color("#FFFAC8"),
  Color("#800000"),
  Color("#AAFFC3"),
  Color("#808000"),
  Color("#FFD8B1"),
  Color("#000080"),
  Color("#808080"),
  Color("#FFE119"),
  Color("#4363D8"),
  Color("#2C7F00"),
  Color("#A4005F"),
  Color("#00A6F0"),
  Color("#F00000"),
  Color("#7A4900"),
  Color("#0000FF"),
  Color("#70FF70"),
  Color("#FF70CF")
]

const NIGHT_TRANSITION_SPEED: float = 0.1
