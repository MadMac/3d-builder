extends Node2D


var head : PackedVector2Array

var coords_head : Array = [
	[ 10, 10 ],  [ 10, 50 ],
	[ 50, 50 ], [ 50, 10 ],

	]

func float_array_to_Vector2Array(coords : Array) -> PackedVector2Array:
	# Convert the array of floats into a PackedVector2Array.
	var array : PackedVector2Array = []
	for coord in coords:
		array.append(Vector2(coord[0], coord[1]))
	return array

# Called when the node enters the scene tree for the first time.q
func _ready():
	pass

func _draw():
	# We are going to paint with this color.
	var godot_blue : Color = Color("478cbf", 0.3)
	# We pass the PackedVector2Array to draw the shape.
	# print(head)
	draw_polygon(head, [ godot_blue ])
	
	
func set_coords(start: Vector2, end: Vector2):
	coords_head = [
		[start.x, start.y],
		[start.x, end.y],
		[end.x, end.y],
		[end.x, start.y]
	]
	head = float_array_to_Vector2Array(coords_head);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
