class_name FormMenu
extends CommandMenu

func _init() -> void:
	name = "Form"
	commands = [
		DummyCommand.new("Salamander"),
		DummyCommand.new("Sylph"),
		DummyCommand.new("Yuki-Onna"),
		DummyCommand.new("Thunderbird"),
		DummyCommand.new("Tzitzimimeh"),
		DummyCommand.new("Pixie"),
		DummyCommand.new("Heartless")
	]
