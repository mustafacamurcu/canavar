extends Node2D

var row_count = 6
var col_count = 8
# {Vector2i -> Unit}
var hexboard = {}

func _ready() -> void:
	for i in range(col_count * 2):
		for j in range(row_count):
			if (i + j) % 2 == 0:
				hexboard[Vector2i(i, j)] = 0

func _draw() -> void:
	for coord in hexboard.keys():
		var hex_coord = Coord.from_vector2i(coord)
		var lines = hex_coord.edge_lines()
		for line in lines:
			draw_line(line[0], line[1], Color.BLACK)