class_name TileBuyContainer extends HBoxContainer

signal change_curr_tile(type: Types.Tile, cost: int)
signal buy_camp(land: bool, cost: int)

const COST: Dictionary[Types.Tile, int] = {
	Types.Tile.GRASS: 0,
	Types.Tile.ROAD_TILE: 1,
	Types.Tile.WATER_TILE: 1,
	Types.Tile.CANYON_TILE: 10,
}

var buttons: Dictionary[Types.Tile, SelectTextureButton]

const land_camp_cost: int = 15
const water_camp_cost: int = 20

@onready var buy_reg: SelectTextureButton = $VBoxContainer4/BuyReg
@onready var buy_road: SelectTextureButton = $VBoxContainer/BuyRoad
@onready var buy_river: SelectTextureButton = $VBoxContainer2/BuyRiver
@onready var buy_tower: SelectTextureButton = $VBoxContainer3/BuyTower
@onready var buy_land_camp: SelectTextureButton = $VBoxContainer5/BuyLandCamp
@onready var buy_water_camp: SelectTextureButton = $VBoxContainer6/BuyWaterCamp

var curr_buy: Types.Tile = Types.Tile.ROAD_TILE:
	set(value):
		curr_buy = value
		_update_buttons_color()

func _ready() -> void:
	buttons = {
		Types.Tile.GRASS: buy_reg,
		Types.Tile.ROAD_TILE: buy_road,
		Types.Tile.WATER_TILE: buy_river,
		Types.Tile.CANYON_TILE: buy_tower,
	}
	
	for type in buttons.keys():
		buttons[type].pressed.connect(func(): curr_buy = type)
		buttons[type].pressed_texture.connect(func(tile_type):
			change_curr_tile.emit(tile_type, COST[tile_type])
		)
	
	_update_buttons_color()
	buy_land_camp.pressed.connect(func(): buy_camp.emit(true, land_camp_cost))
	buy_water_camp.pressed.connect(func(): buy_camp.emit(false, water_camp_cost))
	
	DayCycleManager.night_started.connect(hide)
	DayCycleManager.day_started.connect(show)

func _update_buttons_color() -> void:
	for type in buttons.keys():
		if curr_buy == type:
			buttons[type].bright()
			buttons[type].toggle = true
		else:
			buttons[type].dark()
			buttons[type].toggle = false
