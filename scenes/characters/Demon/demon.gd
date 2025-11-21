class_name Demon extends Node2D

var curr_hp: int = 1:
	set(value):
		if value <= 0:
			_die()
		curr_hp = value
var camps: Array[Node]
var curr_camp_idx: int = -1
var curr_camp: LandCamp
var dest_vector: Vector2

const SPEED: float = 200.0

var curr_state: State = State.IDLE
enum State {
	IDLE,
	ATTACK,
	DEAD
}

func _ready() -> void:
	_find_nearest_camp()
	_get_next_camp()
	
func _process(delta: float) -> void:
	if curr_state == State.IDLE:
		return
	
	if curr_state == State.ATTACK:
		if curr_camp.cur_men_amount <= 0:
			self._get_next_camp()
		if global_position.distance_to(dest_vector) <= 100.0:
			_hit_camp()
		var direction: Vector2 = global_position.direction_to(dest_vector).normalized()
		global_position += direction * delta * SPEED

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		_hit()

func _hit() -> void:
	curr_hp -= 1

func _die() -> void:
	queue_free()

func _sort_camps(a: LandCamp, b: LandCamp) -> bool:
	if self.global_position.distance_to(a.global_position) < \
	self.global_position.distance_to(b.global_position): # a is closer
		if a.cur_men_amount <= 0 and b.cur_men_amount > 0:
			return false
		else:
			return true
	else:
		if b.cur_men_amount <= 0 and a.cur_men_amount > 0: # b is closer
			return false
		else:
			return true

func _find_nearest_camp() -> void:
	self.camps = get_tree().get_nodes_in_group("camp")
	self.camps.sort_custom(_sort_camps)

func _get_next_camp() -> void:
	curr_camp_idx += 1
	if curr_camp_idx >= len(camps):
		_no_camps_anymore()
		return
	
	curr_camp = camps[curr_camp_idx]
	dest_vector = curr_camp.global_position
	self.curr_state = State.ATTACK

func _no_camps_anymore() -> void:
	self.curr_state = State.IDLE

func _hit_camp() -> void:
	curr_camp.camp_hitted()
	queue_free()
