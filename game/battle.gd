class_name Battle
extends Resource

# Config
var enemy_types: Array
var row_count = 6
var col_count = 8

# Units
var allies: Array[Unit]
var enemies: Array[Unit]

var active = false

# Board
var hexboard = {} # {Vector2i -> Unit}

# Signals
signal battle_ended(isWin: bool)

# Methods
func _init() -> void:
	create_board()
	place_enemies()

func create_board():
	for i in range(col_count * 2):
		for j in range(row_count):
			if (i + j) % 2 == 0:
				hexboard[Vector2i(i, j)] = null

func place_allies(units: Array[Unit]):
	allies = units
	for ally in allies:
		# place in assigned hex
		if (ally.starting_hex != Vector2i(-1, -1)
			and ally.starting_hex in hexboard
			and hexboard[ally.starting_hex] == null):
			hexboard[ally.starting_hex] = ally
			ally.set_hex_coord(ally.starting_hex)
		# if unavailable, place at range
		else:
			var enemy_front_line = row_count / 2 - 1
			var desired_row = enemy_front_line + ally.attack_range
			var spot = find_empty_spot(desired_row)
			hexboard[spot] = ally
			ally.set_hex_coord(spot)
			

func place_enemies() -> void:
	# place at range
	for enemy_type in enemy_types:
		var enemy: Unit = enemy_type.new()
		enemies.append(enemy)
		var ally_front_line = row_count / 2
		var desired_row = ally_front_line - enemy.attack_range
		var spot = find_empty_spot(desired_row)
		hexboard[spot] = enemy
		enemy.set_hex_coord(spot)

func find_empty_spot(desired_row: int) -> Vector2i:
	for coord in hexboard:
		if hexboard[coord] == null and coord.y == desired_row:
			return coord
	assert(false, "couldn't find empty spot")
	return Vector2i(-1, -1)

func start():
	active = true
	for unit in allies:
		unit.died.connect(_on_unit_died)
	for unit in enemies:
		unit.died.connect(_on_unit_died)

func stop():
	active = false

func tick(delta: float) -> void:
	if not active:
		return
	for unit in allies:
		unit.tick(delta)
	for unit in enemies:
		unit.tick(delta)
	
func _on_unit_died(unit: Unit):
	print(unit.title)
	if unit in allies:
		allies.erase(unit)
	else:
		enemies.erase(unit)
	
	if allies.is_empty():
		end_battle(false)
	elif enemies.is_empty():
		end_battle(true)

func end_battle(isWin: bool):
	battle_ended.emit(isWin)
	active = false

func is_hex_available(coord: Vector2i):
	return coord in hexboard and hexboard[coord] == null
