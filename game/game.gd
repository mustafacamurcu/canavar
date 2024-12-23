extends Node

var units: Array[Unit]

var battle

func _ready() -> void:
	# create allies
	for title in ["warrior", "healer", "explorer", "mage"]:
		var unit: Unit = Unit.new()
		unit.title = title
		unit.icon_path = "res://assets/" + title + ".png"
		units.append(unit)

	# create enemies
	var enemies: Array[Unit] = []
	for title in ["tree", "tree", "tree"]:
		var enemy: Unit = Unit.new()
		enemy.title = title
		enemy.icon_path = "res://assets/monster.png"
		enemies.append(enemy)
	
	battle = Battle.new()
	battle.allies = units
	battle.enemies = enemies
	battle.battle_ended.connect(_on_battle_ended)

func _process(delta: float) -> void:
	if battle:
		battle.tick(delta)

func find_target(targeting: Callable) -> Unit:
	return targeting.call(battle.allies, battle.enemies)

func _on_battle_ended(isWin: bool):
	print(isWin)

func _unhandled_key_input(event):
	if event.is_action('start') and event.is_released():
		battle.start()
