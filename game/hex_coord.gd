class_name Coord
extends Resource

# https://www.redblobgames.com/grids/hexagons/
# Double Width Coordinates

const EDGE_SIZE = 100

var col
var row

func _init(x, y):
	col = x
	row = y

static func from_vector2i(coord: Vector2i):
	return Coord.new(coord.x, coord.y)

func _to_string():
	return '(' + str(col) + ', ' + str(row) + ')'

func add(other: Coord):
	return Coord.new(col + other.col, row + other.row)

func directions():
	return [
		Coord.new(2, 0),
		Coord.new(1, -1),
		Coord.new(-1, -1),
		Coord.new(-2, 0),
		Coord.new(-1, 1),
		Coord.new(1, 1)]

func neighbors():
	var n = []
	for dir in directions():
		n.append(self.add(dir))
	return n

func to_position() -> Vector2:
	var x = EDGE_SIZE * sqrt(3) / 2 * col
	var y = EDGE_SIZE * 3.0 / 2 * row
	return Vector2(x, y)

func edge_lines():
	var corners = [
		Vector2(0, -1),
		Vector2(sqrt(3) / 2, -0.5),
		Vector2(sqrt(3) / 2, 0.5),
		Vector2(0, 1),
		Vector2(-sqrt(3) / 2, 0.5),
		Vector2(-sqrt(3) / 2, -0.5),
	]
	var lines = []
	var pos: Vector2 = to_position()
	for i in range(6):
		var start = corners[i] * EDGE_SIZE + pos
		var end = corners[(i + 1) % 6] * EDGE_SIZE + pos
		lines.append([start, end])
	return lines