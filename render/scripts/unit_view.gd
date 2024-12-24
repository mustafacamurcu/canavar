extends Node2D

@onready var icon: Sprite2D = %Icon
@onready var health_bar: ProgressBar = $HealthBar

var unit: Unit
var title

func _ready() -> void:
	position = unit._position
	health_bar.max_value = unit.health
	health_bar.value = unit.health
	title = unit.title
	icon.texture = load(unit.icon_path)

	unit.position_changed.connect(_on_unit_position_changed)
	unit.health_changed.connect(_on_unit_health_changed)

func _on_unit_position_changed(new_pos: Vector2):
	position = new_pos


func _on_unit_health_changed(health: float):
	health_bar.value = health
