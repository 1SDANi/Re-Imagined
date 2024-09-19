class_name FocusMenu
extends CommandMenu

func _init() -> void:
	name = "Focus"
	commands = [
		DummyCommand.new("Crown Charge"),
		DummyCommand.new("Sheathed Charge")
	]
