extends Node

# Input Events
signal escape_pressed

# Main Menu Buttons
signal start_game_pressed
signal options_pressed
signal quit_pressed

# Map
signal node_selected(node: MapNode)
signal node_reached(node: MapNode)

# Planning Buttons
signal start_battle_pressed

# Game State
signal path_updated(path: Array[MapNode])