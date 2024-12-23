class_name Icon
extends Node2D

@onready var icon: Sprite2D = %Icon

func set_icon(path: String) -> void:
	icon.texture = load(path)
