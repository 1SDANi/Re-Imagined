class_name SummonMenu
extends CommandMenu

func _init() -> void:
	name = "Summon"
	commands = [
		DummyCommand.new("Simba"),
		DummyCommand.new("Dumbo"),
		DummyCommand.new("Bambi"),
		DummyCommand.new("Genie"),
		DummyCommand.new("Tinker Bell")
	]
