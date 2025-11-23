class_name DefenceTower extends Tile

@onready var detect_area: Area2D = $DetectArea
@onready var arrow: Node2D = $Arrow
@onready var marker_2d: Marker2D = $Marker2D

var fire_rate_timer: Timer
const FIRE_RATE: float = 0.4

var arrow_active := false
var arrow_time := 0.0
var arrow_duration := 0.2

var arrow_start := Vector2.ZERO
var arrow_end := Vector2.ZERO
var arrow_control := Vector2.ZERO

var target_demon: Demon = null


func _ready() -> void:
	super._ready()

	fire_rate_timer = Timer.new()
	fire_rate_timer.one_shot = true
	fire_rate_timer.autostart = false
	fire_rate_timer.wait_time = FIRE_RATE
	add_child(fire_rate_timer)

	arrow.visible = false


func _process(delta: float) -> void:
	super._process(delta)

	# Arrow flight update
	if arrow_active:
		if is_instance_valid(target_demon):
			_update_curve_points()

		arrow_time += delta
		var t := arrow_time / arrow_duration

		if t >= 1.0:
			# Final position
			arrow.position = arrow_end

			if is_instance_valid(target_demon):
				target_demon._hit()

			arrow.visible = false
			arrow_active = false
			fire_rate_timer.start()
			return

		# Quadratic Bézier interpolation
		var p0 = arrow_start
		var p1 = arrow_control
		var p2 = arrow_end

		arrow.position =\
			(1 - t) * (1 - t) * p0 +\
			2 * (1 - t) * t * p1 +\
			t * t * p2

		# Rotation (forward look)
		var tt = min(t + 0.01, 1.0)
		var next_pos =\
			(1 - tt) * (1 - tt) * p0 +\
			2 * (1 - tt) * tt * p1 +\
			tt * tt * p2

		arrow.rotation = (next_pos - arrow.position).angle()
		return


	# Tower ready to fire
	if fire_rate_timer.is_stopped():
		var areas: Array[Area2D] = detect_area.get_overlapping_areas()
		if len(areas) == 0:
			return

		var closest_demon: Demon = null
		var dist: float
		for area in areas:
			if not is_instance_valid(area):
				continue
			var d: Demon = area.get_parent()
			if is_instance_valid(d) and d.curr_state in [d.State.ATTACK, d.State.IDLE]:
				if d.targeted:
					continue
				if closest_demon == null:
					closest_demon = d
					dist = global_position.distance_to(d.global_position)
				elif global_position.distance_to(d.global_position) < dist:
					closest_demon = d
					dist = global_position.distance_to(d.global_position)
		if is_instance_valid(closest_demon):
			shoot_at(closest_demon)


func shoot_at(demon: Demon) -> void:
	if arrow_active:
		return

	$AudioStreamPlayer.play()
	demon.targeted = true

	target_demon = demon
	arrow_active = true
	arrow_time = 0.0
	arrow_duration = 0.4

	arrow_start = marker_2d.position
	arrow.position = arrow_start
	arrow.visible = true

	_update_curve_points()


func _update_curve_points() -> void:
	if not is_instance_valid(target_demon):
		return

	arrow_end = to_local(target_demon.global_position)

	var mid := (arrow_start + arrow_end) * 0.5
	var dir := arrow_end - arrow_start

	if dir.length() > 0:
		var perpendicular := dir.orthogonal().normalized()
		arrow_control = mid + perpendicular * 40.0
	else:
		arrow_control = mid
