class_name CharacterInList
extends PanelContainer

@onready var label: Label = %Label
@onready var icon: TextureRect = %Icon

func setup(character: Character) -> void:
	label.text = character.title
	icon.texture = load(character.icon_path)
