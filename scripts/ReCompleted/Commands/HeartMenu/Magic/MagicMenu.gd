class_name MagicMenu
extends CommandMenu

func _init() -> void:
	name = "Magic"
	commands = [
		DummyCommand.new("Aero"),
		DummyCommand.new("Gravity"),
		DummyCommand.new("Animus"),
		DummyCommand.new("Fire"),
		DummyCommand.new("Blizzard"),
		DummyCommand.new("Thunder")
	]
