extends Node2D

@onready var icon: Sprite2D = %Icon

var model: Unit

var health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_model(unit: Unit):
	model = unit
	unit.health_changed.connect(_on_health_changed)

func _on_health_changed(h: float):
	health = h