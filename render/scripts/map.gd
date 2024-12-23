class_name Map
extends Node2D

const ICON = preload("res://render/scenes/icon.tscn")
const MAP_SPEED = 100
const NODE_TRIGGER_RANGE = 75

@onready var home = %Home

var leader: Icon
var camps: Array[MapNode]
var destination: MapNode
var traveling = false
var locked = false

func _ready() -> void:
	leader = ICON.instantiate()
	add_child(leader)
	leader.set_icon("res://assets/warrior.png")
	leader.scale = Vector2(.1, .1)
	leader.position = home.position
	SignalBus.node_selected.connect(_on_node_selected)

func _on_node_selected(node: MapNode) -> void:
	if locked:
		return
	destination = node
	traveling = true
	locked = true

func _process(delta: float) -> void:
	if traveling:
		leader.position = leader.position.move_toward(destination.position, delta * MAP_SPEED)
		if destination.position.distance_to(leader.position) < NODE_TRIGGER_RANGE:
			traveling = false
			SignalBus.node_reached.emit(destination)
			destination = null