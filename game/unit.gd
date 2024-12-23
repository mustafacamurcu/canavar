class_name Unit
extends Resource

var icon_path: String
var title: String

var position

var damage = 10
var health = 100
var attack_speed = 1

var target: Unit

var attack_timer: float = attack_speed

signal died

func tick(delta: float) -> void:
	attack_timer -= delta
	if attack_timer < 0:
		attack_timer += attack_speed
		attack()

func attack():
	if target == null:
		target = Game.find_target(targeting)
	target.receive_attack(attack)

# Assumes at least one enemy and one ally exists
func targeting(_allies: Array[Unit], enemies: Array[Unit]) -> Unit:
	print(enemies.size())
	var t = enemies[0]
	for enemy in enemies:
		if enemy.position.distance_to(position) < t.position.distance_to(position):
			t = enemy
	
	return t
