class_name Coord
extends Resource

# https://www.redblobgames.com/grids/hexagons/
# Double Width Coordinates

const EDGE_SIZE = 100

const CORNER_OFFSETS = [
		Vector2(0, -1),
		Vector2(sqrt(3) / 2, -0.5),
		Vector2(sqrt(3) / 2, 0.5),
		Vector2(0, 1),
		Vector2(-sqrt(3) / 2, 0.5),
		Vector2(-sqrt(3) / 2, -0.5),
	]

const DIRECTIONS = [
		Vector2i(2, 0),
		Vector2i(1, -1),
		Vector2i(-1, -1),
		Vector2i(-2, 0),
		Vector2i(-1, 1),
		Vector2i(1, 1)
	]

static func neighbors(coord: Vector2i) -> Array[Vector2i]:
	var n: Array[Vector2i] = []
	for dir in DIRECTIONS:
		n.append(coord + dir)
	return n

static func to_position(coord: Vector2i) -> Vector2:
	var x = EDGE_SIZE * sqrt(3) / 2 * coord.x
	var y = EDGE_SIZE * 3.0 / 2 * coord.y
	return Vector2(x, y)

static func hex_distance(coord: Vector2i, other: Vector2i) -> int:
	var dcol = abs(coord.x - other.x)
	var drow = abs(coord.y - other.y)
	return drow + max(0, (dcol - drow) / 2)

static func corners(coord: Vector2i) -> Array[Vector2]:
	var cs: Array[Vector2] = []
	for offset in CORNER_OFFSETS:
		cs.append(offset * EDGE_SIZE + to_position(coord))
	return cs

static func edge_lines(coord: Vector2i) -> Array:
	var cs = corners(coord)
	var lines = []
	for i in range(6):
		var start = cs[i]
		var end = cs[(i + 1) % 6]
		lines.append([start, end])
	return lines
