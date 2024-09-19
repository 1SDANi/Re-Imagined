class_name ItemMenu
extends CommandMenu

func _init() -> void:
	name = "Item"
	commands = [
		DummyCommand.new("Potion"),
		DummyCommand.new("Ether"),
		DummyCommand.new("Ambrosia"),
		DummyCommand.new("Ichor"),
		DummyCommand.new("Elixir"),
		DummyCommand.new("Panacea"),
		DummyCommand.new("Phoenix Down")
	]
