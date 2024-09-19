class_name CalloutMenu
extends CommandMenu

func _init() -> void:
	name = "Callout"
	commands = [
		DummyCommand.new("Command"),
		DummyCommand.new("Alert"),
		DummyCommand.new("Warning"),
		DummyCommand.new("Tactics"),
		DummyCommand.new("Surprise")
	]
