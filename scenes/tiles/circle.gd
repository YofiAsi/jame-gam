class_name Circle extends Node2D

var circle_color: Color = Color(0.905, 0.32, 0.693, 1.0)

func _ready() -> void:
	queue_redraw()

func set_color(c: Color) -> void:
	circle_color = c
	queue_redraw()
	
func _draw() -> void:
	var marker: Marker2D = get_parent().get_node("Marker2D")
	var outline_color: Color = Color.BLACK
	var radius := 40
	var outline_width := 8
	var center = marker.global_position - global_position
	draw_circle(center, radius, circle_color)
	draw_arc(center, radius, 0, TAU, 64, outline_color, outline_width)
