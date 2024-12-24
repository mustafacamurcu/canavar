extends Node2D

const UNIT_VIEW = preload("res://render/scenes/unit_view.tscn")

var battle
var units: Array[Unit]

func _ready() -> void:
	battle = Game.battle
	units.append_array(battle.allies)
	units.append_array(battle.enemies)
	for unit in units:
		var unit_view = UNIT_VIEW.instantiate()
		unit_view.unit = unit
		add_child(unit_view)

func _draw() -> void:
	var hexboard = Game.battle.hexboard
	for coord in hexboard.keys():
		var hexagon = Coord.corners(coord)
		hexagon.append(hexagon[0])
		draw_polyline(hexagon, Color.BLACK)