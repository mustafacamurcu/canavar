class_name Planning
extends Node2D

const CHARACTER = preload("res://scenes/character.tscn")
const CHARACTER_IN_LIST = preload("res://scenes/character_in_list.tscn")

@onready var tab_container = $TabContainer
@onready var map = $Map

func _ready() -> void:
	var tab = VBoxContainer.new()
	tab.name = "Character Group"
	tab_container.add_child(tab)
	for character: Character in SceneManager.game.characters:
		var cil := CHARACTER_IN_LIST.instantiate()
		tab.add_child(cil)
		cil.setup(character)

	SignalBus.path_updated.connect(_on_path_updated)


func _on_path_updated(path: Array[MapNode]):
	for node in map.get_children():
		node.order.hide()
	for i in range(path.size()):
		path[i].set_order(i + 1)
		path[i].order.show()
