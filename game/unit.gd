class_name Unit
extends Resource

const HEX_POSITION_EPSILON = 5

var icon_path: String
var title: String

var _position
var _hex_coord
var starting_hex: Vector2i = Vector2i(-1, -1)

var damage = 10
var health = 100
var attack_speed = 1
var attack_range = 1
var move_speed = 200

var attack_target: Unit
var move_target: Vector2i = Vector2i(-1, -1)

var targetable = true

var attack_timer: float = attack_speed

signal died(unit: Unit)
signal position_changed
signal health_changed

func _init() -> void:
	pass

func tick(delta: float) -> void:
	choose_target()
	if move_target != Vector2i(-1, -1):
		try_move(delta)
	else:
		try_attack(delta)

func choose_target():
	if attack_target == null or not attack_target.targetable:
		attack_target = Game.find_target(targeting)

func try_move(delta: float):
	var target_pos = Coord.to_position(move_target)
	update_position(_position.move_toward(target_pos, delta * move_speed))
	if _position.distance_to(target_pos) < HEX_POSITION_EPSILON:
		_hex_coord = move_target
		move_target = Vector2i(-1, -1)

# dummy navigation, greedy neighbor search
# TODO: Replace with A*
func set_move_target(target: Vector2i) -> void:
	var neighbors = Coord.neighbors(_hex_coord)
	var closest = Vector2i(-1, -1)
	for neighbor in neighbors:
		if Game.battle.is_hex_available(neighbor):
			if closest == Vector2i(-1, -1) or Coord.hex_distance(target, neighbor) < Coord.hex_distance(target, closest):
				closest = neighbor
	if closest != Vector2i(-1, -1):
		move_target = closest

func try_attack(delta: float):
	attack_timer -= delta
	# no target -> do nothing
	if attack_target == null:
		return
	# target out of range -> move towards target
	if attack_range < hex_distance_to(attack_target):
		set_move_target(attack_target._hex_coord)
		return
	# attack ready -> attack target
	if attack_timer < 0:
		attack_timer = attack_speed # this loses some speed due to frame rate (delta)
		attack_target.receive_attack(damage)

func receive_attack(dmg: int):
	health -= dmg
	health_changed.emit(health)
	if health <= 0:
		died.emit(self)
		targetable = false

# Target closest enemy
func targeting(_allies: Array[Unit], enemies: Array[Unit]) -> Unit:
	var target = null
	for enemy in enemies:
		if enemy.targetable:
			# if target doesn't exist or enemy closer than target
			if target == null or distance_to(enemy) < distance_to(target):
				target = enemy
	return target

func distance_to(other: Unit) -> float:
	return _position.distance_to(other._position)

func hex_distance_to(other: Unit) -> int:
	return Coord.hex_distance(_hex_coord, other._hex_coord)

func set_hex_coord(coord: Vector2i):
	_hex_coord = coord
	update_position(Coord.to_position(coord))

func update_position(new_pos: Vector2):
	_position = new_pos
	position_changed.emit(_position)
