class_name KataMenu
extends CommandMenu

func _init() -> void:
	name = "Kata"
	commands = [
		DummyCommand.new("Zantetsuken"),
		DummyCommand.new("Blitz"),
		DummyCommand.new("Sonic Blade"),
		DummyCommand.new("Strike Raid"),
		DummyCommand.new("Sliding Rush"),
		DummyCommand.new("Land Crash"),
		DummyCommand.new("Vicinity Break"),
		DummyCommand.new("Hurricane Period")
	]
