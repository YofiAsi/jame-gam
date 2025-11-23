class_name Demon extends Node2D

signal dead()

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@onready var warning_icon: Sprite2D = $WarningIcon

var warning_path: Path2D
var camera: Camera

var curr_hp: int = 1:
	set(value):
		curr_hp = value
		if value <= 0:
			_die()
var camps: Array[Node]
var curr_camp_idx: int = -1
var curr_camp: Camp
var dest_vector: Vector2

const SPEED: float = 400.0

var curr_state: State = State.INIT
enum State {
	INIT,
	SPAWN,
	IDLE,
	ATTACK,
	DEAD
}

var targeted: bool = false

func _ready() -> void:
	_find_nearest_camp()
	_get_next_camp()

	warning_path = get_tree().get_first_node_in_group("warning_path")
	camera = get_tree().get_first_node_in_group("camera")
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	
func _process(delta: float) -> void:	
	#if not visible_on_screen_notifier_2d.is_on_screen():
		#warning_icon.show()
		#_update_warning_sign()
	#else:
		#warning_icon.hide()
	
	if curr_state == State.INIT:
		animated_sprite_2d.play("spawn")
		curr_state = State.SPAWN
		return
	if curr_state == State.ATTACK:
		if (not is_instance_valid(curr_camp)) or curr_camp.cur_men_amount <= 0:
			self._get_next_camp()
		if global_position.distance_to(dest_vector) <= 100.0:
			_hit_camp()
			return
		var direction: Vector2 = global_position.direction_to(dest_vector).normalized()
		global_position += direction * delta * SPEED
		
		animated_sprite_2d.animation = "walk_back" if direction.y < 0 else "walk_front"
		if not animated_sprite_2d.is_playing():
			animated_sprite_2d.play()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		_hit()

func _hit() -> void:
	curr_hp -= 1

func _die() -> void:
	if curr_state == State.DEAD:
		return
	dead.emit()
	curr_state = State.DEAD
	animated_sprite_2d.play("die")
	$AudioStreamPlayer.play()
	$PointLight2D.color = Color("ffffffff")

func _sort_camps(a: Camp, b: Camp) -> bool:
	if self.global_position.distance_to(a.global_position) < \
	self.global_position.distance_to(b.global_position): # a is closer
		return true
	return false

func _find_nearest_camp() -> void:
	self.camps = get_tree().get_nodes_in_group("camp")
	self.camps.sort_custom(_sort_camps)

func _get_next_camp() -> void:
	curr_camp_idx += 1
	if curr_camp_idx >= len(camps):
		_no_camps_anymore()
		return
	
	if is_instance_valid(camps[curr_camp_idx]):
		curr_camp = camps[curr_camp_idx]
		dest_vector = curr_camp.global_position
	else:
		_get_next_camp()
		

func _no_camps_anymore() -> void:
	_die()

func _hit_camp() -> void:
	if curr_state == State.DEAD:
		return
	if is_instance_valid(curr_camp):
		curr_camp.camp_hitted()
		_die()

func _on_animation_finished() -> void:
	if curr_state == State.SPAWN:
		curr_state = State.ATTACK
		animated_sprite_2d.stop()
		$PointLight2D.color = Color("ff0000")
		return
	if curr_state == State.DEAD:
		queue_free()
		return

#func _update_warning_sign() -> void:
	#var curve := warning_path.curve
	#
	#var local_pos := warning_path.to_local(self.global_position)
	#var closest_local := curve.get_closest_point(local_pos)
	#var closest_global := warning_path.to_global(closest_local)
#
	#warning_icon.global_position = closest_global / camera.zoom.x
