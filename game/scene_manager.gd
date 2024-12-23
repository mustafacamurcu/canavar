extends Node

# Scenes
const MAIN_MENU = preload("res://render/scenes/main_menu.tscn")
const MAP = preload("res://render/scenes/map.tscn")
const PLANNING = preload("res://render/scenes/planning.tscn")
const BATTLE = preload("res://render/scenes/battle.tscn")

var main_menu = MAIN_MENU.instantiate()
var map
var planning
var battle

var scene_stack = [main_menu]

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(main_menu)

	# Main Menu Buttons
	SignalBus.start_game_pressed.connect(_on_start_game_pressed)
	SignalBus.options_pressed.connect(_on_options_pressed)
	SignalBus.quit_pressed.connect(_on_quit_pressed)
	
	# Map
	SignalBus.node_reached.connect(_on_node_reached)

	# Input Events
	SignalBus.escape_pressed.connect(_on_escape_pressed)

func _scene_stack_updated():
	for scene in scene_stack:
		scene.hide()
	scene_stack[-1].show()

func _on_start_game_pressed():
	# Navigate to Map scene
	map = MAP.instantiate()
	scene_stack.append(map)
	add_child(map)
	_scene_stack_updated()
	battle = BATTLE.instantiate()
	scene_stack.append(battle)
	add_child(battle)
	_scene_stack_updated()

func _on_options_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()

func _on_escape_pressed():
	print(scene_stack)
	if scene_stack.size() > 1:
		var scene = scene_stack.pop_back()
		scene.queue_free()
	_scene_stack_updated()

func _on_node_reached(_node: MapNode):
	# Navigate to Battle scene
	battle = BATTLE.instantiate()
	scene_stack.append(battle)
	add_child(battle)
	_scene_stack_updated()


# TODO: Implement Input Manager
# Handle keys
func _unhandled_key_input(event):
	if event.is_action('escape') and event.is_released():
		SignalBus.escape_pressed.emit()
