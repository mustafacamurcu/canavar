class_name MapNode
extends Area2D

@onready var sprite = $Sprite2D
@onready var order = $Order


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_released():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				SignalBus.node_selected.emit(self)

func _mouse_enter() -> void:
	sprite.scale = Vector2(0.2, 0.2)
	
func _mouse_exit() -> void:
	sprite.scale = Vector2(0.15, 0.15)

func set_order(o: int) -> void:
	order.text = str(o)
