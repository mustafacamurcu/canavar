extends Node

var allies: Array[Unit]

var battle: Battle

func _ready() -> void:
	# create allies
	for title in [Warrior]: # , Warrior, Warrior, Warrior]:
		var ally: Unit = Warrior.new()
		allies.append(ally)
	
	battle = TreeBattle.new()
	battle.place_allies(allies)
	battle.battle_ended.connect(_on_battle_ended)

func _process(delta: float) -> void:
	if battle:
		battle.tick(delta)

func find_target(targeting: Callable) -> Unit:
	if targeting.get_object() in allies:
		return targeting.call(battle.allies, battle.enemies)
	else:
		return targeting.call(battle.enemies, battle.allies)

func _on_battle_ended(isWin: bool):
	battle.stop()
	print(isWin)

func _unhandled_key_input(event):
	if event.is_action('start') and event.is_released():
		battle.start()
