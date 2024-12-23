class_name Battle
extends Resource

var allies: Array[Unit]
var enemies: Array[Unit]

var active = false

signal battle_ended(isWin: bool)

func start():
  active = true
  for unit in allies:
    unit.died.connect(_on_unit_died)

func tick(delta: float) -> void:
  if not active:
    return
  for unit in allies:
    unit.tick(delta)
  for unit in enemies:
    unit.tick(delta)
  
func _on_unit_died(unit: Unit):
  if unit.is_ally:
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