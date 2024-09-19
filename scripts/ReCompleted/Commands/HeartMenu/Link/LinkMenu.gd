class_name LinkMenu
extends CommandMenu

func _init() -> void:
	name = "Link"
	commands = [
		DummyCommand.new("Riku"),
		DummyCommand.new("Kairi"),
		DummyCommand.new("Tidus"),
		DummyCommand.new("Wakka"),
		DummyCommand.new("Selphie"),
		DummyCommand.new("Donald"),
		DummyCommand.new("Goofy"),
		DummyCommand.new("Tarzan"),
		DummyCommand.new("Leon"),
		DummyCommand.new("Yuffie"),
		DummyCommand.new("Aerith")
	]
